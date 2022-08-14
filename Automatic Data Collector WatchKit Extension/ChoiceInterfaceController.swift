//
//  ChoiceInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/9/22.
//

import WatchKit
import Foundation


class ChoiceInterfaceController: WKInterfaceController {
    
    //IBOutlets
    @IBOutlet var questionLabel : WKInterfaceLabel!
    @IBOutlet var yesButton : WKInterfaceButton!
    
    var stringContext = ""
    
    var defaults = UserDefaults()
   
    
    @IBAction func yesButtonClicked()
    {
        self.dismiss()
       
        if stringContext == "TrashOther"
        {
            defaults.set("True", forKey: "Trash?")
            WKInterfaceDevice().play(.stop)
        }
        else if stringContext == "TrashShot"
        {
            defaults.set("True", forKey: "TrashShot")
            WKInterfaceDevice().play(.stop)
        }
    }
    
  

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        stringContext = context as! String
    
        
        if stringContext == "TrashOther"
        {
            questionLabel.setText("Delete these files?")
        }
        else if stringContext == "TrashShot"
        {
            questionLabel.setText("Delete last shot?")
        }
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
