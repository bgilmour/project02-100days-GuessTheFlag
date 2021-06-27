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
                flagTapped(number)
            }) {
                FlagImage(country: countries[number])
            }
        }
    }

    var gameFooter: some View {
        VStack {
            Text("Your score: \(currentScore)")
                .font(.title3)
                .padding(5)
            Text("Correct: \(correctCount) Wrong: \(wrongCount)")
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }

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

struct FlagImage: View {
    var country: String

    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(Color.white, lineWidth: 1))
            .shadow(color: .black, radius: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
