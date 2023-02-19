//
//  BraBallGameViewModel.swift
//  Mac4Sample
//
//  Created by 塩見誠 on 2023/02/16.

import CoreMotion

class ViewSensor: ObservableObject {
    
    init() {
        startMotion()
    }
    
    @Published var currentBallPosition: CGPoint = .init()
    @Published var outsideTouchLineField: CGRect = .init()
    
    let ballLength: CGFloat = 120
    
    private let motionManager = CMMotionManager()
    private var screenRect = CGRect()
    //姿勢変換
    var Standing = true
    
    // MARK: - Public Function
    
    func setupScreenRect(_ rect: CGRect) {
        screenRect = rect
    }
    
    //    func judge() {
    //        guard motionManager.isDeviceMotionActive
    //        else { return }
    //
    //        motionManager.stopDeviceMotionUpdates()
    //
    //        let difference = touchLineMaxX - currentBallMinX
    //        print("difference", difference)
    //
    //        result = GameResult(from: difference.roundedAfterThirdDecimalPlace())
    //        shouldPresentedResult = true
    //    }
    
    //    func retryGame() {
    //        result = .none
    //        startMotion()
    //    }
    
    // MARK: - Private Function
    
    private func startMotion() {
        
        guard let queue = OperationQueue.current,
              motionManager.isDeviceMotionAvailable
        else { return }
        
        motionManager.deviceMotionUpdateInterval = 1 / 100
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                               to: queue) { [weak self] motion, error in
            
            //わかんね
            guard let self = self,
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
            let yAngle = qpitch*180 / Double.pi
            
//            if Standing{
//                yAngle = qpitch*180 / Double.pi+90
//            }else{
//                yAngle = qpitch*180 / Double.pi
//
//            }
            
            /// 係数を使って感度を調整する
            let coefficient: CGFloat = 2
            
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
    
    //クウォーターニオン角度
    //            let attitude = motion.attitude
    //
    //            let qw = attitude.quaternion.w
    //            let qx = attitude.quaternion.x
    //            let qy = attitude.quaternion.y
    //            let qz = attitude.quaternion.z
    //
    //            let qpitch = atan2((2 * (qw * qx + qy * qz)), 1 - 2 * (qx * qx + qy * qy))*(-1)
    //            let qroll = 2*atan2 ( sqrt ( 1 + 2 * ( qw * qy - qx * qz )),sqrt ( 1 - 2 * ( qw * qy - qx * qz )) ) - (Double.pi/2)
    
    
    //            let xAngle = qpitch*180 / Double.pi
    //            let yAngle = qroll*180 / Double.pi
    
    
    
    /// 与えられたxと現在のターゲットの位置xを合算し、必要であればスクリーンの内側の値になるように補正された値を算出する
    /// - Parameter x: 現在のターゲットの位置xを算出する為に追加する値
    /// - Returns: 算出された現在のターゲットの位置x
//    private func calculatedCurrentPositionX(byAdding x: CGFloat)
//    -> CGFloat {
//        var position = currentBallPosition
//        position.x = x
//        if screenRect.minX > position.x {
//            position.x = screenRect.minX
//        } else if screenRect.maxX < position.x {
//            position.x = screenRect.maxX
//        }
//        return position.x
//    }
//
//    /// 与えられたyと現在のターゲットの位置yを合算し、必要であればスクリーンの内側の値になるように補正された値を算出する
//    /// - Parameter x: 現在のターゲットの位置yを算出する為に追加する値
//    /// - Returns: 算出された現在のターゲットの位置y
//    private func calculatedCurrentPositionY(byAdding y: CGFloat) -> CGFloat {
//        var position = currentBallPosition
//        position.y = y
//        if screenRect.minY > position.y {
//            position.y = screenRect.minY
//        } else if screenRect.maxY < position.y {
//            position.y = screenRect.maxY
//        }
//        return position.y
    }


