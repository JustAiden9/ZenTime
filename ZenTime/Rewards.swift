//
//  Rewards.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/29/25.
//

// Simple Implemntation for father use later, we will link it into contentview later

import SwiftUI

struct Rewards: View {
    @Binding var badges: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("🏅 Rewards")
                .font(.largeTitle)
                .bold()

            // Row of badge emojis
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

            Text("Earn badges by completing study sessions!")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

