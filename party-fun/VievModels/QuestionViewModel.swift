//
//  QuestionViewModel.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import Foundation

class QuestionViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    private let gameTypeIds: [String]

    init(gameTypeIds: [String]) {
        self.gameTypeIds = gameTypeIds
    }

    func fetchRandomQuestion() {
        FirebaseService.shared.getRandomQuestion(for: gameTypeIds, language: "en") { [weak self] question in
            DispatchQueue.main.async {
                self?.currentQuestion = question
            }
        }
    }
}
