//
//  WordHuntModelV2.swift
//  WordHunt
//
//  Created by Neosoft on 15/09/23.
//

import Foundation

import Foundation
struct WordHuntElementV2: Codable {
    let id: String
    var chars: [String]
    var answers: [Answer]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case chars, answers
    }
}

// MARK: - Answer
struct AnswerV2: Codable {
    let word, hint: String
}
