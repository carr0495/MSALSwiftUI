//
//  AppModel.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import Foundation
import SwiftUI



@Observable class AppModel {
  
  //our msal properties.
  var msalProperties : MSALProperties = MSALProperties()
  
  //Navigation
  var navPath : NavigationPath = NavigationPath()
  var navPathBinding: Binding<NavigationPath> {
    Binding {
      self.navPath
    } set: { value in
      self.navPath = value
    }
  }
  
}


