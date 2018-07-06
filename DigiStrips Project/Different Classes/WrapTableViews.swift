//
//  WrapTableViews.swift
//  DigiStrips
//
//  Created by 周凯旋 on 6/24/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//

import Foundation

class aWrap{
    
    var hiddenInfo = UILabel()
    
    let expand : UIButton
    let text : UILabel
    let line : UIView
    let checkBox : BEMCheckBox
    var isOn : Bool
    
    init(expand: UIButton, text: UILabel, line: UIView, checkBox: BEMCheckBox) {
        self.expand = expand
        self.text = text
        self.line = line
        self.checkBox = checkBox
        isOn = false
    }
    
    func addInfo(info:UILabel){
        hiddenInfo = info
    }
    
    func showHiddenInfo(){
        UIView.animate(withDuration: 1.0, animations: {
            self.hiddenInfo.alpha = 1.0
        })
    }
    
    func hideHiddenInfo(){
        UIView.animate(withDuration: 1.0, animations: {
            self.hiddenInfo.alpha = 0.0
        })
    }
    
    
    func moveUp(){
        isOn = false
        for element in [expand,text,line,checkBox]{
            var newFrame = element.frame
            newFrame.origin.y -= 50
            UIView.animate(withDuration: 1.0, animations: {
                element.frame = newFrame
            })
        }
    }
    
    func moveDown(){
        isOn = true
        for element in [expand,text,line,checkBox]{
            var newFrame = element.frame
            newFrame.origin.y += 50
            UIView.animate(withDuration: 1.0, animations: {
                element.frame = newFrame
            })
        }
    }
    
}
