//
//  SideEffect.swift
//  ReduxExample
//
//  Created by Shuchita Krishnani on 18/05/23.
//

import Foundation
import Combine

/*
 In Redux, a Middleware is an entity (function) that is executed when certain Actions go through the Store. It receives a copy of the current AppState, performs some operations (API calls, or async tasks), and dispatches a new Action.

 Middlewares take care of all the heavy load in the background (like API call, database fetches and updates, etc…) while Reducers simple deal with updating our state synchronously. Let’s update the store to support Middlewares.


 */
typealias SideEffect<State, Action> = (State, Action) -> AnyPublisher<Action, Never>?

func fetchUserSideEffect(service: Service) -> SideEffect<AppState, Action>  {
    return { state, action in
        switch action {
            
        case .fetchUsers:
            return service.fetchUserList()
                .receive(on: DispatchQueue.main)
                .print("debugging")
                 .map {
                    print($0)
                   return  Action.setUsers($0)
                }
                 .catch({ (error) -> Just<Action> in
                     return Just(Action.setError(error))
                 })
                .eraseToAnyPublisher()
        default :
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}
