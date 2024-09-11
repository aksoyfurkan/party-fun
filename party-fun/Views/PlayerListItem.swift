//
//  PlayerListItem.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//
import Foundation
import SwiftUI
struct PlayerListItem: View {
    let player: Player
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(player.name)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
            .padding(.trailing)
        }
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
}
