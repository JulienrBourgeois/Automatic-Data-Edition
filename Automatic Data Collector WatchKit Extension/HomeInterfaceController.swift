//
//  InterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/8/22.
//

import WatchKit
import Foundation
import SpriteKit


class HomeInterfaceController: WKInterfaceController {
    
    //IB Outlets
    @IBOutlet var spriteScene : WKInterfaceSKScene!
    @IBOutlet var startButton : WKInterfaceButton!
    
    
    var defaults = UserDefaults()
    
    @IBAction func startButtonClicked()
    {
        WKInterfaceDevice().play(.click)
        print("clicked")
        
        if defaults.object(forKey: "Name") == nil
        {
            pushController(withName: "InformationInterfaceController", context: "No")
        }
        else
        {
            pushController(withName:"PickerInterfaceController", context: "\(String(describing: defaults.object(forKey: "Name") as! String))!")
        }
    }
    

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    
        if context == nil
        {
           defaults.set("False", forKey: "WatchConnect")
            
            print("Watch Connect falsed")
       }
        
      
    }
    
    override func willActivate() {
        
        let scene = SKScene(fileNamed: "HomeAnimation")
        
        scene?.backgroundColor = .clear
        spriteScene.presentScene(scene)
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
