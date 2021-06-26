//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bruce Gilmour on 2021-06-24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ... 2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreSubtitle = ""
    @State private var currentScore = 0
    @State private var correctCount = 0
    @State private var wrongCount = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(.white)

                Spacer()

                ForEach(0 ..< 3) { number in
                    Button(action: {
                        flagTapped(number)
                    }) {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(Color.white, lineWidth: 1))
                            .shadow(color: .black, radius: 3)
                    }
                }

                Spacer()

                VStack {
                    Text("Your score: \(currentScore)")
                        .font(.title3)
                        .padding(5)
                    Text("Correct: \(correctCount) Wrong: \(wrongCount)")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text(scoreSubtitle),
                  dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }

    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreSubtitle = "Well done"
            correctCount += 1
        } else {
            scoreTitle = "Wrong"
            scoreSubtitle = "That flag belongs to \(countries[number])"
            wrongCount += 1
        }
        currentScore = correctCount - wrongCount
        showingScore = true
    }

    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
