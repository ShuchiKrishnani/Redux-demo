//
//  Reducer.swift
//  ReduxExample
//
//  Created by Shuchita Krishnani on 18/05/23.
//

import Foundation

class Reducer {
    func reduce( appState: inout AppState, action: Action) {
        switch action {
        case .fetchUsers:
            appState.viewState = .loading
        case .setUsers(let users):
             appState.users.append(contentsOf: users)
             appState.viewState = .loaded
        case .sort:
            appState.sort()
            appState.viewState = .loaded
        case .setError:
            appState.viewState = .failed

        }
    }
}
