//
//  HomeViewModel.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var selectedGameTypes: [GameType] = []
        
    func removePlayer(_ player: Player) {
            players.removeAll { $0.id == player.id }
        }
    func addPlayer(_ name: String) {
            let newPlayer = Player(name: name)
            players.append(newPlayer)
        }
    
    func removePlayer(at offsets: IndexSet) {
            players.remove(atOffsets: offsets)
        }
}
