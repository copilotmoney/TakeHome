//
//  Bird.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

import Foundation

struct Bird {
    let id: String
    let nameSpanish: String
    let nameEnglish: String
    let nameLatin: String
    let thumbImageUrl: String
    let fullImageUrl: String
    let sortIndex: Int
    var notes: [Note]?
}

struct Note: Codable {
    let userID: String
    let content: String
    let timestamp: TimeInterval
}
