//
//  PickerInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/9/22.
//

import WatchKit
import Foundation


class PickerInterfaceController: WKInterfaceController {
    
    //IBOutlets
    @IBOutlet var nameLabel : WKInterfaceLabel!
    @IBOutlet var otherButton : WKInterfaceButton!
    @IBOutlet var shotButton: WKInterfaceButton!
    @IBOutlet var changeNameButton: WKInterfaceButton!
    
    var name : String = ""
    var defaults = UserDefaults()
    
    @IBAction func otherButtonPressed()
    {
        pushController(withName: "OtherInterfaceController", context: name)
        WKInterfaceDevice().play(.click)
    }
    
    @IBAction func changeNameButtonPressed()
    {
        WKInterfaceDevice().play(.click)
        pushController(withName: "InformationInterfaceController", context: "newName")
        
    }
    
    
    
    @IBAction func shotButtonPressed()
    {
        pushController(withName: "ShotInterfaceController", context: name)
        WKInterfaceDevice().play(.click)
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if defaults.object(forKey: "Name") == nil
        {
            nameLabel.setText("\(context as! String)")
            name = context as! String
        }
        else
        {
            nameLabel.setText("\(String(describing: defaults.object(forKey: "Name") as! String))")
            name = context as! String
        }
        
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
