//
//  SubView.swift
//  Mac4Sample
//
//  Created by 塩見誠 on 2023/03/03.
//

import SwiftUI
import AVFoundation

struct SubView: View {
    @StateObject private var viewModel = MotionSensor()
    
    
    var body: some View {
        ZStack {
            SoccerBall(length: viewModel.ballLength)
                .position(viewModel.currentBallPosition)
        }
        
//                Button(action:
//                        {self.sensor.isStarted ? self.sensor.stop() : self.sensor.start()})
//                {self.sensor.isStarted ? Text("STOP") : Text("START")}
        
        VStack {
            Slider(value: $viewModel.thresholdAngle, in: -180...30, step: 1)
                .padding()
            Text("Threshold: \(Int(viewModel.thresholdAngle))")
                .padding()
            Text(viewModel.xvStr)
                .padding()
            Toggle("Sound", isOn: $viewModel.soundEnabled)
                .padding()
            //90°
            Toggle("Stand", isOn: $viewModel.Standing)
                .padding()
        }
        .onAppear {
            viewModel.soundEnabled = UserDefaults.standard.bool(forKey: "SoundEnabled")
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: viewModel.toggleSoundEnabled) {
                    Image(systemName: viewModel.soundEnabled ? "speaker.fill" : "speaker.slash.fill")
                }
            }
        }
        Spacer()
    }
}

