//
//  MemoClient.swift
//  TCAPractice
//
//  Created by Harry on 2022/08/25.
//

import Foundation
import ComposableArchitecture

// API 통신
struct MemoClient {
    
    // 외부에서 일어난 일을 다시 Store로 가져와서 상태를 변경시킬 때 Effect 사용
    var fetchMemoItem: (_ id: String) -> Effect<Memo, Failure>
    
    var fetchMemos: () -> Effect<[Memo], Failure>
    
    struct Failure: Error, Equatable {}
}

extension MemoClient {
    static let live = MemoClient(
        fetchMemoItem: { id in
            Effect.task {
                let (data, _) = try await URLSession.shared
                    .data(from: URL(string: "https://6306de30c0d0f2b801229fb8.mockapi.io/api/memo/\(id)")!)
                return try JSONDecoder().decode(Memo.self, from: data)
            }
            .mapError { _ in Failure() }
            .eraseToEffect()
        }, fetchMemos: {
            Effect.task {
                let (data, _) = try await URLSession.shared
                    .data(from: URL(string: "https://6306de30c0d0f2b801229fb8.mockapi.io/api/memo/")!)
                return try JSONDecoder().decode([Memo].self, from: data)
            }
            .mapError { _ in Failure() }
            .eraseToEffect()
        }
    )
}
