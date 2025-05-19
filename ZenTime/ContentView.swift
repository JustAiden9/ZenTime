//
//  ContentView.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/10/25.
//

import SwiftUI
import AVFoundation // This lets us play sounds (like an alarm)

struct ContentView: View {
    @AppStorage("badgesEarned") private var badgesEarned = 0
    @State private var timeRemaining = 60
    @State private var isTimerRunning = false
    @State private var isPaused = false
    @State private var timer: Timer?
    @State private var selectedHours = 0 // Hours chosen by user.
    @State private var selectedMinutes = 1 // Minutes chosen by user.
    @State private var selectedSeconds = 0 // Seconds chosen by user.
    @State private var badgesEarned = 0 // Keeps track of how many "badges" (rewards) the user has earned.
    @State private var selectedTab = 0 // Tracks which tab the user is on.
    @State private var audioPlayer: AVAudioPlayer? // Used to play sound when timer ends

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
                // App title
                Text("ZenTime")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                // Show the countdown timer as a digital clock
                Text(timeString(time: timeRemaining))
                    .font(.system(size: 70, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 200)
                    .padding(.vertical, 20)
                // Show the time picker only if the timer hasn't started or isn't paused
                if !isTimerRunning && !isPaused {
                    HStack(spacing: 20) {
                        // Picker for selecting hours
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

                        // Picker for selecting minutes
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

                        // Picker for selecting seconds
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

                // Buttons to start/pause/resume and reset the timer
                HStack(spacing: 30) {
                    Button(action: {
                        if isTimerRunning {
                            pauseTimer()
                        } else {
                            if isPaused {
                                resumeTimer()
                            } else {
                                startTimer()
                            }
                        }
                    }) {
                        Text(isTimerRunning ? "Pause" : (isPaused ? "Resume" : "Start"))
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

    // This function updates how many seconds are left based on the pickers
    func updateTimeRemaining() {
        timeRemaining = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
    }
    // This plays a sound when the timer ends
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {}
    }
    
    // This starts the timer and begins counting down every second
    func startTimer() {
        updateTimeRemaining()
        isTimerRunning = true
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                pauseTimer()
                playSound()
                badgesEarned += 1 // Reward the user with a badge
                selectedTab = 1 // Switch to the rewards tab
            }
        }
    }

    // This resumes the timer from a paused state
    func resumeTimer() {
        isTimerRunning = true
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                pauseTimer()
                playSound()
                badgesEarned += 1
                selectedTab = 1
            }
        }
    }
    
    // This pauses the timer
    func pauseTimer() {
        isTimerRunning = false
        isPaused = true
        timer?.invalidate() // Stops the timer from firing
        timer = nil // Setting it to `nil` means "this Timer no longer exists." / gets removed and does not mix up future timers
    }
    
    // This resets the timer to the values chosen in the pickers
    func resetTimer() {
        pauseTimer()
        selectedHours = 0
        selectedMinutes = 1
        selectedSeconds = 0
        updateTimeRemaining()
        isPaused = false
    }
    
    // This formats the remaining time as a string like "00:01:30"
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
