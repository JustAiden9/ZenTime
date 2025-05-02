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
            Text("Badges Earned: \(badges)")
                .font(.title2)
            Text("Earn badges by completing study sessions!")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

