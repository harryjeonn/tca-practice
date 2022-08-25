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
    
    var body: some View {
        CounterView(store: counterStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
