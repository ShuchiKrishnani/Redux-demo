//
//  ContentView.swift
//  ReduxExample
//
//  Created by Purva Rode Patil on 14/05/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store
    
    init() {
        store = Store(
            state: AppState(users: [], viewState: .loading),
            reducer: Reducer(),
            sideEffect: fetchUserSideEffect(service: Service())
        )
        store.dispatch(action: .fetchUsers)
    }
    
    var body: some View {
        VStack {
            Spacer()
                   NavigationStack {
                       switch store.state.viewState {
                       case .loading:
                           Label("Loading...", systemImage: "book.fill")
                               .labelStyle(TitleOnlyLabelStyle())
                       case .loaded:
                           List(store.state.users, id: \.id) { user in
                               NavigationLink {
                                   UserDetailView(userDetails: user).environmentObject(store)
                               } label: {
                                   UserView(user: user).environmentObject(store)
                               }
                           }
                           .navigationTitle("Select a user")
                       case .failed:
                           Label("Something went wrong!!", systemImage: "book.fill")
                               .labelStyle(TitleOnlyLabelStyle())
                       }
                   }
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                fetchAccountList()
            }
        }
    }
    private func fetchAccountList() {
        store.dispatch(action: .fetchUsers)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserDetailView: View {
    @EnvironmentObject private var store: Store
    var userDetails: User

    var body: some View {
        Text(userDetails.login)
            .padding()
            .background(.yellow)
    }
}

struct UserView: View {
    @EnvironmentObject private var store: Store
    var user: User

    var body: some View {
        HStack {
            Image(systemName: "star")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(user.login)
                .font(.body)
                .padding()
            Spacer()
        }
        .contentShape(Rectangle())
        Spacer()
    }
}
