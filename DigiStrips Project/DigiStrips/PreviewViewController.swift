//
//  PreviewViewController.swift
//  DigiStrips
//
//  Created byKaixuan Zhou on 6/16/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//


import UIKit
import Vision

class PreviewViewController: UIViewController {
    
    
    init(image:UIImage) {
        self.imageCaptured = image
        calculateButton.setTitle("Calculate", for: .normal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    var imageCaptured : UIImage?
    var caseview: UIImageView = UIImageView(frame: .zero)
    var caseview2: UIImageView = UIImageView(frame: .zero)
    var caseview3: UIImageView = UIImageView(frame: .zero)
    var caseviews = [UIImageView]()
    var calculateButton = UIButton(frame: .zero)
    let REF = UILabel(frame: .zero)
    let LEU = UILabel(frame: .zero)
    let NIT = UILabel(frame: .zero)
    let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let backButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFill
        imageView.image = imageCaptured
        view.addSubview(imageView)
        caseviews.append(caseview)
        caseviews.append(caseview2)
        caseviews.append(caseview3)
        view.addSubview(calculateButton)
        view.addSubview(backButton)
        styleCaseView()
        styleButton()
        styleLabels()
        
        
    }
    
    func styleLabels(){
        view.addSubview(REF)
        view.addSubview(LEU)
        view.addSubview(NIT)
        [REF,LEU,NIT].forEach{
            view.addSubview($0)
            ($0).translatesAutoresizingMaskIntoConstraints = false
            ($0).textColor = UIColor.white
        }
        REF.text = "REF"
        LEU.text = "LEU"
        NIT.text = "NIT"
        NSLayoutConstraint.activate([
            REF.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:-60),
            REF.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            REF.widthAnchor.constraint(equalToConstant: 100),
            REF.heightAnchor.constraint(equalToConstant: 30)])
        NSLayoutConstraint.activate([
            LEU.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:60),
            LEU.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:-50),
            LEU.widthAnchor.constraint(equalToConstant: 100),
            LEU.heightAnchor.constraint(equalToConstant: 30)])
        NSLayoutConstraint.activate([
            NIT.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:60),
            NIT.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:50),
            NIT.widthAnchor.constraint(equalToConstant: 100),
            NIT.heightAnchor.constraint(equalToConstant: 30)])
        
        
    }

    func styleCaseView(){
    
        for cases in caseviews{
            view.addSubview(cases)
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(_:)))
            cases.addGestureRecognizer(gesture)
            cases.isUserInteractionEnabled = true
            
            cases.translatesAutoresizingMaskIntoConstraints = false
            cases.contentMode = .scaleAspectFit
            cases.layer.borderWidth = 2
            cases.layer.borderColor = UIColor.white.cgColor
            cases.layer.shadowColor = UIColor.black.cgColor
            cases.layer.shadowOpacity = 0.5
            cases.layer.shadowOffset = CGSize.zero
            cases.layer.shadowRadius = 3
            cases.layer.cornerRadius = 4.0
        }
        
        NSLayoutConstraint.activate([
            caseview.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:-60),
            caseview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            caseview.widthAnchor.constraint(equalToConstant: 30),
            caseview.heightAnchor.constraint(equalToConstant: 30)])
        
        
        NSLayoutConstraint.activate([
            caseview2.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:60),
            caseview2.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:-50),
            caseview2.widthAnchor.constraint(equalToConstant: 30),
            caseview2.heightAnchor.constraint(equalToConstant: 30)])
        NSLayoutConstraint.activate([
            caseview3.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:60),
            caseview3.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:50),
            caseview3.widthAnchor.constraint(equalToConstant: 30),
            caseview3.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    func styleButton(){
        
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        calculateButton.addTarget(self, action: #selector(self.calculate(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:-100),
            calculateButton.widthAnchor.constraint(equalToConstant: 200),
            calculateButton.heightAnchor.constraint(equalToConstant: 50)])
        
        //the back button to the view Controller
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        
        //var backButton = UIButton(frame: CGRect(x: 20, y: 40, width: 40, height: 30))
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func calculate(_ sender: UIButton){
        var colors = [UIColor]()
        for cases in caseviews{
            let rect = cases.frame
            let newView = UIImageView(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            newView.image = imageCaptured
            
            let croppedImage = ZImageCropper.cropImage(ofImageView: newView, withinPoints: [
                CGPoint(x: rect.origin.x, y: rect.origin.y),   //Start point
                CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y),
                CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y+rect.size.height),
                CGPoint(x: rect.origin.x, y: rect.origin.y+rect.size.height)  //End point
                ])
            cases.image = croppedImage?.cropAlpha()
            colors.append((cases.image?.pickColor())!)
        }
        print(colors)
        let result = giveResult(colorList: colors)
        popUpResult(results: result)
    }
    
    func popUpResult(results: [Int]){
        let alert = UIAlertController(title: "Color Reading", message: "Ref Group Color:\(results[0])\nLeu Color:\(results[1])\nNit Color:\(results[2])", preferredStyle: .alert)
        let seeMoreInfo = UIAlertAction(title: "More info", style: .default) { (UIAlertAction) in
            
        }
        let ignore = UIAlertAction(title: "Ignore", style: .default) { (UIAlertAction) in
            
        }
        
        alert.addAction(ignore)
        
        alert.addAction(seeMoreInfo)
        
        present(alert,animated: true,completion: nil)
    
    }
    
    func giveResult(colorList: [UIColor])->[Int]{
        var results = [Int]()
        for color in colorList{
            results.append(Int((0.2126 * color.rgba.red + 0.7152 * color.rgba.blue + 0.0722 * color.rgba.green)*255))
        }
        print(results)
        return results
    }
    
    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        for cases in caseviews{
            let target = cases
            target.center = CGPoint(x: target.center.x + translation.x, y: target.center.y + translation.y)
        }
        [REF,LEU,NIT].forEach{
            let target = ($0)
            target.center = CGPoint(x: target.center.x + translation.x, y: target.center.y + translation.y)
        }
        gesture.setTranslation(CGPoint .zero, in: self.view)
    }
    
    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        backButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        let homePageView = UTIViewController()
        
        show(homePageView, sender: self)
        
    }
    

}



extension UIImage {
    
    func cropAlpha() -> UIImage {
        
        let cgImage = self.cgImage!;
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel:Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return self
        }
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        
        for x in 1 ..< width {
            for y in 1 ..< height {
                
                let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
                let a = CGFloat(ptr[i + 3]) / 255.0
                
                if(a>0) {
                    if (x < minX) { minX = x };
                    if (x > maxX) { maxX = x };
                    if (y < minY) { minY = y};
                    if (y > maxY) { maxY = y};
                }
            }
        }
        
        let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
        let imageScale:CGFloat = self.scale
        let croppedImage =  self.cgImage!.cropping(to: rect)!
        let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
        
        return ret;
    }
    
    
    
}
