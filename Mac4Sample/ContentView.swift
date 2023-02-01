//
//  ContentView.swift
//  Mac4Sample
//
//  Created by yuksblog on 2023/01/01.
//

import SwiftUI

struct MyData {
    var timestamp: Date
    var name: String
    var number: Int
}



struct ContentView: View {
    @ObservedObject var sensor = MotionSensor()
    
    @State var Standing = true
    
    var body: some View {
        VStack {
                Spacer()
                Text(sensor.xStr)
                Text(sensor.xStr2)
                Text(sensor.yStr)
                Text(sensor.zStr)
                //時間表示
                
                Group{
                Button(action:
                        {self.sensor.isStarted ? self.sensor.stop() : self.sensor.start()})
                {self.sensor.isStarted ? Text("STOP") : Text("START")}
                
                Spacer()
                
                Button(action: {
                    sensor.share()
                }) {
                    Image(systemName:"square.and.arrow.up")
                }
                Spacer()
                
                //新しいボタン（シンクロ）
                Button(action: {
                    sensor.syncr()
                }) {
                    Image(systemName:"personalhotspot.circle.fill")
                }
                
                Spacer()
                
                //新しいボタン（縦90度）
                    Toggle(isOn: $sensor.Standing){
                    Text("Stand")
                }
                Spacer()
            }
            
        }
        
        
    }
    
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

