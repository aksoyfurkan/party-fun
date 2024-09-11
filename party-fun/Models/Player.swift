//
//  Player.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    let name: String
    var score: Int = 0
}
