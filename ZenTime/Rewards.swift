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
            }
            .padding()
        }
    }
}
