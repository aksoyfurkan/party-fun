//
//  firebaseservice.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import Foundation
import Firebase

class FirebaseService {
    static let shared = FirebaseService()
    private init() {}
    
    func getGameTypes(language: String, completion: @escaping ([GameType]) -> Void) {
        let ref = Database.database(url: "https://quizgame-62b5d-default-rtdb.firebaseio.com/").reference().child("gameTypes")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion([])
                return
            }
            
            let gameTypes = value.compactMap { (key, value) -> GameType? in
                guard let name = value["name"] as? [String: String],
                      let description = value["description"] as? [String: String],
                      let imageUrl = value["imageUrl"] as? String,
                      let localizedName = name[language],
                      let localizedDescription = description[language] else {
                    return nil
                }
                return GameType(id: key, name: [language: localizedName], description: [language: localizedDescription], imageUrl: imageUrl)
            }
            
            completion(gameTypes)
        }
    }
    
    func getRandomQuestion(for gameTypeIds: [String], language: String, completion: @escaping (Question?) -> Void) {
        let ref = Database.database(url: "https://quizgame-62b5d-default-rtdb.firebaseio.com/").reference().child("questions")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            let questions = value.compactMap { (key, value) -> Question? in
                guard let gameTypeId = value["gameTypeId"] as? String,
                      gameTypeIds.contains(gameTypeId),
                      let text = value["text"] as? [String: String],
                      let questionText = text[language] else {
                    return nil
                }
                return Question(id: key, gameTypeId: gameTypeId, text: [language: questionText])
            }
            
            let randomQuestion = questions.randomElement()
            completion(randomQuestion)
        }
    }
}
