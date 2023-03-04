//
//  SubView.swift
//  Mac4Sample
//
//  Created by 塩見誠 on 2023/03/03.
//

import SwiftUI

struct SubView: View {
    @StateObject private var viewModel = SubViewModel()
    
    var body: some View {
        ZStack {
            SoccerBall(length: viewModel.ballLength)
                .position(viewModel.currentBallPosition)
        }
        
        
        Spacer()
        
        //新しいボタン（縦90度）
        Toggle(isOn: $viewModel.Standing){
            Text("Stand")
            
        }
    }
}
