//
//  Rewards.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/29/25.
//

// Simple Implemntation for father use later, we will link it into contentview later

import SwiftUI

struct Rewards: View {
    @State private var points = 0
    @State private var message = "Earn points by tapping the button!"

    var body: some View {
        VStack(spacing: 20) {
            Text("🎁 Rewards")
                .font(.largeTitle)
                .bold()
            Text("Points: \(points)")
                .font(.title2)
            Text(message)
                .foregroundColor(.gray)
            Button(action: {
                points += 10
                message = "You earned 10 points!"
            }) {
                Text("Claim Daily Reward")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    Rewards()
}

