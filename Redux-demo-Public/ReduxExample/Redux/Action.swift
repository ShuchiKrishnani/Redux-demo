//
//  Action.swift
//  ReduxExample
//
//  Created by Shuchita Krishnani on 18/05/23.
//

import Foundation

enum Action {
    case fetchUsers
    case setUsers([User])
    case setError(Error)
    case sort
}
