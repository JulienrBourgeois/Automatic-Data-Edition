//
//  MotionData.swift
//  Automatic Data Collector WatchKit Extension
//
//  Created by Julien Paid Developer on 8/9/22.
//

import Foundation


class MotionData: NSObject, NSCopying
{
    func copy(with zone: NSZone? = nil) -> Any {
        return MotionData(accelerometerX: accelerometerX, accelerometerY: accelerometerY, accelerometerZ: accelerometerZ, rotationX: rotationX, rotationY: rotationY, rotationZ: rotationZ, degrees: degrees)
    }
    
    var accelerometerX : [Double] = []
    var accelerometerY : [Double] = []
    var accelerometerZ : [Double] = []
    var rotationX : [Double] = []
    var rotationY: [Double] = []
    var rotationZ : [Double] = []
    var degrees : [Double] = []
    
    
    var name : String = ""
    
    var dict : [String : [Double]] = [:]
    
    
    init(accelerometerX: [Double], accelerometerY: [Double], accelerometerZ: [Double], rotationX: [Double], rotationY: [Double], rotationZ: [Double], degrees: [Double])
    {
        self.accelerometerX = accelerometerX
        self.accelerometerY = accelerometerY
        self.accelerometerZ = accelerometerZ
        self.rotationX = rotationX
        self.rotationY = rotationY
        self.rotationZ = rotationZ
        self.degrees = degrees
    }
    
    
    
    
    func RemoveAll()
    {
        accelerometerX.removeAll()
        accelerometerY.removeAll()
        accelerometerZ.removeAll()
        rotationX.removeAll()
        rotationY.removeAll()
        rotationZ.removeAll()
        degrees.removeAll()
    }
    
    
    func wrapIntoDict() -> [String : [Double]]
    {
        dict["AccelerationX"] = accelerometerX
        dict["AccelerationY"] = accelerometerY
        dict["AccelerationZ"] = accelerometerZ
        dict["RotationX"] = rotationX
        dict["RotationY"] = rotationY
        dict["RotationZ"] = rotationZ
        dict["Degrees"] = degrees

        
        return dict
    }
}
