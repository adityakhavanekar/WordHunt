//
//  wordHuntModel.swift
//  WordHunt
//
//  Created by APPLE on 19/05/23.
//

import Foundation
struct WordHuntElement: Codable {
    let id: String
    var chars: [String]
    var answers: [Answer]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case chars, answers
    }
}

// MARK: - Answer
struct Answer: Codable {
    let word, hint: String
}
