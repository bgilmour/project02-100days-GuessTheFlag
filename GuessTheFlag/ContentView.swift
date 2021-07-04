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
    @State private var incorrectGuess = false
    @State private var correctGuess = false
    @State private var animationRunning = false
    @State private var spinAmount = 0.0

    var body: some View {
        ZStack {
            gameBackground

            VStack(spacing: 30) {
                gameHeader

                Spacer()

                gameBody

                Spacer()

                gameFooter
            }
        }
        .alert(isPresented: $incorrectGuess) {
            showAlert
        }
    }

    var gameBackground: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }

    var gameHeader: some View {
        VStack {
            Text("Tap the flag of")
            Text(countries[correctAnswer])
                .font(.largeTitle)
                .fontWeight(.black)
        }
        .foregroundColor(.white)
    }

    var gameBody: some View {
        ForEach(0 ..< 3) { number in
            Button(action: {
                if !animationRunning {
                    animationRunning = true
                    withAnimation(Animation.easeOut(duration: 1.5)) {
                        flagTapped(number)
                        spinAmount = 360
                        if correctGuess {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                setupForNewRound()
                            }
                        }
                    }
                }
            }) {
                FlagImage(country: countries[number])
                    .opacity(correctGuess && number != correctAnswer ? 0.25 : 1.0)
                    .rotation3DEffect(.degrees(correctGuess && number == correctAnswer ? spinAmount : 0.0), axis: (x: 0, y: 1, z: 0))
            }
            .disabled(animationRunning)
        }
    }

    var gameFooter: some View {
        VStack {
            Text("Your score: \(currentScore)")
                .font(.title)
                .padding(5)
            Text("😀: \(correctCount)   😞: \(wrongCount)")
                .font(.title2)
        }
        .foregroundColor(.white)
    }

    var showAlert: Alert {
        Alert(title: Text(scoreTitle),
              message: Text(scoreSubtitle),
              dismissButton: .default(Text("Continue")) {
            setupForNewRound()
        })
    }

    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreSubtitle = "Well done"
            correctCount += 1
            correctGuess = true
        } else {
            scoreTitle = "Wrong"
            scoreSubtitle = "That flag belongs to \(countries[number])"
            wrongCount += 1
            correctGuess = false
        }
        incorrectGuess = !correctGuess
        currentScore = correctCount - wrongCount
        showingScore = true
    }

    private func setupForNewRound() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        correctGuess = false
        incorrectGuess = false
        spinAmount = 0
        animationRunning = false
    }
}

struct FlagImage: View {
    var country: String

    var body: some View {
        ZStack {
        Image(country)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(Color.white, lineWidth: 1))
            .shadow(color: .black, radius: 3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
