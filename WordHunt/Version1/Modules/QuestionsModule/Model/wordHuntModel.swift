//
//  wordHuntModel.swift
//  WordHunt
//
//  Created by APPLE on 19/05/23.
//

import Foundation
struct WordHuntElement: Codable {
    let id: String
    let chars: [String]
    let answers: [Answer]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case chars, answers
    }
}

// MARK: - Answer
struct Answer: Codable {
    let id, word, hint: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case word, hint
    }
}
