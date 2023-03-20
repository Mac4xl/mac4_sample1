//
//  ContentView.swift
//  Mac4Sample
//
//  Created by yuksblog on 2023/01/01.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var sensor = ContentViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            SoccerBall(length: sensor.ballLength)
                .position(sensor.currentBallPosition)
        }
        
        HStack {
            Text("(前後傾)°:")
            Text(sensor.xStr2)
            Text("(挙上下制)°:")
            Text(sensor.yStr2)
        }
        
        Button(action: {
            self.sensor.isStarted ? self.sensor.stop() : self.sensor.start()
        }) {
            self.sensor.isStarted ? Text("STOP") : Text("START")
        }
        
        Group {
            Text("(前後傾)°: \(Int(sensor.thresholdAngle))")
            Slider(value: $sensor.thresholdAngle, in: -180...30, step: 1)
            Toggle("Sound", isOn: $sensor.soundEnabled)
            Toggle("Stand", isOn: $sensor.Standing)
            
            Button(action: {
                sensor.syncr()
            }) {
                Label("sync", systemImage: "personalhotspot.circle.fill")
            }
            
            Button(action: {
                sensor.share()
            }) {
                Label("share", systemImage: "square.and.arrow.up")
            }
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase == .background {
                    self.sensor.stop()
                }
            }
            Picker("", selection: $sensor.updateInterval) {
                Text("Hz:10").tag(0.1)
                Text("Hz:30").tag(0.0333)
                Text("Hz:60").tag(0.01667)
                Text("Hz:80").tag(0.0125)
                Text("Hz:100").tag(0.01)
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .background {
                self.sensor.stop()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    

