//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bruce Gilmour on 2021-06-24.
//

import SwiftUI

struct ContentView: View {
    // game control
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctChoice = Int.random(in: 0 ... 2)
    // animation control
    @State private var usersChoice = -1
    @State private var correctGuess = false
    @State private var incorrectGuess = false
    @State private var animationRunning = false
    @State private var scaleAmount: CGFloat = 1.0
    @State private var opacityAmount = 1.0
    @State private var spinDegrees = 0.0
    @State private var spinAxis: (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
    // score tracking
    @State private var currentScore = 0
    @State private var correctCount = 0
    @State private var wrongCount = 0

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
    }

    var gameBackground: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }

    var gameHeader: some View {
        VStack {
            Text("Tap the flag of")
            Text(countries[correctChoice])
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
                    flagTapped(number)
                    withAnimation(.linear(duration: 1)) {
                        scaleAmount = computedScaleEffect
                        opacityAmount = computedOpacity
                        spinDegrees = computedSpinDegrees
                        spinAxis = computedSpinAxis
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        setupForNewRound()
                    }
                }
            }) {
                FlagImage(country: countries[number])
                    .scaleEffect(animateSelection(for: number) ? scaleAmount : 1.0)
                    .opacity(animateUnselected(for: number) ? opacityAmount : 1.0)
                    .rotation3DEffect(
                        .degrees(animateSelection(for: number) ? spinDegrees : 0),
                        axis: animateSelection(for: number) ? spinAxis : (0, 0, 0)
                    )
            }
            .disabled(animationRunning)
        }
    }

    var gameFooter: some View {
        VStack {
            if correctGuess {
                Text("Well done!")
                    .padding(5)
                Text("You got it right")
            } else if incorrectGuess {
                Text("Oops!")
                    .padding(5)
                Text("You chose \(countries[usersChoice])")

            } else {
                Text("Your score: \(currentScore)")
                    .padding(5)
                Text("😀: \(correctCount)   😞: \(wrongCount)")
            }
        }
        .font(.title)
        .foregroundColor(.white)
    }

    var computedOpacity: Double {
        if correctGuess {
            return 0.25
        }
        return 1.0
    }

    var computedScaleEffect: CGFloat {
        if correctGuess {
            return 1.25
        } else if incorrectGuess {
            return 0.0
        } else {
            return 1.0
        }
    }

    var computedSpinDegrees: Double {
        if correctGuess {
            return 360
        } else if incorrectGuess {
            return -360
        }
        return 0
    }

    var computedSpinAxis: (CGFloat, CGFloat, CGFloat) {
        if correctGuess {
            return (0, 1, 0)
        } else if incorrectGuess {
            return (0, 0, 1)
        }
        return (0, 0, 0)
    }

    private func animateSelection(for choice: Int) -> Bool {
        return (correctGuess && choice == correctChoice) || (incorrectGuess && choice == usersChoice)
    }

    private func animateUnselected(for choice: Int) -> Bool {
        return (correctGuess && choice != correctChoice)
    }

    private func flagTapped(_ number: Int) {
        usersChoice = number
        if number == correctChoice {
            correctCount += 1
            correctGuess = true
        } else {
            wrongCount += 1
            correctGuess = false
        }
        incorrectGuess = !correctGuess
        currentScore = correctCount - wrongCount
    }

    private func setupForNewRound() {
        countries.shuffle()
        correctChoice = Int.random(in: 0 ... 2)
        correctGuess = false
        incorrectGuess = false
        usersChoice = -1
        scaleAmount = 1.0
        opacityAmount = 1.0
        spinDegrees = 0.0
        spinAxis = (0, 0, 0)
        animationRunning = false
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
