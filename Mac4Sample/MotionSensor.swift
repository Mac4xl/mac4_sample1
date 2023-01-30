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
    @Published var yStr = "0.0"
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
            var csv = "Time,X,Y,Z,sync\n"
            datas.forEach { data in
                csv.append(contentsOf: "\(String(format:"%.2f",data.elapsedTime)),\(data.x),\(data.y),\(data.z),\(data.sync)\n")
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
        
        xStr = String(deviceMotion.attitude.pitch*180 / Double.pi)
        yStr = String(deviceMotion.attitude.roll*180 / Double.pi )
        zStr = String(deviceMotion.attitude.yaw*180 / Double.pi )
        
        if Standing{
            xStr = String((deviceMotion.attitude.pitch*180 / Double.pi)-90)
        }else{
            xStr = String(deviceMotion.attitude.pitch*180 / Double.pi)
        }
        
        
        // データを配列に追加
        let data = MotionData(elapsedTime: elapsedTime, x: deviceMotion.userAcceleration.x, y: deviceMotion.userAcceleration.y, z: deviceMotion.userAcceleration.z,sync: sync)
                datas.append(data)
        
        if sync == 1 {
            return sync = 0
            
        }
    }
    
}
