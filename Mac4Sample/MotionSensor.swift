//
//  MotionSensor.swift
//  Mac4Sample
//
//  Created by yuksblog on 2023/01/01.
//
//push

import Foundation
import CoreMotion
import CoreTransferable
import SSZipArchive

class MotionSensor: NSObject, ObservableObject {
    
    @Published var isStarted = false
    
    @Published var xStr = "0.0"
    @Published var xStr2 = "0.0"
    @Published var yStr = "0.0"
    @Published var yStr2 = "0.0"
    @Published var zStr = "0.0"
    
    // CoreMotionのCMMotionManagerを保持する
    let motionManager = CMMotionManager()
    
    // センサーデータを一時的に保存する配列
    var datas: [MotionData] = []
    
    // 共有するファイルのパス
    var sharePath = ""
    
    //時間経過ゼロ
    var elapsedTime = 0.00
    
    //同期
    var sync = 0
    
    //姿勢変換
    var Standing = true
    
    
    func start() {
        if motionManager.isDeviceMotionAvailable {
            isStarted = true
            
            // TODO 古いファイルを削除
            
            // 配列をクリア
            datas = []
            
            //時間経過ゼロ
            elapsedTime = 0.00
            
            // センサー値の取得を開始
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in
                self.updateMotionData(deviceMotion: motion!)
                    
            })
        }
    }
    
    func stop() {
        
        // 停止
        isStarted = false
        motionManager.stopDeviceMotionUpdates()
        
        // 取得データがあったら、ファイルに保存しておく
        if !datas.isEmpty {
            
            // 配列からCSV形式の文字列を作成する
            var csv = "Time,X,X2,Y,Y2,sync\n"
            datas.forEach { data in
                csv.append(contentsOf: "\(String(format:"%.2f",data.elapsedTime)),\(String(format:"%.2f",data.x)),\(String(format:"%.2f",data.x2)),\(String(format:"%.2f",data.y)),\(String(format:"%.2f",data.y2)),\(data.sync)\n")
            }
            
            // ファイル名は日付＋時刻とする
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileName = formatter.string(from: Date())
            
            // CSVファイルに保存する
            let direcoryPath = FileManager.default.temporaryDirectory
            let csvPath = direcoryPath.appendingPathComponent(fileName + ".csv")
            do {
                try csv.write(to: csvPath, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("failed to write: \(error)")
                return
            }
            
            // CSVファイルをZIPにする
            let zipPath = direcoryPath.appendingPathComponent(fileName + ".zip")
            SSZipArchive.createZipFile(atPath: zipPath.path, withFilesAtPaths: [csvPath.path])
            if !FileManager.default.fileExists(atPath: zipPath.path) {
                print("return zip error")
                return
            }
            
            // 共有するファイルを新しいZIPファイルに置き換える
            sharePath = zipPath.path
            
            print("ファイルパス: \(sharePath)")
        }
    }
//    同期の関数
    func syncr() {
        sync=1
    }

    func share() {
        // データ取得前は共有しない
        if sharePath.isEmpty {
            return
        }
        // ファイルを共有画面(画面下から上がるポップアップ)にセット
        let items = [URL(fileURLWithPath: sharePath)] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // 共有画面を表示
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(activityVC, animated: true, completion: {})
    }
    
    private func updateMotionData(deviceMotion:CMDeviceMotion) {
        if !isStarted {
            return
        }
        
        elapsedTime = elapsedTime + 0.1
        
        
        let attitude = deviceMotion.attitude

        let qw = attitude.quaternion.w
        let qx = attitude.quaternion.x
        let qy = attitude.quaternion.y
        let qz = attitude.quaternion.z

        let qpitch = atan2((2 * (qw * qx + qy * qz)), 1 - 2 * (qx * qx + qy * qy))
        let qroll = 2*atan2 ( sqrt ( 1 + 2 * ( qw * qy - qx * qz )),sqrt ( 1 - 2 * ( qw * qy - qx * qz )) ) - (Double.pi/2)
        
        xStr = String(format:"%.2f",deviceMotion.attitude.pitch*180 / Double.pi )
        xStr2 = String(format:"%.2f",qpitch*180 / Double.pi)
        yStr = String(format:"%.2f",deviceMotion.attitude.roll*180 / Double.pi )
        yStr2 = String(format:"%.2f",qroll*180 / Double.pi)

        
        if Standing{
                    xStr = String(format:"%.2f",(deviceMotion.attitude.pitch*180 / Double.pi)-90)
                }else{
                    xStr = String(format:"%.2f",deviceMotion.attitude.pitch*180 / Double.pi)
                }
        
        
        if Standing{
            xStr2 = String(format:"%.2f",qpitch*180 / Double.pi-90)
            }else{
                xStr2 = String(format:"%.2f",qpitch*180 / Double.pi)
                
            
        }
        
        //let nxStr:Double = Double(xStr2)!
        
        // データを配列に追加
        
        
        
        
        let data = MotionData(elapsedTime: elapsedTime, x:deviceMotion.attitude.pitch*180 / Double.pi,x2:qpitch*180 / Double.pi,y:deviceMotion.attitude.roll*180 / Double.pi, y2:qroll*180 / Double.pi,sync: sync)
                datas.append(data)
        
        //同期
        if sync == 1 {
            sync = 0
            
        }
    }
    
}
