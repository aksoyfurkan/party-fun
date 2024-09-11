//
//  GameTypeView.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import SwiftUI

struct GameTypeView: View {
    @StateObject private var viewModel = GameTypeViewModel()
    @Binding var selectedGameTypes: [GameType]
    @State private var showingGamePlayView = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.gameTypes) { gameType in
                        GameTypeCell(gameType: gameType, language: viewModel.currentLanguage, isSelected: Binding(
                            get: { gameType.isSelected },
                            set: { _ in viewModel.toggleSelection(for: gameType) }
                        ))
                    }
                }
                .padding()
            }
            
            Button(action: {
                            selectedGameTypes = viewModel.gameTypes.filter { $0.isSelected }
                            showingGamePlayView = true
                        }) {
                            Text("PLAY")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding()
                        .disabled(viewModel.gameTypes.filter { $0.isSelected }.isEmpty)
                    }
                    .background(Color(UIColor.systemGray6))
                    .navigationTitle("Select Game Types")
                    .sheet(isPresented: $showingGamePlayView) {
                        GamePlayView(players: homeViewModel.players, selectedGameTypes: selectedGameTypes)
                            .environmentObject(homeViewModel)
                    }
                }
            }
struct GameTypeCell: View {
    let gameType: GameType
    let language: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: gameType.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(gameType.localizedName(for: language))
                    .font(.headline)
                Text(gameType.localizedDescription(for: language))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let playerCount = gameType.playerCount {
                Text("\(playerCount) players")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}
