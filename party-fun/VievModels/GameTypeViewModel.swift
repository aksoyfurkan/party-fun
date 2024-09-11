//
//  GameTypeViewModel.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//
import Combine
import SwiftUI

class GameTypeViewModel: ObservableObject {
    @Published var gameTypes: [GameType] = []
    @Published var currentLanguage: String = LanguageManager.shared.currentLanguage
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupLanguageChangeObserver()
        fetchGameTypes()
    }
    
    private func setupLanguageChangeObserver() {
        LanguageManager.shared.$currentLanguage
            .sink { [weak self] newLanguage in
                self?.currentLanguage = newLanguage
                self?.fetchGameTypes()
            }
            .store(in: &cancellables)
    }
    
    func fetchGameTypes() {
        FirebaseService.shared.getGameTypes(language: currentLanguage) { [weak self] gameTypes in
            DispatchQueue.main.async {
                self?.gameTypes = gameTypes
            }
        }
    }
    
    func toggleSelection(for gameType: GameType) {
        if let index = gameTypes.firstIndex(where: { $0.id == gameType.id }) {
            gameTypes[index].isSelected.toggle()
        }
    }
}
