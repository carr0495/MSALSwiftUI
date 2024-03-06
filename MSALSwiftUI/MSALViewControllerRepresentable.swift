//
//  MSALViewControllerRepresentable.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import Foundation
import SwiftUI
import MSAL

struct MSALViewController : UIViewControllerRepresentable {
  
  @Environment(AppModel.self) var model
  
  func makeUIViewController(context: Context)  -> UIViewController {
    
    let viewController =  UIViewController()
    
    if let authURL = model.msalProperties.authorityUrl,
       let clientID = model.msalProperties.clientID,
       let redirectUri = model.msalProperties.redirectUri,
       let scopes = model.msalProperties.scopes
    {
      guard let authorityURL = URL(string: authURL) else {
        print("Unable to create authority URL")
        return viewController
      }
      
      let authority : MSALAADAuthority?
      do {
        authority = try MSALAADAuthority(url: authorityURL)
        
        let config = MSALPublicClientApplicationConfig(
          clientId: clientID,
          redirectUri: redirectUri,
          authority:  authority)
        
        if let application = try? MSALPublicClientApplication(configuration: config) {
          let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)
          
          let interactiveParameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
          
          model.msalProperties = MSALProperties(authority: authority, application: application, interactiveParameters: interactiveParameters, webviewParams: webviewParameters)
        }
        else {print("Unable to create application.")}
      }
      catch {print("Unable to create authority URL")}
    }
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
  
}
