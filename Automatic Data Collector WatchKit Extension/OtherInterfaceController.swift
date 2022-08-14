//
//  OtherInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/9/22.
//

import WatchKit
import Foundation
import CoreMotion


class OtherInterfaceController: WKInterfaceController,WKExtendedRuntimeSessionDelegate {
    
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession)
    {
        print("")
        
        recordData()
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("")
    }
    
  
    var session : WKExtendedRuntimeSession!
    var defaults = UserDefaults()
    
    var name : String = ""
    var nameSet : Bool = false
    
    var timer : Timer?
    var motionManager = CMMotionManager()
    var updateInterval = 100.0
    
    var isAccelerometer : Bool = false
    var isDeviceMotion : Bool = false
    var isRecording : Bool = false
    var startButtonJustClicked : Bool = false
    
    var dataList : [MotionData] = []
   
    
    var fileDict : [String : Any] = [:]
    
    
    //IB Outlets
    @IBOutlet var startButton : WKInterfaceButton!
    @IBOutlet var stopButton : WKInterfaceButton!
    @IBOutlet var otherRecorderLabel : WKInterfaceLabel!
    @IBOutlet var trashButton : WKInterfaceButton!
    @IBOutlet var informationButton : WKInterfaceButton!
    @IBOutlet var sendButton : WKInterfaceButton!
    
    
    var accelerometerX : [Double] = []
    var accelerometerY : [Double] = []
    var accelerometerZ : [Double] = []
    var rotationX : [Double] = []
    var rotationY : [Double] = []
    var rotationZ : [Double] = []
    var degreesList : [Double] = []
    
    
    var currentMotionData : MotionData?

    @IBAction func trashButtonPressed()
    {
        if dataList.count > 0
        {
            WKInterfaceDevice().play(.click)
            presentController(withName: "ChoiceInterfaceController", context: "TrashOther")
        }
        else
        {
            WKInterfaceDevice().play(.retry)
        }
    }
    
    @IBAction func informationButtonPressed()
    {
        
            WKInterfaceDevice().play(.click)
            presentController(withName: "HelpInterfaceController", context: "Other")
        
     
    }
    
    @IBAction func sendButtonPressed()
    {
        if dataList.count > 0
        {
        fileDict["Tag"] = ".Other"
        fileDict["Files"] = dataList
            print(dataList[0].accelerometerX.count)
        WKInterfaceDevice().play(.click)
        pushController(withName: "SendInterfaceController", context: fileDict)
        }
        else
        {
            WKInterfaceDevice().play(.retry)
        }
    }
    
    
    @IBAction func startButtonPressed()
    {
        if isDeviceMotion && isAccelerometer && isRecording == false
        {
            
            session = WKExtendedRuntimeSession()
            session.delegate = self
            session.start()
            isRecording = true
            startButton.setAlpha(0.0)
            stopButton.setAlpha(1.0)
            startButtonJustClicked = true
        }
    }
    
    @IBAction func stopButtonPressed()
    {
        if isRecording
        {
            isRecording = false
            stopButton.setAlpha(0.0)
            startButton.setAlpha(1.0)
            session.invalidate()
            accelerometerX.removeAll()
            accelerometerY.removeAll()
            accelerometerZ.removeAll()
            rotationX.removeAll()
            rotationY.removeAll()
            rotationZ.removeAll()
            degreesList.removeAll()
            WKInterfaceDevice().play(.directionDown)
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
        
        otherRecorderLabel.setText("Files: \(dataList.count)")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        if defaults.object(forKey: "Trash?") != nil
        {
            if defaults.object(forKey: "Trash?") as! String == "True"
                {
                    dataList.removeAll()
                    otherRecorderLabel.setText("Files: 0")
                    defaults.set("False", forKey: "Trash?")
                }
            
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func recordData()
    {
        var hertInterval = 0
        
        if isDeviceMotion && isAccelerometer && isRecording
        {
            let timer = Timer(fire : Date(), interval: (1/updateInterval), repeats: true, block: { [self] (timer) in
                
                
                let accelData = motionManager.accelerometerData
                let deviceData = motionManager.deviceMotion
                
                let accelX = Double(round(100 * (accelData?.acceleration.x)! ) / 100)
                let accelY = Double(round(100 * (accelData?.acceleration.y)! ) / 100)
                let accelZ = Double(round(100 * (accelData?.acceleration.z)! ) / 100)
                let roteX = Double(round(100 * (deviceData?.userAcceleration.x)! ) / 100)
                let roteY = Double(round(100 * (deviceData?.userAcceleration.y)! ) / 100)
                let roteZ = Double(round(100 * (deviceData?.userAcceleration.z)! ) / 100)
                let angle = sqrtf(Float(accelX * accelX + accelY * accelY + accelZ * accelZ))
                let degrees  = Double(round(100 * (Double(acosf(Float(accelZ)/angle)) * 180.0 / Double.pi - 90.0) / 100.0))
                
                
                
                accelerometerX.append(accelX)
                accelerometerY.append(accelY)
                accelerometerZ.append(accelZ)
                rotationX.append(roteX)
                rotationY.append(roteY)
                rotationZ.append(roteZ)
                degreesList.append(degrees)
                
                
                hertInterval += 1
                
                if hertInterval >= 200
                {
                    currentMotionData = MotionData(accelerometerX: accelerometerX, accelerometerY: accelerometerY, accelerometerZ: accelerometerZ, rotationX: rotationX, rotationY: rotationY, rotationZ: rotationZ, degrees: degreesList)
                    
                    
                  
                    dataList.append(currentMotionData!)
                    
                  
                    print(dataList[0].accelerometerX.count)
                    otherRecorderLabel.setText("Files: \(dataList.count)")
                    accelerometerX.removeAll()
                    accelerometerY.removeAll()
                    accelerometerZ.removeAll()
                    rotationX.removeAll()
                    rotationY.removeAll()
                    rotationZ.removeAll()
                    degreesList.removeAll()
                    hertInterval = 0
                }
                else if hertInterval == 1 && startButtonJustClicked == false
                {
                  
                        WKInterfaceDevice().play(.click)
                }
                
                if startButtonJustClicked
                {
                    WKInterfaceDevice().play(.directionUp)
                    startButtonJustClicked = false
                }
                
                if isRecording == false
                {
                    timer.invalidate()
                }

                
            })
            
                RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        
        }
        

    }

}
