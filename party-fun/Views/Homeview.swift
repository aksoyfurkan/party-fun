//
//  Homeview.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var newPlayerName = ""
    @State private var showSettings = false
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.red.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .padding()
                    
                    Image("party_roulette_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    Text("Players list")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.players) { player in
                                PlayerListItem(player: player) {
                                    withAnimation(.spring()) {
                                        viewModel.removePlayer(player)
                                    }
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding()
                    }
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.bottom)
                    
                    HStack {
                        TextField("Add a new player", text: $newPlayerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        
                        Button(action: addPlayer) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    NavigationLink(destination:
                                        GameTypeView(selectedGameTypes: $viewModel.selectedGameTypes)
                                            .environmentObject(viewModel)
                                    ) {
                                        Text("Play")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(isPresented: $showSettings)
        }
    }
    
    private func addPlayer() {
        guard !newPlayerName.isEmpty else { return }
        withAnimation(.spring()) {
            viewModel.addPlayer(newPlayerName)
        }
        newPlayerName = ""
    }
}


struct PlayerListView: View {
    @Binding var players: [Player]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Players list")
                .font(.headline)
                .padding(.bottom, 5)

            VStack(spacing: 0) {
                ForEach(players) { player in
                    HStack {
                        Text(player.name)
                            .padding(.vertical, 10)
                        Spacer()
                        Button(action: {
                            players.removeAll { $0.id == player.id }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    if player.id != players.last?.id {
                        Divider()
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(15)
    }
}

struct AddPlayerView: View {
    @Binding var newPlayerName: String
    var addPlayer: () -> Void

    var body: some View {
        HStack {
            TextField("Add a new player", text: $newPlayerName)
                .padding()
                .background(Color.white)
                .cornerRadius(10)

            Button(action: addPlayer) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}
