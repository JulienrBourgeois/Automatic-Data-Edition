//
//  SendInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/10/22.
//

import WatchKit
import Foundation
import WatchConnectivity
import SpriteKit


class SendInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch connect started")
    }
    
    
 
   
    
    
    //IBOutlets
    @IBOutlet var statusLabel : WKInterfaceLabel!
    @IBOutlet var sendButton : WKInterfaceButton!
    @IBOutlet var spriteScene : WKInterfaceSKScene!
    
    var dataList : [MotionData] = []
    var fileTag : String = ""
    var defaults = UserDefaults()
    
    
    
    var fileName : String = ""
    
    var watchSession : WCSession?
    
    var timer : Timer?
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        self.statusLabel.setText("Data Sent!")
        self.statusLabel.setTextColor(.green)
        WKInterfaceDevice().play(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Put your code which should be executed with a delay here
            self.pushController(withName: "HomeInterfaceController", context: "NO")
        }
        
    }
    
    
    @IBAction func sendButtonPressed()
    {
        if dataList.count > 0
        {
            var dict : [String: Any] = [:]
            var motionData : [String: Any] = [:]
            
        
        
        for i in 0 ... dataList.count - 1
        {
            var listList = dataList[i].wrapIntoDict()
            
            motionData["\(i)"] = listList
            
        }
        
        dict["Data"] = motionData
        dict["FileName"] = fileName

        let userInfo = dict
            
            WCSession.default.transferUserInfo(userInfo)
            
     
            sendButton.setTitle("Resend")
            
            statusLabel.setText("Open iphone app")
            sendButton.setAlpha(0)
            statusLabel.setTextColor(.red)
        
        }
       
       
        

       
        
        
    }
    
    
    
    func SendFiles()
    {
        
    }
    
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let context = context as? [String: Any]
        {
           
            dataList = context["Files"] as! [MotionData]
            print(dataList.count)
            fileTag = context["Tag"] as! String
            
            let name = defaults.object(forKey: "Name") as! String
            
            fileName = "\(name)\(fileTag)"
            
        }
        
        
        
        if (WCSession.isSupported()) {
                let session = WCSession.default
                session.delegate = self //requires `WCSessionDelegate` protocol, so implement the required delegates as well
            if session.activationState == .notActivated
            {
                session.activate()
            }
            
            print("activating session")
            
        }
      
    }
    
    func startSpriteScene()
    {
        timer = Timer(fire: Date(), interval: 120.0/60.0, repeats: true, block: { [self] (timer) in
            
            
            let scene = SKScene(fileNamed: "ConnectAnimation")
            
            scene?.backgroundColor = .clear
            spriteScene.presentScene(scene)
            
          
            
            
            
        })
        
        
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        startSpriteScene()

    }
    
    override func willDisappear() {
        timer?.invalidate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        super.didDeactivate()
    }

}
