//
//  InformationInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/9/22.
//

import WatchKit
import Foundation


class InformationInterfaceController: WKInterfaceController {
    
    //IBOutlets
    @IBOutlet var nameInput : WKInterfaceTextField!
    @IBOutlet var nameLabel : WKInterfaceLabel!
    @IBOutlet var continueButton : WKInterfaceButton!
    
    var name : String = ""
    var newName : Bool = false
    var defaults = UserDefaults()
    
    @IBAction func nameInputChanged(_ value: NSString?)
    {
        if value != nil
        {
            name = value! as String
        }
    }
    
    
    @IBAction func continueClicked()
    {
        var errorString = ""
        var nonString = ""
        
        if newName == true
        {
            errorString = "Cannot continue without your new name"
            nonString = "Please enter your new name: "
        }
        else
        {
            errorString = "Cannot continue without your name"
            nonString = "Please enter your name below: "
        }
        
        
        if name == ""
        {
            print("nothing")
            print(name)
            WKInterfaceDevice().play(.retry)
            nameLabel.setText(errorString)
            nameLabel.setTextColor(.red)
            continueButton.setAlpha(0)
            
            //Leave red text for a second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Put your code which should be executed with a delay here
                
                self.nameLabel.setText(nonString)
                self.nameLabel.setTextColor(.init(named: "Yellow"))
                self.continueButton.setAlpha(1)
            }
                    
          
    
          

        }
        else
        {
            print("something")
            print(name)
            
            if newName
            {
                defaults.set(name, forKey: "Name")
            }
            
            WKInterfaceDevice().play(.click)
            
            pushController(withName: "PickerInterfaceController", context: name)
        }
    }
    
   

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let stringContext = context as! String
        
        if stringContext == "newName"
        {
            nameLabel.setText("Please enter your new name: ")
            newName = true
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
