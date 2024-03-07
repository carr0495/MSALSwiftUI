//
//  HomeView.swift
//  MSALSwiftUI
//
//  Created by Aiden Carrie on 2024-03-06.
//

import SwiftUI

struct HomeView: View {
  
  @Environment(AppModel.self) var model
  
    var body: some View {
      VStack{
        Text("IM THE HOME VIEW🧛‍♂️")
        Button(action:{model.navigate(to: .screenOne)}){
          Text("Navigate deeper...")
        }
      }
    }
}

#Preview {
    HomeView()
    .environment(AppModel())
}
