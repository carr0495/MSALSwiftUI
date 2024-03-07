//
//  ContentView.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import SwiftUI

struct ContentView: View {
  
  @Environment(AppModel.self) var model
  
  var body: some View {
    NavigationStack(path: model.navPathBinding){
      VStack {
        Button(action:{
          Task{
            try await model.interactiveLogin()
          }
        }){
          Text("Interactive Login")
        }
        Button(action:{
          Task{
            try await model.acquireTokenSilently()
          }
        }){
          Text("Silent Login👀")
        }
        .buttonStyle(.borderedProminent)
      }
      .navigationDestination(for: AppModel.Destination.self) { page in
        switch page {
        case .home :
          EmptyView()
        case .login :
          EmptyView()
        case .screenOne :
          EmptyView()
        }
      }
    }
    .overlay{
      MSALViewController()
        .frame(width: 1, height: 1)
    }
  }
}

#Preview {
    ContentView()
    .environment(AppModel())
}
