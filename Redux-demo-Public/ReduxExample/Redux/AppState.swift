//
//  AppState.swift
//  ReduxExample
//
//  Created by Shuchita Krishnani on 18/05/23.
//

import Foundation

enum ViewState {
    case loading
    case loaded
    case failed
}

struct AppState {
    var users: [User]
    var viewState: ViewState
    
    mutating func sort() {
        users.sort { $0.login > $1.login }
    }
}
