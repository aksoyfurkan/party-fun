//
//  GameView.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//
import SwiftUI

struct GamePlayView: View {
    @StateObject private var viewModel: GamePlayViewModel
    @State private var showingQuestion = false
    @State private var currentHighlightIndex = -1
    @State private var selectedPlayerIndex: Int?
    @State private var showSelectedPlayer = false
    @State private var showWinner = false
    @Environment(\.presentationMode) var presentationMode
    
    init(players: [Player], selectedGameTypes: [GameType]) {
        _viewModel = StateObject(wrappedValue: GamePlayViewModel(players: players, selectedGameTypes: selectedGameTypes))
    }
    
    var body: some View {
        ZStack {
            Color.purple.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Remaining Questions: \(viewModel.remainingQuestions)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                
                if showingQuestion {
                    QuestionView(question: viewModel.currentQuestion, onAnswer: handleAnswer)
                } else if showWinner {
                    WinnerView(winner: viewModel.winner)
                } else {
                    playerBoxes
                    
                    Button("Play") {
                        startSelectionAnimation()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(currentHighlightIndex != -1)
                }
            }
            
            if showSelectedPlayer, let index = selectedPlayerIndex {
                PlayerBox(player: viewModel.players[index], isSelected: true)
                    .frame(width: 200, height: 150)
                    .scaleEffect(showSelectedPlayer ? 1.2 : 1)
                    .animation(.easeInOut(duration: 0.5), value: showSelectedPlayer)
            }
        }
    }
    
    var playerBoxes: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
            ForEach(viewModel.players.indices, id: \.self) { index in
                PlayerBox(player: viewModel.players[index], isSelected: index == currentHighlightIndex)
                    .frame(width: 150, height: 100)
                    .modifier(ShakeEffect(shakes: index == currentHighlightIndex ? 2 : 0))
            }
        }
        .padding()
    }
    
    func startSelectionAnimation() {
        currentHighlightIndex = 0
        animateNextPlayer()
    }
    
    func animateNextPlayer() {
        if currentHighlightIndex < viewModel.players.count {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Highlight current player
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                currentHighlightIndex += 1
                animateNextPlayer()
            }
        } else {
            // All players highlighted, select random player
            selectedPlayerIndex = Int.random(in: 0..<viewModel.players.count)
            withAnimation(.easeInOut(duration: 0.5)) {
                showSelectedPlayer = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showSelectedPlayer = false
                viewModel.selectRandomPlayer()
                viewModel.fetchRandomQuestion()
                showingQuestion = true
            }
        }
    }
    
    func handleAnswer(correct: Bool) {
        viewModel.handleAnswer(correct: correct)
        if viewModel.isGameOver {
            withAnimation(.easeInOut(duration: 1.0)) {
                showWinner = true
            }
        } else {
            showingQuestion = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startSelectionAnimation()
            }
        }
    }
}

struct PlayerBox: View {
    let player: Player
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(player.name)
            Text("Score: \(player.score)")
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color.red : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

struct WinnerView: View {
    let winner: Player
    
    var body: some View {
        VStack {
            Text("Winner!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
            
            Image(systemName: "trophy.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)
                .shadow(color: .black, radius: 10, x: 0, y: 0)
            
            Text(winner.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Score: \(winner.score)")
                .font(.title2)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.purple)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .transition(.scale.combined(with: .opacity))
    }
}


struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -5 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}
