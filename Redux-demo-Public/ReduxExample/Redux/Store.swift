//
//  Store.swift
//  ReduxExample
//
//  Created by Shuchita Krishnani on 18/05/23.
//

import Foundation
import Combine
import Network

final class Store: ObservableObject {
    @Published private(set) var state: AppState
    private let reducer: Reducer
    let sideEffect: SideEffect<AppState, Action>
    
    init(state: AppState, reducer: Reducer,  sideEffect: @escaping SideEffect<AppState, Action>) {
        self.state = state
        self.reducer = reducer
        self.sideEffect = sideEffect
    }
    private var allCancellables: Set<AnyCancellable> = []
    func dispatch(action: Action) {
       reducer.reduce(appState: &state, action: action)
        guard let sideEffect = sideEffect(state, action) else { return }
        sideEffect
            .sink(receiveValue: dispatch)
            .store(in: &allCancellables)
    }
}

struct Service {
    func fetchUserList() -> AnyPublisher<[User], Error> {
        var request = URLRequest(url: (URL(string: "https://api.github.com/users") ?? URL(string:""))!)
        request.httpMethod = "Get"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                            throw URLError(.badServerResponse)
                        }
                    return element.data
                    }
            .mapError { error in
                return URLError(.badServerResponse)
            }
                .decode(type: [User].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}
