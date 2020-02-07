//
//  User.swift
//  FoodieFun
//
//  Created by Aaron Cleveland on 2/4/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
    var email: String
    var location: String
}
