//
//  QuestionView.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//
import SwiftUI

struct QuestionView: View {
    let question: Question?
    let onAnswer: (Bool) -> Void
    
    var body: some View {
        VStack {
            if let question = question {
                Text(question.text[LanguageManager.shared.currentLanguage] ?? "")
                    .font(.title)
                    .padding()
                
                HStack {
                    Button("Done") {
                        onAnswer(true)
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Not") {
                        onAnswer(false)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                Text("Loading question...")
            }
        }
    }
}
