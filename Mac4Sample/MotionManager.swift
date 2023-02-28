//
//  MotionManager.swift
//  Mac4Sample
//
//  Created by 塩見誠 on 2023/02/28.
//

import Foundation
import CoreMotion
import CoreTransferable
import SSZipArchive

class ShereClass:NSObject{
    static var singleton=ShereClass()
    
    
    class MotionSensor:NSObject, ObservableObject{
        
        var shereClass = ShereClass.singleton
        
        let motionManager = CMMotionManager()
        
    }
}
