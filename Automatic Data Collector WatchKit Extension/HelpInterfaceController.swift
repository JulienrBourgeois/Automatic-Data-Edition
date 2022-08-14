//
//  HelpInterfaceController.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/10/22.
//

import WatchKit
import Foundation


class HelpInterfaceController: WKInterfaceController {
    
    @IBOutlet var helpLabel : WKInterfaceLabel!
    
    
    var otherHelp = "1) Other data is every movement that is NOT a shot\n 2) To begin, click the record button. Every two seconds, you will feel a haptic vibration. This is a new sample of data being saved to the file list.\n 3) While recording, you should do movements like walking, running, passing, dribbling, and defending. Whatever you do, DO NOT SHOOT!\n 4) If you accidentally shoot, you can click the trash icon and delete your files. You can then start recording again from scratch.\n 5) Once you are done recording, you can press the share button which will send the files to your phone. This will only work if your phone companion  app is open and running.\n 6) After sending the data to your phone app, it will appear there. On your phone app, click the download icon next to the files you just sent.\n 7) Next, leave the Automatic app and navigate to the Files app on your phone. Here, under On My Iphone, the data will appear inside the Automatic Data Collector container.\n 8) Hold down on the folder that says Automatic Data Collector with the icon on it and click compress.\n 9) A new zip file will now appear in your files right next to where you just compressed. Hold down on this file and click share. Send it back to the Automatic development team so they can use it for the base AI!\n 10) Thank you for collecting other data! Collect some shot data if you would like as well! We can't wait to see you in our next beta launch!"
    
    var shotHelp = "1) Shot data is every time you shoot the ball. NOTHING ELSE!\n 2) To begin, click the record button. The data will for the shot will start recording when you start to move your hand fast.\n 3) Slowly move into position, and shoot. Make sure to hold a good follow through!\n 4)After you shoot, you will hear a completion sound. This means that the shot has been recorded.\n 5) Click record and repeat the same process until you have taken a good amount of shots!\n 6)If you think you messed up on one of your shots, that's okay! The trash button will allow you to delete the latest shot taken!\n 7)When you're ready to send the shots to your phone, hit the send button. Send the data over to your phone and wait for confirmation.\n 8) Your data can now be found in the files app on your iphone.\n 9) Go there, find the folder with the Automatic Data Collector icon on it, hold it down and compress it into a zip file.\n 10) Share this zip with the Automatic Dev team. Thank you. We can't wait to see you in our next beta launch!"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        let contextString = context as! String
        
        if contextString == "Other"
        {
            helpLabel.setText(otherHelp)
        }
        else if contextString == "Shot"
        {
            helpLabel.setText(shotHelp)
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
