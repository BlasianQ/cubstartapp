//
//  ContentView.swift
//  Hangman App
//
//  Created by Quincy Poynter on 4/19/23.
//

import SwiftUI

/* The main view that is displayed to users. */
struct ContentView: View {
    // The dog's breed
    @State var dogBreed: String = ""
    // URL of image from API call
    @State var imageURL: String = ""
    // User's input
    @State var user_guess: String = ""
    // User's best streak
    @State var best_streak: Int = 0
    // User's streak for the current run
    @State var streak: Int = 0
    // True when user has made an incorrect guess, false otherwise.
    @State var incorrectGuess: Bool = false
    @State var blanks: String = ""
    
    // Colors!
    let lightBlue = Color(red: 135/255, green: 206/255, blue: 250/255)
    let lavender = Color(red: 220/255, green: 208/255, blue: 255/255)
    
    var body: some View {
        ZStack {
            // TODO: Part 1a - Linear Gradient Background.
            LinearGradient(gradient: Gradient(colors: [lightBlue, lavender, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            // VStack in foreground
            VStack {
                // TODO: Part 1b -
                Text(generateHint(input: dogBreed))
                    .padding()
                // TODO: PART 3a - Replace the hardcoded string URL with the imageURL.
                // Ansyncronously loads an image from the URL.
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 256, height: 256)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 256, height: 256)
                
                // TODO: PART 1b - Display the generated hint.
//                Text(generateHint(input: dogBreed))
                Button("Guess a letter") {
                    if (dogBreed.lowercased().contains(user_guess.lowercased())) {
                        streak += 1
                        if (streak > best_streak) {
                            best_streak = streak
                        }
                        var result = ""
                        for char in dogBreed.lowercased(){
                            if char == Character(user_guess.lowercased()) {
                                result.append(user_guess.lowercased())
                            } else {
                                result.append("_ ")
                            }
                        }
                        Task {
                            // Hint: You should be fetching a new doggy here!
                            let newPup = await fetchDoggy()
                            imageURL = newPup.message
                            dogBreed = getDogName(imageURL: imageURL)
                            user_guess = ""
                        }
                    } else {
                        incorrectGuess.toggle()
                    }
                    user_guess = ""
                }
                .padding()
                .foregroundColor(.blue)
                // TODO: Part 3b - Guess submission logic in Button. Hint: Should be exact same as TextField.onSubmit{ }.
                // TODO: Part 3c - Incorrect guess alert (attached to submit guess button).
                .alert("Wrong dog", isPresented: $incorrectGuess) {
                    Button("Play again", role: .cancel) {
                        streak = 0
                        Task {
                            // Hint: You should be fetching a new doggy here!
                            let newPup = await fetchDoggy()
                            imageURL = newPup.message
                            dogBreed = getDogName(imageURL: imageURL)
                            user_guess = ""
                        }
                    }
                } message: {
                    Text("Incorrect guess! \n Correct answer: \(dogBreed)")
                }

                
                TextField("", text: $user_guess)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 50)
                    .onSubmit {
                        // TODO: Part 3b - Guess submission logic.
                        if (dogBreed.lowercased().contains(user_guess.lowercased())) {
                            Task {
                                // Hint: You should be fetching a new doggy here!
                                let newPup = await fetchDoggy()
                                imageURL = newPup.message
                                dogBreed = getDogName(imageURL: imageURL)
                                user_guess = ""
                            }
                        } else {
                            incorrectGuess.toggle()
                        }
                        user_guess = ""
                                            }
                
                // TODO: Part 1b - Submit Guess Button.
                
                
                // Answer for debugging/testing purposes.
                Text("\(dogBreed)")
            }
            .task {
                // TODO: Part 3a - Fetch a doggy upon loading the app.
                let pup = await fetchDoggy()
                imageURL = pup.message
                dogBreed = getDogName(imageURL: imageURL)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


