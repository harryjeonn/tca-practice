//
//  CounterView.swift
//  TCAPractice
//
//  Created by Harry on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

// 상태
struct CounterState: Equatable {
    var count = 0
}

// 액션
enum CounterAction: Equatable {
    case addCount
    case subtractCount
}

struct CounterEnvironment {}

// State, Action, Environment를 받는다.
// Reducer가 완료가 된 다음에 변경이 된 상태를 반환한다.
let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
    // 들어온 Action에 따라 상태를 변경
    switch action {
    case .addCount:
        state.count += 1
        return Effect.none
    case .subtractCount:
        state.count -= 1
        return Effect.none
    }
}

struct CounterView: View {
    // Store는 State와 Action을 가지고 있음
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("\(viewStore.state.count)")
                    .padding()
                
                HStack {
                    Button("Add", action: { viewStore.send(.addCount) })
                    Button("Substract", action: { viewStore.send(.subtractCount) })
                }
            }
        }
    }
}

//struct CounterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterView()
//    }
//}
