//
//  File.swift
//  ReduxExample
//
//  Created by Shuchita Krishnani on 18/05/23.
//

import Foundation
import SwiftUI

struct User: Decodable {
    let login: String
    let id: Int
    let avatar_url: String
}
