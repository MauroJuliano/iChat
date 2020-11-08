//
//  User.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import Foundation

class User{
    var name: String
    var lastMessage: String
    var image: String
    init(name: String, lastMessage: String, image: String) {
        self.name = name
        self.lastMessage = lastMessage
        self.image = image
    }
}
