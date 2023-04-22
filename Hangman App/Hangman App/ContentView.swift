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
    
    @State var allGuesses: [String] = []
    
    @State var incorrectGuesses: [String] = []
    
    @State var imageList: [String] = [
            "Screenshot 2023-04-21 at 4.12.09 PM",
            "Screenshot 2023-04-21 at 4.02.47 PM",
            "Screenshot 2023-04-21 at 4.03.03 PM",
            "Screenshot 2023-04-21 at 4.03.51 PM",
            "Screenshot 2023-04-21 at 4.04.21 PM",
            "Screenshot 2023-04-21 at 4.04.31 PM",
            "Screenshot 2023-04-21 at 4.04.42 PM",
            "Screenshot 2023-04-21 at 4.05.14 PM"
    ]
    
    @State var imageIndex = 0
    
    // Colors!
    let lightBlue = Color(red: 145/255, green: 176/255, blue: 205/255)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [lightBlue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            // VStack in foreground
            VStack {
                Text(newText(input: dogBreed, letter: user_guess, allGuesses: allGuesses))
                    .padding()
                
                // Ansyncronously loads an image from the URL.
//                AsyncImage(url: URL(string: imageURL)) { phase in
//                    if let image = phase.image {
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 256, height: 256)
//                            .clipShape(RoundedRectangle(cornerRadius: 25))
//                    } else {
//                        ProgressView()
//                    }
//                }
//                .frame(width: 256, height: 256)
                Image(imageList[imageIndex]).resizable().scaledToFit()
                
                Button("Guess a letter") {
                    if user_guess.count == 1 {
                        if allGuesses.contains(user_guess.lowercased()){
                        }
                        else if (dogBreed.lowercased().contains(user_guess.lowercased())) {
                            allGuesses.append(user_guess.lowercased())
                            //                        Task {
                            //                            // Hint: You should be fetching a new doggy here!
                            //                            let newPup = await fetchDoggy()
                            //                            imageURL = newPup.message
                            //                            dogBreed = getDogName(imageURL: imageURL)
                            //                            user_guess = ""
                            //                        }
                        } else {
                            allGuesses.append(user_guess.lowercased())
                            imageIndex += 1
                            incorrectGuess.toggle()
                        }
                        user_guess = ""
                    }
                }
                .padding()
                .foregroundColor(.blue)
                
                // TODO: Part 3b - Guess submission logic in Button. Hint: Should be exact same as TextField.onSubmit{ }.
                // TODO: Part 3c - Incorrect guess alert (attached to submit guess button).
//                .alert("Wrong dog", isPresented: $incorrectGuess) {
//                    Button("Play again", role: .cancel) {
//                        streak = 0
//                        Task {
//                            // Hint: You should be fetching a new doggy here!
//                            let newPup = await fetchDoggy()
//                            imageURL = newPup.message
//                            dogBreed = getDogName(imageURL: imageURL)
//                            user_guess = ""
//                        }
//                    }
//                } message: {
//                    Text("Incorrect guess! \n Correct answer: \(dogBreed)")
//                }

                
                TextField("", text: $user_guess)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 50)
                    .onSubmit {
                        // TODO: Part 3b - Guess submission logic.
                        if user_guess.count == 1 {
                            if allGuesses.contains(user_guess.lowercased()){
                            }
                            else if (dogBreed.lowercased().contains(user_guess.lowercased())) {
                                allGuesses.append(user_guess.lowercased())
                                print(allGuesses)
                                //                            Task {
                                //                                // Hint: You should be fetching a new doggy here!
                                //                                let newPup = await fetchDoggy()
                                //                                imageURL = newPup.message
                                //                                dogBreed = getDogName(imageURL: imageURL)
                                //                                user_guess = ""
                                //                            }
                            } else {
                                allGuesses.append(user_guess.lowercased())
                                imageIndex += 1
                                incorrectGuesses.append(user_guess.lowercased())
                                incorrectGuess.toggle()
                            }
                            user_guess = ""
                        }
                    }
                
                // TODO: Part 1b - Submit Guess Button.
                
                if newText(input: dogBreed, letter: user_guess, allGuesses: allGuesses) == dogBreed {
                    Text("YOU WON!").font(.system(size: 28))
                        .bold().foregroundColor(.green)
                } else if imageIndex == $imageList.count - 1 {
                    Text("YOU LOST.").font(.system(size: 28))
                        .bold().foregroundColor(.red)
                }
                

                // Answer for debugging/testing purposes.
                Text("\(dogBreed)")
                    .padding()
                HStack {
                    Text("Incorrect Letters:                                  ")
                        .padding()
                }
                
                Text(wrongLetters(incorrectGuesses: incorrectGuesses))
                
                Spacer()
                
                Button("RETRY") {
                    dogBreed = "hi"
                    user_guess = ""
                    allGuesses = []
                    incorrectGuesses = []
                    imageIndex = 0
                }.font(.system(size: 28)).foregroundColor(.black).bold()
                
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

func newText(input: String, letter: String, allGuesses: [String]) -> String {
    var result = ""
    
    for char in input {
        if allGuesses.contains(String(char)) {
            result.append(String(char))
        } else {
            result.append("_ ")
        }
    }
    return result
}

func wrongLetters(incorrectGuesses: [String]) -> String {
    var result = ""
    for letter in incorrectGuesses {
        result.append(String(letter))
        result.append(" ")
    }
    return result
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


