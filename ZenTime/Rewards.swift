//
//  Rewards.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/29/25.
//

import SwiftUI

struct Rewards: View {
    // This variable keeps track of how many badges the user has earned.
    @Binding var badges: Int

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Set the background color to black and make it cover the whole screen

            VStack(spacing: 20) {
                Text("ZenTime Rewards")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.purple)

                // If the user has at least 1 badge, show the badge icons
                if badges > 0 {
                    // A scrollable row of badge icons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // Create one 🏅 emoji for each badge earned
                            ForEach(0..<badges, id: \.self) { _ in
                                Text("🏅")
                                    .font(.system(size: 40))
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // If the user has no badges, show this message
                    Text("No badges yet — complete a study session to earn one!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                // Show how many total badges the user has earned
                Text("You’ve earned \(badges) badge\(badges == 1 ? "" : "s")!")
                    .font(.title2)
                    .foregroundColor(.white)

                // Show a tip about how to earn badges
                Text("Earn badges by completing study sessions!")
                    .foregroundColor(.gray)

                VStack(spacing: 10) {
                    RewardItem(title: "5-Min Break", cost: 2, badges: $badges)
                    RewardItem(title: "Meme", cost: 3, badges: $badges)
                    RewardItem(title: "Snack Time Break", cost: 5, badges: $badges)
                }
            }
            .padding()
        }
    }
}

struct RewardItem: View {
    let title: String
    let cost: Int
    @Binding var badges: Int
    @State private var showMessage = false

    var body: some View {
        VStack {
            Button(action: {
                if badges >= cost {
                    badges -= cost
                    showMessage = true
                }
            }) {
                HStack {
                    Text(title)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(cost) 🏅")
                        .foregroundColor(.yellow)
                }
                .padding()
                .background(Color.purple.opacity(0.7))
                .cornerRadius(10)
            }

            if showMessage {
                Text("✅ Redeemed!")
                    .font(.caption)
                    .foregroundColor(.green)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showMessage = false
                            }
                        }
                    }
            }
        }
    }
}
