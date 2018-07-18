//
//  PrescribedViewController.swift
//  TestCamera
//
//  Created by 周凯旋 on 6/3/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//

import UIKit

class PrescribedViewController: UIViewController {

    let backButton = UIButton(frame: .zero)
    let prescribeButton = UIButton(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let aLabel = UILabel(frame: .zero)

        
        
        aLabel.textAlignment = .center
        view.addSubview(aLabel)
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:-130),
            aLabel.widthAnchor.constraint(equalToConstant: 300),
            aLabel.heightAnchor.constraint(equalToConstant: 30)])
        aLabel.text="Connecting your virtual doctor..."
        aLabel.numberOfLines = 0
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        
        //var backButton = UIButton(frame: CGRect(x: 20, y: 40, width: 40, height: 30))
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 30)])
        // Do any additional setup after loading the view.
        
        let doctorView = UIImageView(frame: .zero)
        view.addSubview(doctorView)
        doctorView.translatesAutoresizingMaskIntoConstraints = false
        doctorView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            doctorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doctorView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:-20),
            doctorView.widthAnchor.constraint(equalToConstant: 300),
            doctorView.heightAnchor.constraint(equalToConstant: 300)])
        doctorView.image = UIImage(named:"doctors")
        
        
        view.addSubview(prescribeButton)
        prescribeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            prescribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            prescribeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            prescribeButton.widthAnchor.constraint(equalToConstant: 200),
            prescribeButton.heightAnchor.constraint(equalToConstant: 40)])
        prescribeButton.setTitle("Get Prescribed", for: .normal)
        prescribeButton.setTitleColor(UIColor.black, for: .normal)
        prescribeButton.addTarget(self, action: #selector(self.goToMap(_:)), for: .touchUpInside)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        backButton.setTitleColor(UIColor.darkGray, for: .normal)
        let homePageView = UTIViewController()
        
        show(homePageView, sender: self)
        
    }
    @objc func goToMap(_ sender: UIButton){
        let alert = UIAlertController(title: "Prescribed", message: "Your prescription is on the way", preferredStyle: .alert)
        let getPrescribed = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
        }
        alert.addAction(getPrescribed)
        
        present(alert,animated: true,completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}
