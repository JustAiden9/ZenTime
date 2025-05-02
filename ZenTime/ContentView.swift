//
//  ContentView.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 60
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var selectedHours = 0
    @State private var selectedMinutes = 1
    @State private var selectedSeconds = 0
    @State private var badgesEarned = 0
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            timerView
                .tag(0)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            Rewards(badges: $badgesEarned)
                .tag(1)
                .tabItem {
                    Label("Rewards", systemImage: "star.fill")
                }
        }
    }

    var timerView: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Text("Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text(timeString(time: timeRemaining))
                    .font(.system(size: 70, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 200)
                    .padding(.vertical, 20)
                if !isTimerRunning {
                    HStack(spacing: 20) {
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour) hr").tag(hour).foregroundColor(.white)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .onChange(of: selectedHours) {
                            updateTimeRemaining()
                        }

                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) min").tag(minute).foregroundColor(.white)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .onChange(of: selectedMinutes) {
                            updateTimeRemaining()
                        }

                        Picker("Seconds", selection: $selectedSeconds) {
                            ForEach(0..<60) { second in
                                Text("\(second) sec").tag(second).foregroundColor(.white)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .onChange(of: selectedSeconds) {
                            updateTimeRemaining()
                        }
                    }
                }

                HStack(spacing: 30) {
                    Button(action: {
                        isTimerRunning ? pauseTimer() : startTimer()
                    }) {
                        Text(isTimerRunning ? "Pause" : "Start")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(width: 100)
                            .padding()
                            .background(isTimerRunning ? Color.purple.opacity(0.7) : Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: resetTimer) {
                        Text("Reset")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(width: 100)
                            .padding()
                            .background(Color.purple.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }

    func updateTimeRemaining() {
        timeRemaining = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
    }

    func startTimer() {
        updateTimeRemaining()
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                pauseTimer()
                badgesEarned += 1 // Reward badge after session
                selectedTab = 1    // Auto-switch to Rewards tab
            }
        }
    }

    func pauseTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        pauseTimer()
        selectedHours = 0
        selectedMinutes = 1
        selectedSeconds = 0
        updateTimeRemaining()
    }

    func timeString(time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


#Preview {
    ContentView()
}
