//
//  GameViewModel.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var currentPlayer: Player
    
    private var selectedGameTypes: [GameType]
    private var players: [Player]
    private var currentPlayerIndex = 0
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentLanguage: String
    
    init(selectedGameTypes: [GameType], players: [Player]) {
        self.selectedGameTypes = selectedGameTypes
        self.players = players
        self.currentPlayer = players[0]
        self.currentLanguage = LanguageManager.shared.currentLanguage
        setupLanguageChangeObserver()
    }
    
    private func setupLanguageChangeObserver() {
        LanguageManager.shared.$currentLanguage
            .sink { [weak self] newLanguage in
                self?.currentLanguage = newLanguage
                self?.nextQuestion()
            }
            .store(in: &cancellables)
    }
    
    func startGame() {
        nextQuestion()
    }
    
    func nextQuestion() {
        let gameTypeIds = selectedGameTypes.map { $0.id }
        FirebaseService.shared.getRandomQuestion(for: gameTypeIds, language: currentLanguage) { [weak self] question in
            DispatchQueue.main.async {
                self?.currentQuestion = question
                self?.moveToNextPlayer()
            }
        }
    }
    
    private func moveToNextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        currentPlayer = players[currentPlayerIndex]
    }
}
