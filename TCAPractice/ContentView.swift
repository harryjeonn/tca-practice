//
//  ContentView.swift
//  TCAPractice
//
//  Created by Harry on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @State var selection: Int = 2
    
    var body: some View {
        
        TabView(selection: $selection) {
            CounterView()
                .tabItem {
                    Image(systemName: "number.square")
                    Text("Counter")
                }
                .tag(0)
            
            MemoView()
                .tabItem {
                    Text("Memo")
                    Image(systemName: "note.text")
                }
                .tag(1)
            
            TodoView()
                .tabItem {
                    Text("Todo")
                    Image(systemName: "calendar")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
