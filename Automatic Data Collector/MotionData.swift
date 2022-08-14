//
//  MotionData.swift
//  Automatic Data Collector
//
//  Created by Julien Paid Developer on 8/10/22.
//


import Foundation


class MotionData
{
    var accelerometerX : [Double] = []
    var accelerometerY : [Double] = []
    var accelerometerZ : [Double] = []
    var rotationX : [Double] = []
    var rotationY: [Double] = []
    var rotationZ : [Double] = []
    var degrees : [Double] = []
    
    
    var name : String = ""
    
    
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
}
