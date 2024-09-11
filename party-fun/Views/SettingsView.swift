//
//  SettingsView.swift
//  party-fun
//
//  Created by Furkan on 5.09.2024.
//
import SwiftUI
import SwiftUI

struct SettingsView: View {
    @ObservedObject var languageManager = LanguageManager.shared
    @Binding var isPresented: Bool
    @State private var isLanguageDropdownOpen = false
    @AppStorage("questionCount") private var questionCount: Int = 10
    
    let languages: [(code: String, name: String, flag: String)] = [
        ("en", "English", "🇬🇧"),
        ("nl", "Dutch", "🇳🇱"),
        ("fr", "French", "🇫🇷"),
        ("de", "German", "🇩🇪"),
        ("it", "Italian", "🇮🇹"),
        ("tr", "Türkçe", "🇹🇷"),
        ("sr", "Cрпски", "🇷🇸"),
        ("pt", "Português","🇵🇹"),
        ("fi", "Sumoai", "🇫🇮"),
        ("BG", "Bulgarian", "🇧🇬"),
    ]
    
    var body: some View {
        ZStack {
            Color.purple.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                    }
                }
                
                Text("Settings")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Select Language")
                    .font(.title3)
                    .foregroundColor(.white)
                
                LanguageDropdown(
                    selectedLanguage: $languageManager.currentLanguage,
                    languages: languages,
                    isOpen: $isLanguageDropdownOpen
                )
                
                Text("Number of Questions")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Text("\(questionCount)")
                                        .foregroundColor(.black)
                                        .frame(width: 50)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    
                                    Slider(value: Binding(
                                        get: { Double(questionCount) },
                                        set: { questionCount = Int($0) }
                                    ), in: 5...100, step: 1)
                                    .accentColor(.white)
                                }
                
                Button(action: {
                    // Implement contact functionality
                }) {
                    Text("Contact Us")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Implement rate app functionality
                }) {
                    Text("Rate App")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct LanguageDropdown: View {
    @Binding var selectedLanguage: String
    let languages: [(code: String, name: String, flag: String)]
    @Binding var isOpen: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isOpen.toggle()
                }
            }) {
                HStack {
                    Text(getCurrentLanguageFlag() + " " + getCurrentLanguageName())
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(languages, id: \.code) { language in
                        Button(action: {
                            selectedLanguage = language.code
                            withAnimation {
                                isOpen = false
                            }
                        }) {
                            HStack {
                                Text(language.flag + " " + language.name)
                                    .foregroundColor(.black)
                                Spacer()
                                if language.code == selectedLanguage {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .offset(y: -5)
            }
        }
    }
    
    func getCurrentLanguageFlag() -> String {
        languages.first(where: { $0.code == selectedLanguage })?.flag ?? "🇬🇧"
    }
    
    func getCurrentLanguageName() -> String {
        languages.first(where: { $0.code == selectedLanguage })?.name ?? "English"
    }
}
