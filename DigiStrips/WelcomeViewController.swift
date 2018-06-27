//
//  InfoViewController.swift
//  TestCamera
//
//  Created by Kaixuan Zhou on 5/21/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var label : UILabel = UILabel(frame: CGRect(x: 100, y: 200, width: 300, height: 40))
    var UTIbutton : UIButton = UIButton(frame:CGRect(x: 100, y: 400, width: 100, height: 50))
    var exampleButton1 : UIButton = UIButton(frame: .zero)
    var exampleButton2 : UIButton = UIButton(frame: .zero)
    var exampleButton3 : UIButton = UIButton(frame: .zero)
    var descriptionLabel : UILabel = UILabel(frame: .zero)
    let themeColor = UIColor(red: 21/255.0, green: 85/255.0, blue: 154/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = themeColor
        
        let colorList = [UIColor(red: 93/255.0, green: 49/255.0, blue: 49/255.0, alpha: 1.0),
                         UIColor(red: 222/255.0, green: 120/255.0, blue: 151/255.0, alpha: 1.0),
                         UIColor(red: 249/255.0, green: 244/255.0, blue: 229/255.0, alpha: 1.0),
                         UIColor(red: 92/255.0, green: 34/255.0, blue: 35/255.0, alpha: 1.0)]
        
        var counter = 2
        var index = 0
        for _ in 0...3 {
            let lineView = UIView()
            if counter == 4{ counter = 2}
            self.view.addSubview(lineView)
            lineView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lineView.topAnchor.constraint(equalTo: view.topAnchor,constant: CGFloat(335+index*60)),
                lineView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
                lineView.widthAnchor.constraint(equalToConstant: 2),
                lineView.heightAnchor.constraint(equalToConstant: 25)])
            lineView.layer.borderWidth = 2.0
            lineView.layer.cornerRadius = 3.0
            lineView.layer.borderColor = colorList[counter].cgColor
            lineView.layer.shadowColor = UIColor.black.cgColor
            lineView.layer.shadowOpacity = 0.5
            lineView.layer.shadowOffset = CGSize.zero
            lineView.layer.shadowRadius = 0.2
            counter += 1
            index += 1
        }
        
        counter = 2
        index = 0
        
        let tempList = [UIColor(red: 249/255.0, green: 244/255.0, blue: 229/255.0, alpha: 0.7),
                        UIColor(red: 92/255.0, green: 34/255.0, blue: 35/255.0, alpha: 0.7),
                        UIColor(red: 249/255.0, green: 244/255.0, blue: 229/255.0, alpha: 0.7),
                        UIColor(red: 92/255.0, green: 34/255.0, blue: 35/255.0, alpha: 0.7)]
        
        [UTIbutton,exampleButton1,exampleButton2,exampleButton3].forEach{
            view.addSubview($0)
            if counter == 4{ counter = 2}
            ($0).translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                ($0).topAnchor.constraint(equalTo: view.topAnchor,constant: CGFloat(333+index*60)),
                ($0).centerXAnchor.constraint(equalTo: view.centerXAnchor),
                ($0).widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80),
                ($0).heightAnchor.constraint(equalToConstant: 30)])
            ($0).setTitleColor(colorList[counter], for: .normal)
            ($0).titleLabel?.font = UIFont(name:"Avenir-Light", size: 20.0)
            ($0).contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            ($0).setTitle("\(index+1) test button", for: .normal)
            ($0).backgroundColor = tempList[3-index]
            ($0).layer.cornerRadius = 3.0
            counter += 1
            index += 1
        }
        exampleButton1.setTitle("STD self test", for: .normal)
        exampleButton2.setTitle("Glucose test", for: .normal)
        exampleButton3.setTitle("Bilirubin test", for: .normal)
        
        [label,UTIbutton].forEach{ view.addSubview($0) }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor,constant: 90),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 70),
            label.heightAnchor.constraint(equalToConstant: 100)])
        
        label.text = "Digistrips"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name:"Avenir-Light", size: 70.0)
        
        
        descriptionLabel.numberOfLines = 2
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 170),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100)])
        
        
        descriptionLabel.text = "we care about your health and want you to get accurate and fast results"
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont(name:"Avenir-Light", size: 16.0)
        
        
        
        label.anchor(top: view.topAnchor, bottom: nil, leading: view.centerXAnchor, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 200),centerX: true, centerY: false)
        
        
        UTIbutton.setTitle("UTI self test", for: .normal)
        //        UTIbutton.addTarget(self, action: #selector(self.goToUTI(_:)), for: .touchUpInside)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.UTIbuttonWasTapped(_:)))
        UTIbutton.addGestureRecognizer(gesture)
        
        
    }
    
    @objc func UTIbuttonWasTapped(_ gesture: UITapGestureRecognizer){
        
        print("tapped")
        let UTIView = UTIViewController()
        
        UTIbutton.alpha = 1
        
        UIButton.animate(withDuration: 0.3) {
            self.UTIbutton.alpha = 0.5
            self.UTIbutton.setTitleColor(UIColor.darkGray, for: .normal)
        }
        
        show(UTIView, sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        [exampleButton1,exampleButton2,exampleButton3,UTIbutton].forEach{ ($0).isHidden = true }
    }
    
    func changeAnimation(aView : UIButton){
        aView.alpha = 0
        aView.isHidden = false
        UIButton.animate(withDuration: 0.5) {
            aView.alpha = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        [UTIbutton,exampleButton1,exampleButton2,exampleButton3].forEach{changeAnimation(aView: $0)}
    }
    
}


extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero, centerX : Bool = false, centerY : Bool = false){
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            if centerY{
                centerYAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            } else if !centerY {
                topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            }
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let leading = leading {
            if centerX{
                centerXAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
            } else if !centerX{
                leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
            }
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
            
        }
        
    }
}

