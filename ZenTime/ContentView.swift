//
//  ContentView.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/10/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @AppStorage("badgesEarned") private var badgesEarned = 0
    @State private var timeRemaining = 60
    @State private var isTimerRunning = false
    @State private var isPaused = false
    @State private var timer: Timer?
    @State private var selectedHours = 0
    @State private var selectedMinutes = 1
    @State private var selectedSeconds = 0
    @State private var selectedTab = 0
    @State private var audioPlayer: AVAudioPlayer?

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
                Text("ZenTime")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)

                Text(timeString(time: timeRemaining))
                    .font(.system(size: 70, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 200)
                    .padding(.vertical, 20)

                if !isTimerRunning && !isPaused {
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

    func updateTimeRemaining() {
        timeRemaining = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
    }

    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {}
    }

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
                badgesEarned += 1
                selectedTab = 1
            }
        }
    }

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

    func pauseTimer() {
        isTimerRunning = false
        isPaused = true
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        pauseTimer()
        selectedHours = 0
        selectedMinutes = 1
        selectedSeconds = 0
        updateTimeRemaining()
        isPaused = false
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
