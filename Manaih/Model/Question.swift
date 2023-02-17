//
//  Question.swift
//  Manaih
//
//  Created by Soyombo Mantaagiin on 17.02.2023.
//

import SwiftUI

struct Question: Identifiable, Codable {
    var id: UUID = .init()
    var question: String
    var options: [String]
    var answer: String
    
    var tappedAnswer: String = ""
    
    enum CodingKeys: CodingKey {
        case question
        case options
        case answer
    }
}


