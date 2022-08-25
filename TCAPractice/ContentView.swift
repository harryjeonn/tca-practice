//
//  ContentView.swift
//  TCAPractice
//
//  Created by Harry on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let counterStore = Store(initialState: CounterState(), reducer: counterReducer, environment: CounterEnvironment())
    let memoStore = Store(initialState: MemoState(), reducer: memoReducer, environment: MemoEnvironment(memoClient: MemoClient.live, mainQueue: .main))
    
    var body: some View {
        
        TabView {
            CounterView(store: counterStore)
                .tabItem {
                    Image(systemName: "number.square")
                    Text("Counter")
                }
            
            MemoView(store: memoStore)
                .tabItem {
                    Text("Memo")
                    Image(systemName: "note.text")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
