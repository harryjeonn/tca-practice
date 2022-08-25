//
//  MemoView.swift
//  TCAPractice
//
//  Created by Harry on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

// 상태
struct MemoState: Equatable {
    var memos: [Memo] = []
    var selectedMemo: Memo? = nil
    var isLoading: Bool = false
}

// 액션
enum MemoAction: Equatable {
    case fetchItem(_ id: String) // 단일 조회
    case fetchItemResponse(Result<Memo, MemoClient.Failure>)   // 단일 조회 액션 응답
    case fetchAll // 전체 조회
    case fetchAllResponse(Result<[Memo], MemoClient.Failure>)   // 전체 조회 액션 응답
}

// 환경 설정
struct MemoEnvironment {
    var memoClient: MemoClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// State, Action, Environment를 받는다.
// Reducer가 완료가 된 다음에 변경이 된 상태를 반환한다.
let memoReducer = Reducer<MemoState, MemoAction, MemoEnvironment> { state, action, environment in
    // 들어온 Action에 따라 상태를 변경
    switch action {
    case .fetchItem(let memoId):
        enum FetchItemId {}
        state.isLoading = true
        return environment.memoClient
            .fetchMemoItem(memoId)
            .debounce(id: FetchItemId.self,
                      for: 0.3,
                      scheduler: environment.mainQueue)
            .catchToEffect(MemoAction.fetchItemResponse)
        
    case .fetchItemResponse(.success(let memo)):
        state.selectedMemo = memo
        state.isLoading = false
        return Effect.none
        
    case .fetchItemResponse(.failure):
        state.selectedMemo = nil
        state.isLoading = true
        return Effect.none
        
    case .fetchAll:
        enum FetchAllId {}
        state.isLoading = true
        return environment.memoClient
            .fetchMemos()
            .debounce(id: FetchAllId.self,
                      for: 0.3,
                      scheduler: environment.mainQueue)
            .catchToEffect(MemoAction.fetchAllResponse)
        
    case .fetchAllResponse(.success(let memos)):
        state.memos = memos
        state.isLoading = false
        return Effect.none
        
    case .fetchAllResponse(.failure):
        state.memos = []
        state.isLoading = true
        return Effect.none
    }
}

struct MemoView: View {
    // Store는 State와 Action을 가지고 있음
    let store: Store<MemoState, MemoAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                if viewStore.state.isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .overlay {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.7)
                        }.zIndex(1)
                }
                
                List {
                    Section {
                        ForEach(viewStore.state.memos) { memo in
                            Button(memo.name, action: { viewStore.send(.fetchItem(memo.id), animation: .default) })
                        }
                    } header: {
                        VStack(spacing: 12) {
                            Button("메모 목록 가져오기", action: { viewStore.send(.fetchAll, animation: .default) })
                            Text("선택된 메모")
                            Text(viewStore.state.selectedMemo?.id ?? "-")
                            Text(viewStore.state.selectedMemo?.name ?? "-")
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

//struct MemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoView()
//    }
//}
