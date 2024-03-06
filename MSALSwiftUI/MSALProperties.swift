//
//  MSALProperties.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import Foundation
import MSAL

struct Token {
  var value: String
  var expiry: Date?
}


struct MSALProperties {
  var account : MSALAccount?
  var clientID : String?      = "d1969185-57c4-405f-8fe7-475854abd807"
  var redirectUri : String?   = "msauth.com.carrie.aiden.MSALSwiftUI://auth"
  var authorityUrl : String?  = "https://login.microsoftonline.com/8579326f-5aee-4683-9a87-c93740220d50/oauth2/v2.0/authorize"
  var authority : MSALAADAuthority?
  var scopes : [String]?      = ["user.read"]
  var token : Token?
  var application : MSALPublicClientApplication?
  var interactiveParameters : MSALInteractiveTokenParameters?
  var webviewParams : MSALWebviewParameters?

}
