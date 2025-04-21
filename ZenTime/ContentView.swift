//
//  ContentView.swift
//  ZenTime
//
//  Created by Aiden Baker on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 60 // Timer value in seconds
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    
    @State private var selectedMinutes = 1
    @State private var selectedSeconds = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Timer")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(timeString(time: timeRemaining))
                .font(.system(size: 70, weight: .medium))
                .frame(minWidth: 200)
                .padding(.vertical, 20)
            
            if !isTimerRunning {
                HStack(spacing: 20) {
                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(0..<60) { minute in
                            Text("\(minute) min").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100)
                    .onChange(of: selectedMinutes) {
                        updateTimeRemaining()
                    }

                    Picker("Seconds", selection: $selectedSeconds) {
                        ForEach(0..<60) { second in
                            Text("\(second) sec").tag(second)
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
                        startTimer()
                    }
                }) {
                    Text(isTimerRunning ? "Pause" : "Start")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 100)
                        .padding()
                        .background(isTimerRunning ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 100)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    func updateTimeRemaining() {
        timeRemaining = selectedMinutes * 60 + selectedSeconds
    }
    
    func startTimer() {
        updateTimeRemaining()
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                pauseTimer()
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
        selectedMinutes = 1
        selectedSeconds = 0
        updateTimeRemaining()
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
