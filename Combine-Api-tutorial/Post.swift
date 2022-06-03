//
//  Post.swift
//  Combine-Api-tutorial
//
//  Created by Jeff Jeong on 2022/06/03.
//

import Foundation
// MARK: - Post
struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
