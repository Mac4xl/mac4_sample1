import SwiftUI



struct ContentView: View {
    
    @ObservedObject var sensor = ContentViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var isShowingLandingPage = true
    @State var isPressed = false

    
    var body: some View {
        
        VStack {
            if isShowingLandingPage {
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowingLandingPage = false
                        }
                    }
                
            } else {
                        // 本来のコンテンツを表示する
                        VStack {
                            ZStack {
                                
                                SoccerBall(length: sensor.ballLength)
                                    .position(sensor.currentBallPosition)
                                
                                VStack{
                                    HStack {
                                        Button(action: {
                                            sensor.syncr()
                                            isPressed.toggle()
                                        }) {
                                            Label("sync", systemImage: "personalhotspot.circle.fill")
                                        }
                                        .padding(10)
                                        .foregroundColor(.white)
                                        .background(isPressed ? .green : .brown)
                                        .cornerRadius(24)
                                        //                .overlay(RoundedRectangle(cornerRadius: 30)
                                        //                    .stroke(Color.blue, lineWidth: 3))
                                        //                .clipShape(RoundedRectangle(cornerRadius: 30))
                                        Button(action: {
                                            sensor.share()
                                        }) {
                                            Label("share", systemImage: "square.and.arrow.up")
                                            
                                        }
                                        .padding(9)
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
                                        .padding(2)
                                        .foregroundColor(.white)
                                        .background(.yellow)
                                        .cornerRadius(20)
                                        
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                    
                                    
                                    
                                    HStack{
                                        Text("前後傾:")
                                        Text("\(sensor.xStr2)°")
                                        Text("挙上下制:")
                                        Text("\(sensor.yStr2)°")
                                    }
                                    Spacer()
                                    Text(" \(Int(sensor.thresholdAngle))°")
                                        .overlay(RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.blue, lineWidth: 3))
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                    Slider(value: $sensor.thresholdAngle, in: -150...30, step:1,minimumValueLabel: Text("後傾"), maximumValueLabel: Text("前傾"), label: {})
                                    
                                    HStack {
                                        Toggle("Sound", isOn: $sensor.soundEnabled)
                                        Toggle("Stand", isOn: $sensor.Standing)
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
                                    
                                    //
                                    //                    .onChange(of: scenePhase) { newScenePhase in
                                    //                        if newScenePhase == .background {
                                    //                            self.sensor.stop()
                                    //                        }
                                    //                    }
                                }
                                
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }
                        }
                        
                        //            バックグラウンドでStop
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
    
    
}
