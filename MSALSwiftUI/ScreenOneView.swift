//
//  ScreenOneView.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import SwiftUI

struct ScreenOneView: View {
  @Environment(AppModel.self) var model
  
    var body: some View {
      VStack{
        Text("IM THE ScreenOne VIEW💩")
        Button(action:{
          Task {
            try await model.interactiveLogin()
          }
        }){
          Text("Interactive Login!!")
        }
        Spacer()
      }
    }
}

#Preview {
    ScreenOneView()
    .environment(AppModel())
}
