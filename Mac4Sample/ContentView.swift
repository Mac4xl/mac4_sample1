import SwiftUI

struct ContentView: View {
    
    @ObservedObject var sensor = ContentViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    sensor.syncr()
                }) {
                    Label("sync", systemImage: "personalhotspot.circle.fill")
                }
                .padding(13)
                .foregroundColor(.white)
                .background(.brown)
                .cornerRadius(24)
//                .overlay(RoundedRectangle(cornerRadius: 30)
//                    .stroke(Color.blue, lineWidth: 3))
//                .clipShape(RoundedRectangle(cornerRadius: 30))
                Button(action: {
                    sensor.share()
                }) {
                    Label("share", systemImage: "square.and.arrow.up")
                    
                }
                .padding(12)
                .foregroundColor(.white)
                .background(.orange)
                .cornerRadius(24)
                
                Picker("", selection: $sensor.updateInterval) {
                    Text("Hz:10").tag(0.1)
                    Text("Hz:30").tag(0.0333)
                    Text("Hz:60").tag(0.01667)
                    Text("Hz:80").tag(0.0125)
                    Text("Hz:100").tag(0.01)
                }
                .padding(5)
                .foregroundColor(.white)
                .background(.yellow)
                .cornerRadius(20)
                
            }
            
            
            
            ZStack {
                
                SoccerBall(length: sensor.ballLength)
                    .position(sensor.currentBallPosition)
                VStack{
                    Group{
                        HStack{
                            Text("前後傾:")
                            Text("\(sensor.xStr2)°")
                            Text("挙上下制:")
                            Text("\(sensor.yStr2)°")
                            
                        }
                        Button(action: {
                            self.sensor.isStarted ? self.sensor.stop() : self.sensor.start()
                        }) {
                            self.sensor.isStarted ? Text("STOP") : Text("START")
                        }
                        .padding(20)
                        .foregroundColor(.white)
                        .background(.gray)
                        .cornerRadius(24)
                        Text(" \(Int(sensor.thresholdAngle))°")
                        Slider(value: $sensor.thresholdAngle, in: -180...30, step:1,minimumValueLabel: Text("後傾"), maximumValueLabel: Text("前傾"), label: {})
                        Toggle("Sound", isOn: $sensor.soundEnabled)
                        Toggle("Stand", isOn: $sensor.Standing)
                        
                        //
                        //                    .onChange(of: scenePhase) { newScenePhase in
                        //                        if newScenePhase == .background {
                        //                            self.sensor.stop()
                        //                        }
                        //                    }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase == .background {
                    self.sensor.stop()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


