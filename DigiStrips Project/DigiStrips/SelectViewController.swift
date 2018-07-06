//
//  SelectViewController.swift
//  DigiStrips
//
//  Created by Kaixuan Zhou on 6/20/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//

import UIKit


class SelectViewController: UIViewController {
    
    var checkBoxList = [BEMCheckBox]()
    var labelList = [UILabel]()
    var expandList = [UIButton]()
    var lineList = [UIView]()
    var wraps = [aWrap]()
    var twice = false
    var lastTapIndex = -1
    
    let symptoms = ["Frequent, urge urination",
                    "Burning pee",
                    "Nausea & Vomiting",
                    "Itchiness",
                    "Lower abdomen pain",
                    "Smelly cloudy urine",
                    "Blood in urine",
                    "Fever"]
    
    let nextButton = UIButton(frame: .zero)
    let themeColor = UIColor(red: 21/255.0, green: 85/255.0, blue: 154/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view1 is a view to display bgcolor for DigiStrips title.
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2 - 200))
        view.addSubview(view1)
        view1.backgroundColor = themeColor
        
        
        //heightIndex is the index for the height of the distance between each selections.
        let heightIndex = UIScreen.main.bounds.height / 13.5
        
        for i in 0...7{
            //1. set up the symptoms label
            
            let myLabel = UILabel(frame: .zero)
            view.addSubview(myLabel)
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                myLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant:50),
                myLabel.topAnchor.constraint(equalTo: view.topAnchor,constant:CGFloat(140 + Int(heightIndex)*(i+1))),
                myLabel.widthAnchor.constraint(equalToConstant: 250),
                myLabel.heightAnchor.constraint(equalToConstant: 26)])
            myLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(SelectViewController.tapFunction(_:)))
            myLabel.addGestureRecognizer(tap)
            myLabel.text = symptoms[i]
            myLabel.font = UIFont(name:"Avenir-Light", size: 18.0)
            labelList.append(myLabel)
            
            //2. set up the line separating each selection
            
            let lineView = UIView(frame: .zero)
            view.addSubview(lineView)
            lineView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lineView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                lineView.topAnchor.constraint(equalTo: myLabel.bottomAnchor,constant:5),
                lineView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                lineView.heightAnchor.constraint(equalToConstant: 1)])
            lineView.layer.borderWidth = 1.0
            lineView.layer.cornerRadius = 3.0
            lineView.layer.borderColor = UIColor.gray.cgColor
            lineList.append(lineView)
            
            //3. set up the symptoms image
            
            let symptomsView = UIButton(frame: .zero)
            view.addSubview(symptomsView)
            symptomsView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                symptomsView.rightAnchor.constraint(equalTo: myLabel.leftAnchor,constant:-10),
                symptomsView.topAnchor.constraint(equalTo: myLabel.topAnchor),
                symptomsView.widthAnchor.constraint(equalToConstant: 26),
                symptomsView.heightAnchor.constraint(equalToConstant: 26)])
            
            symptomsView.setImage(UIImage(named:"expandDots"), for: .normal)

            symptomsView.addTarget(self, action: #selector(expandExplanation), for: .touchUpInside)
            expandList.append(symptomsView)
            
            
            //4. set up the check box for the symptoms
            
            let myCheckBox = BEMCheckBox(frame: .zero)
            view.addSubview(myCheckBox)
            myCheckBox.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                myCheckBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
                myCheckBox.topAnchor.constraint(equalTo: view.topAnchor,constant:CGFloat(140 + Int(heightIndex)*(i+1))),
                myCheckBox.widthAnchor.constraint(equalToConstant: 26),
                myCheckBox.heightAnchor.constraint(equalToConstant: 26)])
            myCheckBox.setOn(false, animated: true)
            myCheckBox.onAnimationType = BEMAnimationType.bounce
            myCheckBox.offAnimationType = BEMAnimationType.bounce
            checkBoxList.append(myCheckBox)
            
            myCheckBox.boxType = BEMBoxType.square
            myCheckBox.onTintColor = themeColor
            myCheckBox.onCheckColor = UIColor.white
            myCheckBox.onFillColor = themeColor
            
            let awrap = aWrap(expand: symptomsView, text: myLabel, line: lineView, checkBox: myCheckBox)
            wraps.append(awrap)
            
            let hiddenInfo = UILabel(frame: .zero)
            view.addSubview(hiddenInfo)
            hiddenInfo.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hiddenInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant:30),
                hiddenInfo.topAnchor.constraint(equalTo: lineView.topAnchor,constant:10),
                hiddenInfo.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 70),
                hiddenInfo.heightAnchor.constraint(equalToConstant: 35)])
            hiddenInfo.text = "Just a Test Label"
            hiddenInfo.textColor = UIColor.black
            hiddenInfo.textAlignment = NSTextAlignment.left
            hiddenInfo.font = UIFont(name:"Avenir-Light", size: 15.0)
            hiddenInfo.alpha = 0.0
            awrap.addInfo(info: hiddenInfo)
        }
        
        
        let myLabel = UILabel(frame: .zero)
        view1.addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myLabel.centerXAnchor.constraint(equalTo: view1.centerXAnchor),
            myLabel.topAnchor.constraint(equalTo: view1.topAnchor,constant:30),
            myLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 70),
            myLabel.heightAnchor.constraint(equalToConstant: 80)])
        myLabel.text = "Digistrips"
        myLabel.textColor = UIColor.white
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.font = UIFont(name:"Avenir-Light", size: 70.0)
        
        let infoLabel = UILabel(frame: .zero)
        view1.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view1.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: myLabel.bottomAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 70),
            infoLabel.heightAnchor.constraint(equalToConstant: 40)])
        
        infoLabel.text = "Please Select Your Symptoms"
        infoLabel.textColor = UIColor.white
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont(name:"Avenir-Light", size: 20.0)
        
        
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view1.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            view1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)])
        
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:-8),
            nextButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 200),
            nextButton.heightAnchor.constraint(equalToConstant: 40)])
        nextButton.setTitle("Finished", for: .normal)
        nextButton.setTitleColor(themeColor, for: .normal)
        nextButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont(name:"Avenir-Light", size: 30.0)
    }
    
    
    @objc func pressButton(_ sender: UIButton){
        let nextView = WelcomeViewController()
        show(nextView, sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.animated()
    }
    
    
    func animated(){
        
    }
    
    @objc func expandExplanation(_ sender: UIButton){
        
        for element in wraps{
            if(element.isOn){
                element.moveUp()
            }
            element.hideHiddenInfo()
        }
        
        let index = expandList.index(of: sender)! + 1
        
    
        if twice{
            if lastTapIndex != index {twice = false}
        }
        
        if lastTapIndex != index{
            wraps[index-1].showHiddenInfo()
            lastTapIndex = index
            if index < expandList.count{
                for i in index...expandList.count-1{
                    wraps[i].moveDown()
                }
            }
        } else if twice{
            wraps[index-1].showHiddenInfo()
            if index < expandList.count{
                for i in index...expandList.count-1{
                    wraps[i].moveDown()
                }
            }
            twice = false
        } else{
            wraps[index-1].hideHiddenInfo()
            twice = true
        }
    
        
    }
    
    @objc func tapFunction(_ gesture: UITapGestureRecognizer){
        let index = labelList.index(of: gesture.view as! UILabel)
        checkBoxList[index!].setOn(!checkBoxList[index!].on, animated: true)
        checkBoxList[index!].onAnimationType = BEMAnimationType.bounce
        checkBoxList[index!].offAnimationType = BEMAnimationType.bounce
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0, 0, 0, 0)
    }
    var htmlRGB: String {
        return String(format: "#%02x%02x%02x", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255))
    }
    
}
