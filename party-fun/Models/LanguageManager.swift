//
//  LanguageManager.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import Foundation
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    private init() {
        currentLanguage = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
