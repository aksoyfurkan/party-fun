//
//  GameType.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

struct GameType: Identifiable, Hashable {
    let id: String
    let name: [String: String]
    let description: [String: String]
    let imageUrl: String
    var isSelected: Bool = false
    var playerCount: Int?
    
    func localizedName(for language: String) -> String {
        return name[language] ?? name["en"] ?? ""
    }
    
    func localizedDescription(for language: String) -> String {
        return description[language] ?? description["en"] ?? ""
    }
}
