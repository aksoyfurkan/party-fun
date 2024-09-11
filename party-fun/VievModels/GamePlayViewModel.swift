//
//  GamePlayViewModel.swift
//  party-fun
//
//  Created by Furkan on 6.09.2024.
//

import Foundation
class GamePlayViewModel: ObservableObject {
    @Published var players: [Player]
    @Published var selectedPlayer: Player?
    @Published var currentQuestion: Question?
    @Published var remainingQuestions: Int
    
    private let selectedGameTypes: [GameType]
    
    init(players: [Player], selectedGameTypes: [GameType]) {
            self.players = players.map { Player(name: $0.name, score: 0) }  // Yeni Player nesneleri oluştur, skorları sıfırla
            self.selectedGameTypes = selectedGameTypes
            self.remainingQuestions = UserDefaults.standard.integer(forKey: "questionCount")
            if self.remainingQuestions < 5 {
                self.remainingQuestions = 10 // Default value
            }
        }
    
    func selectRandomPlayer() {
        selectedPlayer = players.randomElement()
    }
    
    func fetchRandomQuestion() {
        let gameTypeIds = selectedGameTypes.map { $0.id }
        FirebaseService.shared.getRandomQuestion(for: gameTypeIds, language: LanguageManager.shared.currentLanguage) { [weak self] question in
            DispatchQueue.main.async {
                self?.currentQuestion = question
            }
        }
    }
    
    func handleAnswer(correct: Bool) {
        if let index = players.firstIndex(where: { $0.id == selectedPlayer?.id }) {
            if correct {
                players[index].score += 5
            } else {
                players[index].score = max(0, players[index].score - 3)
            }
        }
        remainingQuestions -= 1
    }
    
    var isGameOver: Bool {
        remainingQuestions <= 0
    }
    
    var winner: Player {
        players.max(by: { $0.score < $1.score })!
    }
}
