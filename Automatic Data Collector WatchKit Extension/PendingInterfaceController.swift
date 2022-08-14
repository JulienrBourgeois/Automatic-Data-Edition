//
//  PendingInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/10/22.
//

import WatchKit
import Foundation
import WatchConnectivity
import SpriteKit


class PendingInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var spriteScene : WKInterfaceSKScene!
    
    var timer : Timer?

    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("LOL")
    }
    
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            
            self.statusLabel.setText("Data Sent!")
            
            print("recieved")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Put your code which should be executed with a delay here
                self.pushController(withName: "HomeInterfaceController", context: "NO")
            }
            
           
            
        }
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        startSpriteScene()
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
