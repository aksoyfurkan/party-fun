//
//  Questions.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//
import Foundation

struct Question: Identifiable {
    let id: String
    let gameTypeId: String
    let text: [String: String]
    
    var localizedText: String {
        return text[LanguageManager.shared.currentLanguage] ?? text["en"] ?? ""
    }
}
