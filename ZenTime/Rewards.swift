//
//  Rewards.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/29/25.
//

import SwiftUI

struct Rewards: View {
    @Binding var badges: Int

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("ZenTime Rewards")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.purple)

                if badges > 0 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<badges, id: \.self) { _ in
                                Text("🏅")
                                    .font(.system(size: 40))
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No badges yet — complete a session to earn one!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                Text("You’ve earned \(badges) badge\(badges == 1 ? "" : "s")!")
                    .font(.title2)
                    .foregroundColor(.white)

                Text("Spend badges on fun perks!")
                    .foregroundColor(.gray)

                VStack(spacing: 10) {
                    RewardItem(title: "5-Min Break", cost: 2, badges: $badges)
                    RewardItem(title: "Choose Music", cost: 3, badges: $badges)
                    RewardItem(title: "Snack Time Pass", cost: 5, badges: $badges)
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
