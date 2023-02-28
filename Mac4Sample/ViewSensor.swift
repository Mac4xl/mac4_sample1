//
//  BraBallGameViewModel.swift
//  Mac4Sample
//
//  Created by 塩見誠 on 2023/02/16.

import CoreMotion

class MotionSensor:NSObject, ObservableObject{

    
    init() {
        startMotion()
    }
    
    @Published var currentBallPosition: CGPoint = .init()
    let ballLength: CGFloat = 120
    private let motionManager = CMMotionManager()
    //姿勢変換
    var Standing = true
    
    // MARK: - Public Function
    
    
    private func startMotion() {
        
        guard let queue = OperationQueue.current,
              motionManager.isDeviceMotionAvailable
        else { return }
        
        motionManager.deviceMotionUpdateInterval = 1 / 100
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                               to: queue) { [weak self] motion, error in
            
            //わかんね
            guard  let self = self,
                  let motion = motion,
                  error == nil
            else { return }
            
            //クウォーターニオン角度
            let attitude = motion.attitude
            
            let qw = attitude.quaternion.w
            let qx = attitude.quaternion.x
            let qy = attitude.quaternion.y
            let qz = attitude.quaternion.z
            
            let qpitch = atan2((2 * (qw * qx + qy * qz)), 1 - 2 * (qx * qx + qy * qy))*(-1)
            let qroll = 2*atan2 ( sqrt ( 1 + 2 * ( qw * qy - qx * qz )),sqrt ( 1 - 2 * ( qw * qy - qx * qz )) ) - (Double.pi/2)
            
            
            let xAngle = qroll*180 / Double.pi
            
            var yAngle = qpitch*180 / Double.pi
            
            if self.Standing{
                yAngle = qpitch*180 / Double.pi+90
            }else{
                yAngle = qpitch*180 / Double.pi
                
            }
            
            /// 係数を使って感度を調整する
            let coefficient: CGFloat = 5
            
            let regulatedX = CGFloat(xAngle) * coefficient
            let regulatedY = CGFloat(yAngle) * coefficient
            
            let currentPositionX = regulatedX+150
            let currentPositionY = regulatedY+200
            
            
            Task { @MainActor in
                self.currentBallPosition = CGPoint(x: currentPositionX,
                                                   y: currentPositionY)
            }
            
            print("x: ", currentPositionX)
            print("y: ", currentPositionY)
            
        }
    }
}


 
