//
//  App+MSAL.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import Foundation
import MSAL

extension AppModel {
  public enum Destination: Codable, Hashable {
    case home
    case screenOne
  }
  func navigate(to destination: Destination) {
    navPath.append(destination)
  }
  
  func navigateBack() {
    navPath.removeLast()
  }
  
  func navigateToRoot() {
    navPath.removeLast(navPath.count)
  }
}
extension AppModel {
  
  func interactiveLogin() async throws {
    
    if let params = self.msalProperties.interactiveParameters, let application = self.msalProperties.application {
      
      params.promptType = .selectAccount
      
      do {
        let result = try await Task<MSALResult, Error> { @MainActor in
          try await application.acquireToken(with: params)
        }.value

          if let token = result.idToken, let exp = result.expiresOn {
            msalProperties.token = Token(value: token, expiry: exp)
          }
          self.msalProperties.account = result.account
          //it worked... now I need to navigate my app somwhere.
          navigate(to: .home)
        
      }
      catch let error as NSError where error.domain == MSALErrorDomain && error.code == MSALError.userCanceled.rawValue {
        print("Canceled")
      } catch {
        print("Could not acquire token: \(error)")
      }
    }else {
      print("Missing interactive properties and Application MSAL")
    }
  }
  
  func acquireTokenSilently() async throws{
    
    if let scopes = self.msalProperties.scopes, let account = self.msalProperties.account, let application = self.msalProperties.application{
      let parameters = MSALSilentTokenParameters(scopes: scopes, account: account)

      do {
        let result = try await application.acquireTokenSilent(with: parameters)

        guard let idToken = result.idToken, let exp = result.expiresOn else {
          print("no token or expiry")
          return
        }
        
        msalProperties.token = Token(value: idToken, expiry: exp)
        self.msalProperties.account = result.account
        //this was a success !!
        //next we want to navigate
        navigate(to: .home)

        
      } catch let error as NSError where error.domain == MSALErrorDomain &&
                error.code == MSALError.interactionRequired.rawValue {
        print("Could not acquire token silently: \(error)")
        return try await interactiveLogin() //if I cant get it silently... Interactive!
      } catch {
        print("silentTokenError : \(error)")
      }
    }else{
      print("application, scopes,account,parameters could be nil ... check")
      print("scopes: \(msalProperties.scopes)")
      print("application: \(msalProperties.application)")
      print("account: \(msalProperties.account)")
    }
  }
  
  public func checkAccountThenLogin() async throws {
    
    //check if account exists then decide whether new login or
    
    if let account = msalProperties.account {
  
    try await acquireTokenSilently()

    }else{
      // no account
      if let app = msalProperties.application {

        do {
          guard let account = try await getAccount(application: app) else {
            return try await interactiveLogin()
          }
          print("Found a signed in account \(String(describing: account.username!)). Updating data for that account...")
          msalProperties.account = account
          try await acquireTokenSilently()
        } catch {
          print("Couldn't query current account with error: \(error)")
        }
      }else {
        print("no application when loading current account")
      }
    }
  }
  
  func getAccount(application: MSALPublicClientApplication) async throws -> MSALAccount? {
    var currentAccount: MSALAccount?
    do {
      let cachedAccounts = try application.allAccounts()
      if !cachedAccounts.isEmpty {
        currentAccount = cachedAccounts.first
        print("current accoount: \(currentAccount?.username ?? "n/a")")
      }
    } catch {
      print("Didn't find any accounts in cache: \(error)")
    }
    return currentAccount
  }
  
  public func logout() async throws {

    guard let account = self.msalProperties.account else { return }
    
    if let application = self.msalProperties.application {
      _ = try await removeAllAccounts()
      
      Task {
        {
          if let webViewParams = self.msalProperties.webviewParams {
            let signoutParameters = MSALSignoutParameters(webviewParameters: webViewParams)
            signoutParameters.signoutFromBrowser = false
            DispatchQueue.main.async {
              self.msalProperties.account = nil
              self.msalProperties.token = nil
              application.signout(with: account, signoutParameters: signoutParameters, completionBlock: {(success, error) in
                if let error = error {
                  print("Couldn't sign out account with error: \(error)")
                  return
                }

                print("Sign out SUCCESS")
                self.navigateToRoot()
              })
            }
          }else {
            print("NO WEBVIEW PARAMS FOR LOGGING OUT")
          }
         
        }()
      }
      
    }
  }
  
  func removeAllAccounts() async throws -> MSALAccount? {
    
    var currentAccount: MSALAccount?
    
    if let application = self.msalProperties.application {
      
      do {
        var cachedAccounts = try application.allAccounts()
        if !cachedAccounts.isEmpty {
          cachedAccounts.removeAll()
          print("Cached accounts removed")
        }
      } catch {
        print("Didn't find any accounts in cache: \(error)")
      }
      return currentAccount
    }
    
    return currentAccount
  }
  
}
