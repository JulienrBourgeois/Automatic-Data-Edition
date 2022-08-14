//
//  ViewController.swift
//  Automatic Data Collector
//
//  Created by Julien Paid Developer on 8/8/22.
//

import UIKit
import WatchConnectivity
import SpriteKit
import AudioToolbox


class ViewController: UIViewController, WCSessionDelegate {
    
    var dataList : [String : [String : [Double]]] = [:]
    var fileName : String = ""
    var shotCount = 0
    var defaults = UserDefaults()
    @IBOutlet var spriteScene : SKView!
    @IBOutlet var statusLabel : UILabel!
    
    var recieved : Bool = false
    
    
  
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Phone started")
    }
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        self.dataList = userInfo["Data"] as! [String: [String: [Double]]]
        self.fileName = userInfo["FileName"] as! String
        
        SaveShots()
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }

        recieved = true
        
        
        OperationQueue.main.addOperation {
            self.changeStuff(color: "Green")
        }
            
        
        
    
        WCSession.default.transferUserInfo(["GotMessage":"YAY"])
    }
    
    func changeStuff(color :String)
    {
        if color == "Green"
        {
            statusLabel.textColor = .green
            statusLabel.text = "Data Recieved!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                // Put your code which should be executed with a delay here
                
                self.statusLabel.text = "No Data Recieved"
                self.statusLabel.textColor = .red
            }
       
    }
        
    }
   
    
    
    func SaveShots()
    {
        var csvString = ""
        
        for i in 0 ... dataList.count - 1
        {
            let currentShot = dataList["\(i)"]
            
            csvString = WriteToCsv(listList: currentShot!)
            
            shotCount += 1
            defaults.set(shotCount, forKey: "ShotCount")
            
         
            
            let name = "\(fileName).\(shotCount)"
            
            
            let documentDirectoryUrl = try! FileManager.default.url(
                for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
            )
            
            let fileUrl = documentDirectoryUrl.appendingPathComponent(name).appendingPathExtension("csv")
            
            do {
               try csvString.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
                
                print("Saved")
                
                print("File path \(fileUrl.path)")
            } catch let error as NSError {
               print (error)
            }
            
        }
        
        
    }
    
    func WriteToCsv(listList: [String: [Double]]) -> String
    {
        var finalString = "AccelerationX,AccelerationY,AccelerationZ,RotationX,RotationY,RotationZ,Degrees\n"
        
        print(listList["AccelerationX"]!.count)
        print(listList["AccelerationY"]!.count)
        print(listList["AccelerationZ"]!.count)
        print(listList["RotationX"]!.count)
        print(listList["RotationY"]!.count)
        print(listList["RotationZ"]!.count)
        print(listList["Degrees"]!.count)

        
        
        for i in 0 ... listList["AccelerationX"]!.count - 1
        {
            finalString += "\(listList["AccelerationX"]![i]),\(listList["AccelerationY"]![i]),\(listList["AccelerationZ"]![i]),\(listList["RotationX"]![i]),\(listList["RotationY"]![i]),\(listList["RotationZ"]![i]),\(listList["Degrees"]![i])\n"
        }
         
        
        print(finalString)

        return finalString
    }
    
  
    
    
    
    
    
    var session : WCSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (WCSession.isSupported())
        {
                let session = WCSession.default
                session.delegate = self //requires `WCSessionDelegate` protocol, so implement the required delegates as well
            session.activate()
        }
        
        //defaults.set(0, forKey: "ShotCount")
        
        if defaults.object(forKey: "ShotCount") != nil
        {
            shotCount = defaults.object(forKey: "ShotCount") as! Int
        }
        else
        {
            defaults.set(0, forKey: "ShotCount")
            shotCount = 0
        }
        
        
       
        
        
    }


}

