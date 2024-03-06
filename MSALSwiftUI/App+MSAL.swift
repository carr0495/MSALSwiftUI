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
    case login
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
  
}
