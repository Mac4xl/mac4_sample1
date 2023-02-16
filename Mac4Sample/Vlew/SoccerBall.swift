//
//  SoccerBall.swift
//  Mac4Sample
//
//  Created by 塩見誠 on 2023/02/15.
//

import SwiftUI

struct SoccerBall: View {
    
    let length: CGFloat
    
    var body: some View {
        Image(systemName: "circle.fill")
            .font(.system(size: length))
            .foregroundColor(.green)
            .shadow(radius: 1)
    }
}



struct SoccerBall_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SoccerBall(length: 100)
        }
    }
}
