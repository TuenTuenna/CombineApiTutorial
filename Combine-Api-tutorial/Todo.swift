//
//  Todo.swift
//  Combine-Api-tutorial
//
//  Created by Jeff Jeong on 2022/06/03.
//

import Foundation

// MARK: - Todo
struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
