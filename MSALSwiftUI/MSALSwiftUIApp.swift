//
//  MSALSwiftUIApp.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import SwiftUI

@main
struct MSALSwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(AppModel())
    }
  }
}
