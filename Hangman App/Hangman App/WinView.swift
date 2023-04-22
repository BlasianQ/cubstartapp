//
//  WinView.swift
//  Hangman App
//
//  Created by Quincy Poynter on 4/21/23.
//

import Foundation
import SwiftUI

/* View that is presented when the player reaches the maze exit. */
struct WinView: View {
    @Binding var dogBreed: String
    @Binding var user_guess: String
    @Binding var allGuesses: [String]
    @Binding var incorrectGuesses: [String]
    @Binding var imageIndex: Int
    
    var body: some View {
        Text("YOU WON!")
        
        Button("Play again") {
            dogBreed = ""
            user_guess = ""
            allGuesses = []
            incorrectGuesses = []
            imageIndex = 0
        }
        .padding()
    }
}

struct WinView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
