//
//  ShotInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/10/22.
//

import WatchKit
import Foundation
import CoreMotion


class ShotInterfaceController: WKInterfaceController, WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("yes")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("")
        
        startRecording()
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("")
    }
    
    
    //IB Outlets
    @IBOutlet var informationButton : WKInterfaceButton!
    @IBOutlet var trashButton : WKInterfaceButton!
    @IBOutlet var sendButton : WKInterfaceButton!
    @IBOutlet var recordButton : WKInterfaceButton!
    @IBOutlet var shotRecorderLabel : WKInterfaceLabel!
    
    var dataList : [MotionData] = []
    var defaults = UserDefaults()
    
    var motionManager = CMMotionManager()
    var nameSet : Bool = false
    var name : String = ""
    var isAccelerometer : Bool = false
    var isDeviceMotion : Bool = false
    var isRecording : Bool = false
    var startButtonJustClicked : Bool = false
    var updateInterval = 100.0
    var startSpikeDetected : Bool = false
    
    var session : WKExtendedRuntimeSession!
    var timer : Timer?
    
    
    var accelerationX : [Double] = []
    var accelerationY : [Double] = []
    var accelerationZ : [Double] = []
    var rotationX : [Double] = []
    var rotationY : [Double] = []
    var rotationZ : [Double] = []
    var degreesList : [Double] = []
    
    var fileDict : [String : Any] = [:]

    
    var currentMotionData : MotionData?

    @IBAction func informationButtonPressed()
    {
        WKInterfaceDevice().play(.click)
        presentController(withName: "HelpInterfaceController", context: "Shot")
    }
    
    @IBAction func trashButtonPressed()
    {
        if dataList.count > 0
        {
            WKInterfaceDevice().play(.click)
            presentController(withName: "ChoiceInterfaceController", context: "TrashShot")
        }
        else
        {
            WKInterfaceDevice().play(.retry)
        }
    }
    
    @IBAction func sendButtonPressed()
    {
        if dataList.count > 0
        {
            fileDict["Tag"] = ".Shot"
            fileDict["Files"] = dataList
            
        WKInterfaceDevice().play(.click)
        pushController(withName: "SendInterfaceController", context: fileDict)
        }
        else
        {
            WKInterfaceDevice().play(.retry)
        }
    }
    
    @IBAction func recordButtonPressed()
    {
        if isDeviceMotion && isAccelerometer && isRecording == false
        {
            session = WKExtendedRuntimeSession()
            session.delegate = self
            session.start()
            isRecording = true
            recordButton.setAlpha(0.0)
            startButtonJustClicked = true
        }
    }
    
    func startRecording()
    {
        var hertInterval = 0
        
        if isAccelerometer && isDeviceMotion && isRecording
        {
            let timer = Timer(fire : Date(), interval: (1/updateInterval), repeats: true, block: { [self] (timer) in
                
                let accelData = motionManager.accelerometerData
                let deviceMotion = motionManager.deviceMotion
                
                let accelX = Double(round(100 * (accelData?.acceleration.x)! ) / 100)
                let accelY = Double(round(100 * (accelData?.acceleration.y)! ) / 100)
                let accelZ = Double(round(100 * (accelData?.acceleration.z)! ) / 100)
                let roteX = Double(round(100 * (deviceMotion?.userAcceleration.x)! ) / 100)
                let roteY = Double(round(100 * (deviceMotion?.userAcceleration.y)! ) / 100)
                let roteZ = Double(round(100 * (deviceMotion?.userAcceleration.z)! ) / 100)

                let angle = sqrtf(Float(accelX * accelX + accelY * accelY + accelZ * accelZ))
                let degrees  = Double(round(100 * (Double(acosf(Float(accelZ)/angle)) * 180.0 / Double.pi - 90.0) / 100.0))
                
                let magnitude = sqrt(pow(accelX, 2) + pow(accelY, 2) + pow(accelZ, 2))
                
                if startButtonJustClicked
                {
                    WKInterfaceDevice().play(.click)
                    startButtonJustClicked = false
                }
                
                if magnitude > 2.0 && startSpikeDetected == false
                {
                    startSpikeDetected = true
                }
                
                if startSpikeDetected
                {
                    accelerationX.append(accelX)
                    accelerationY.append(accelY)
                    accelerationZ.append(accelZ)
                    rotationX.append(roteX)
                    rotationY.append(roteY)
                    rotationZ.append(roteZ)
                    degreesList.append(degrees)
                    
                    hertInterval += 1
                    
                    if hertInterval >= 200
                    {
                        currentMotionData = MotionData(accelerometerX: accelerationX, accelerometerY: accelerationY, accelerometerZ: accelerationZ, rotationX: rotationX, rotationY: rotationY, rotationZ: rotationZ, degrees: degreesList)
                        
                        
                      
                        dataList.append(currentMotionData!)
                        
                        shotRecorderLabel.setText("Files: \(dataList.count)")
                        accelerationX.removeAll()
                        accelerationY.removeAll()
                        accelerationZ.removeAll()
                        rotationX.removeAll()
                        rotationY.removeAll()
                        rotationZ.removeAll()
                        degreesList.removeAll()
                        hertInterval = 0
                        recordButton.setAlpha(1.0)
                        
                        WKInterfaceDevice().play(.success)
                        startSpikeDetected = false
                        isRecording = false 
                        timer.invalidate()
                    }
                }

                
               

                
                
                
            })
            
                RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        
        
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if nameSet == false
        {
            name = context as! String
            nameSet = true
        }
        
        if motionManager.isAccelerometerAvailable
        {
            isAccelerometer = true
            print("Accelerometer is available")
        }
        else
        {
            isAccelerometer = false
            print("Accelerometer is unavailable")
        }
        
        if motionManager.isDeviceMotionAvailable
        {
            isDeviceMotion = true
            print("Device motion is available")
        }
        else
        {
            isDeviceMotion = false
            print("Device motion is unavailable")
        }
        
        if defaults.object(forKey: "Name") == nil
        {
            defaults.set(name, forKey: "Name")
        }
        
        if isAccelerometer && isDeviceMotion
        {
            motionManager.startAccelerometerUpdates()
            motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical)
            motionManager.deviceMotionUpdateInterval = 1.0 / 100.0
            motionManager.accelerometerUpdateInterval = 1.0 / 100.0
        }
        
        shotRecorderLabel.setText("Files: \(dataList.count)")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    
        //defaults.set(nil, forKey: "TrashShot")
        
        if defaults.object(forKey: "TrashShot") != nil
        {
            if defaults.object(forKey: "TrashShot") as! String == "True"
                {
                dataList.remove(at: dataList.count - 1)
                shotRecorderLabel.setText("Files: \(dataList.count)")
                defaults.set("False", forKey: "TrashShot")
                }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
