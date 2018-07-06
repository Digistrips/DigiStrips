//
//  presetColor.swift
//  TestCamera
//
//  Created by Kaixuan Zhou on 5/26/18.
//  Copyright © 2018 Digistrips.com. All rights reserved.
//

import Foundation
import UIKit

// This is the preset color class.
// Member Info should be changed to a Bool value
class presetColor{
    
    let red : Int
    let green : Int
    let blue : Int
    let info : String
    
    init(r: Int, g: Int, b: Int, info: String) {
        red = r
        green = g
        blue = b
        self.info = info
    }

}

// == operator overload
func == (left: presetColor, right: presetColor) -> Bool {
    if(left.red != right.red){
        return false
    }
    if(left.green != right.green){
        return false
    }
    if(left.blue != right.blue){
        return false
    }
    return true
}

class colors{
    let red : Double
    let green : Double
    let blue : Double
    init(r: Double, g: Double, b: Double) {
        red = r
        green = g
        blue = b
    }
}

class colorBank{
    var arrayOfColor = [presetColor]()
    init(){
//        Needs to change No and Yes into Bool value. Otherwise so stupid
//        The White Color range
        arrayOfColor.append(presetColor(r: 235, g: 229, b: 177, info: "No"))
        arrayOfColor.append(presetColor(r: 223, g: 220, b: 218, info: "No"))
//        Pink and purple color range
        arrayOfColor.append(presetColor(r: 234, g: 216, b: 217, info: "Yes"))
        arrayOfColor.append(presetColor(r: 223, g: 188, b: 172, info: "Yes"))
        arrayOfColor.append(presetColor(r: 237, g: 175, b: 179, info: "Yes"))
        arrayOfColor.append(presetColor(r: 225, g: 193, b: 202, info: "Yes"))
        arrayOfColor.append(presetColor(r: 204, g: 182, b: 201, info: "Yes"))
        arrayOfColor.append(presetColor(r: 200, g: 172, b: 171, info: "Yes"))
        arrayOfColor.append(presetColor(r: 200, g: 152, b: 147, info: "Yes"))
        arrayOfColor.append(presetColor(r: 195, g: 105, b: 139, info: "Yes"))
        arrayOfColor.append(presetColor(r: 182, g: 129, b: 143, info: "Yes"))
        
//       Purple color range
        arrayOfColor.append(presetColor(r: 178, g: 164, b: 179, info: "Yes"))
        arrayOfColor.append(presetColor(r: 161, g: 132, b: 171, info: "Yes"))
        arrayOfColor.append(presetColor(r: 148, g: 118, b: 130, info: "Yes"))
        arrayOfColor.append(presetColor(r: 130, g: 111, b: 131, info: "Yes"))
        arrayOfColor.append(presetColor(r: 148, g: 118, b: 130, info: "Yes"))
        arrayOfColor.append(presetColor(r: 128, g: 88, b: 118, info: "Yes"))
        arrayOfColor.append(presetColor(r: 161, g: 51, b: 100, info: "Yes"))
        arrayOfColor.append(presetColor(r: 161, g: 51, b: 100, info: "Yes"))
        arrayOfColor.append(presetColor(r: 203, g: 78, b: 129, info: "Yes"))
        arrayOfColor.append(presetColor(r: 119, g: 92, b: 137, info: "Yes"))
        arrayOfColor.append(presetColor(r: 115, g: 54, b: 88, info: "Yes"))
        
        
//        Pink color range
        arrayOfColor.append(presetColor(r: 240, g: 209, b: 220, info: "Yes"))
        arrayOfColor.append(presetColor(r: 240, g: 192, b: 203, info: "Yes"))
        arrayOfColor.append(presetColor(r: 240, g: 183, b: 197, info: "Yes"))
        arrayOfColor.append(presetColor(r: 240, g: 142, b: 172, info: "Yes"))
        arrayOfColor.append(presetColor(r: 240, g: 142, b: 172, info: "Yes"))
        arrayOfColor.append(presetColor(r: 240, g: 142, b: 172, info: "Yes"))
        arrayOfColor.append(presetColor(r: 240, g: 142, b: 172, info: "Yes"))
    }
    
    
    func selectSimilar(aColor: colors)->String{
        
        
        
        for color in arrayOfColor{
            if(color == arrayOfColor[0]){
                if(calculateDiff(aColor: aColor, color: color) <= 35){
                    return color.info
                }
            }else if(color == arrayOfColor[1]){
                if(calculateDiff(aColor: aColor, color: color) <= 10){
                    return color.info
                }
            }
            else{
                if(calculateDiff(aColor: aColor, color: color) <= 20){
                    return color.info
                }
            }
        }
        return "No"
    }
    
    func diff(aColor: colors)->Int{
        for color in arrayOfColor{
            if(calculateDiff(aColor: aColor, color: color) <= 20){
                return calculateDiff(aColor: aColor, color: color)
            }
        }
        return 0
    }
    
    func calculateDiff(aColor: colors, color: presetColor)->Int{
        let rd = pow((aColor.red - Double(color.red)),2)
        let gd = pow((aColor.green - Double(color.green)), 2)
        let bd = pow((aColor.blue - Double(color.blue)), 2)
        return Int(sqrt(rd+gd+bd))
    }
}
