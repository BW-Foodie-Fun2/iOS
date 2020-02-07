//
//  UserRepresentation.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/4/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    let username: String
    let password: String
    let email: String
    let location: String
}
