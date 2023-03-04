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
    
    @ObservedObject var sensor = ContentViewModel()
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                HStack {
                    Text("X:")
                        .font(.system(size: 60.0))
                    Text(sensor.xStr2)
                        .font(.system(size: 60.0))
                }
                HStack {
                    Text("Y:")
                        .font(.system(size: 60.0))
                    Text(sensor.yStr2)
                        .font(.system(size: 60.0))
                }
                Spacer()
                //時間表示
                Group{
                    
                    Button(action:
                            {self.sensor.isStarted ? self.sensor.stop() : self.sensor.start()})
                    {self.sensor.isStarted ? Text("STOP") : Text("START")}
                    
                    Spacer()
                    
                    Button(action: {
                        sensor.share()
                    }) {
                        Label("shere", systemImage: "square.and.arrow.up")
                    }
                    Spacer()
                    
                    //新しいボタン（シンクロ）
                    Button(action: {
                        sensor.syncr()
                    }) {
                        Label("sync", systemImage: "personalhotspot.circle.fill")
                    }
                    
                    Spacer()
                    
                    //新しいボタン（縦90度）
                    Toggle(isOn: $sensor.Standing){
                        Text("Stand")
                        
                    }
                    Spacer()
                }
                //サブビュー
                NavigationLink (destination: SubView()){
                    Label("Visual", systemImage: "arrowshape.right.fill")
                    Image(systemName: "eye.circle")
                }
                .navigationTitle("Angle")
                
            }
        }
        .navigationViewStyle(.stack)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


