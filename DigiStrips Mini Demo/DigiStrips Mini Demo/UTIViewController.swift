//
//  ViewController.swift
//  TestCamera
//
//  Created by 周凯旋 on 5/21/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//

import UIKit
import Vision
import VideoToolbox
import AVFoundation

class UTIViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var testCounter = 0
    
    var image : UIImage = UIImage()
    
    var resultView = UIView(frame: .zero)
    var exaView = UIImageView(frame: .zero)
    var backButton = UIButton(frame: .zero)
    var infoView = UIButton(frame: .zero)
    var label = UILabel(frame: .zero)
    var dragBoxLabel = UILabel(frame: .zero)
    var seeResultLabel = UILabel(frame: .zero)
    var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    var pixelBuffer : CVPixelBuffer!
    var isTap = false
    var color : colors?
    let bankOfColors = colorBank()
    var cameraImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    //    var photoOutput : AVCapturePhotoOutput?
    
    var theNewlyTestedImage : UIImage?
    
    var caseview: UIImageView = UIImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTap = true
        
        // here is where we start up the camera
        let captureSession = AVCaptureSession()
        //        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        captureSession.addInput(input!)
        
        //        photoOutput = AVCapturePhotoOutput()
        //        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        //
        //        captureSession.addOutput(photoOutput!)
        
        
        captureSession.startRunning()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoQueue"))
        captureSession.addOutput(dataOutput)
        
        //add the layer so that we can see the layer
        view.layer.addSublayer(previewLayer)
        
        //add subviews + autolayout
        [dragBoxLabel,infoView,resultView,label,seeResultLabel,backButton,caseview,exaView].forEach{
            view.addSubview($0)
            ($0).translatesAutoresizingMaskIntoConstraints = false
        }
        
        //initialize the info view, a white rectangle area for the resultView and rgb hexString
        infoView.backgroundColor = UIColor.white
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.layer.cornerRadius = 5.0
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize.zero
        infoView.layer.shadowRadius = 10
        infoView.addTarget(self, action: #selector(self.seeInfo(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.topAnchor,constant: 110),
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80),
            infoView.heightAnchor.constraint(equalToConstant: 70)])
        
        //initialize the result. the RGB color square-area
        resultView.layer.borderColor=UIColor.black.cgColor
        resultView.layer.borderWidth=0.3
        resultView.layer.cornerRadius = 3.0
        resultView.backgroundColor=UIColor.white
        
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.topAnchor,constant: 120),
            resultView.leftAnchor.constraint(equalTo: infoView.leftAnchor,constant: 10),
            resultView.widthAnchor.constraint(equalToConstant: 50),
            resultView.heightAnchor.constraint(equalToConstant: 50)])
        
        
        dragBoxLabel.text = "Place the square box inside the tested strip. Touch the screen to calculate the test result."
        dragBoxLabel.numberOfLines = 2
        dragBoxLabel.textColor = UIColor.white
        
        NSLayoutConstraint.activate([
            dragBoxLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 280),
            dragBoxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragBoxLabel.widthAnchor.constraint(equalToConstant: 350),
            dragBoxLabel.heightAnchor.constraint(equalToConstant: 300)])
        
        label.text = "RGB (r,g,b)"
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 115),
            label.widthAnchor.constraint(equalToConstant: 250),
            label.heightAnchor.constraint(equalToConstant: 40)])
        
        seeResultLabel.text = "Tap here for results"
        
        NSLayoutConstraint.activate([
            seeResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            seeResultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 115),
            seeResultLabel.widthAnchor.constraint(equalToConstant: 250),
            seeResultLabel.heightAnchor.constraint(equalToConstant: 30)])
        
        
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
        
        NSLayoutConstraint.activate([
            exaView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exaView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            exaView.widthAnchor.constraint(equalToConstant: 50),
            exaView.heightAnchor.constraint(equalToConstant: 50)])
        exaView.isHidden = true
        
        
        
        //设置裁剪框和裁剪区域
        NSLayoutConstraint.activate([
            caseview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            caseview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            caseview.widthAnchor.constraint(equalToConstant: 30),
            caseview.heightAnchor.constraint(equalToConstant: 30)])
        
        exaView.contentMode = .scaleAspectFill
        self.caseview.contentMode = .scaleAspectFit
        self.caseview.image = UIImage.init(named: "image")
        self.caseview.layer.borderWidth = 2
        self.caseview.layer.borderColor = UIColor.white.cgColor
        caseview.layer.shadowColor = UIColor.black.cgColor
        caseview.layer.shadowOpacity = 0.5
        caseview.layer.shadowOffset = CGSize.zero
        caseview.layer.shadowRadius = 3
        caseview.layer.cornerRadius = 4.0
        
        self.exaView.layer.borderWidth = 4
        self.exaView.layer.borderColor = UIColor.white.cgColor
        exaView.layer.shadowColor = UIColor.black.cgColor
        exaView.layer.shadowOpacity = 0.5
        exaView.layer.shadowOffset = CGSize.zero
        exaView.layer.shadowRadius = 3
        exaView.layer.cornerRadius = 4.0
        
        view.isUserInteractionEnabled = true
        
    }
    
    
    //    @objc func wasTapped(_ gesture: UITapGestureRecognizer){
    //        isTap = true
    //        exaView.isHidden = false
    //        dragBoxLabel.isHidden = true
    //        exaView.image = cropImage(image, withRect: caseview.frame)
    //        let angle =  CGFloat(.pi/(2.0))
    //        let tr = CGAffineTransform.identity.rotated(by: angle)
    //
    //        exaView.transform = tr
    //        updateUI(theConvertedImage: exaView.image!)
    //
    //        dragBoxLabel.isHidden = true
    //        if seeResultLabel.isHidden == true{
    //            changeAnimation(aView: seeResultLabel)
    //        }
    //        exaView.isHidden = true
    //        isTap = false
    //    }
    
    
    //    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
    //
    //        let translation = gesture.translation(in: self.view)
    //        let target = gesture.view!
    //        target.center = CGPoint(x: target.center.x + translation.x, y: target.center.y + translation.y)
    //        gesture.setTranslation(CGPoint .zero, in: self.view)
    //
    //
    //        caseview.image = cropImage(image, withRect: caseview.frame)
    //
    //        dragBoxLabel.isHidden = true
    //        if seeResultLabel.isHidden == true{
    //            changeAnimation(aView: seeResultLabel)
    //        }
    //
    //        let angle =  CGFloat(.pi/(2.0))
    //        let tr = CGAffineTransform.identity.rotated(by: angle)
    //        caseview.transform = tr
    //
    //        updateUI(theConvertedImage: caseview.image!)
    //    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isTap = true
        exaView.isHidden = false
        dragBoxLabel.isHidden = true
        let aUiImage = cropImage(image, withRect: caseview.frame)
        
        exaView.image = aUiImage
//        let angle =  CGFloat(.pi/(2.0))
//        let tr = CGAffineTransform.identity.rotated(by: angle)
//        //
//        exaView.transform = tr
        updateUI(theConvertedImage: aUiImage!)
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let aUiImage = cropImage(image, withRect: caseview.frame)
        exaView.image = aUiImage
        
//        let angle =  CGFloat(.pi/(2.0))
//        let tr = CGAffineTransform.identity.rotated(by: angle)
//        exaView.transform = tr
        updateUI(theConvertedImage: aUiImage!)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //        caseview.image = image.croppedInRect(rect: caseview.frame)
        let aUiImage = cropImage(image, withRect: caseview.frame)
        exaView.image = aUiImage
        //        let trimmed = aUiImage?.trim()
        dragBoxLabel.isHidden = true
        if seeResultLabel.isHidden == true{
            changeAnimation(aView: seeResultLabel)
        }
        exaView.isHidden = true
        
        
        updateUI(theConvertedImage: aUiImage!)
        isTap = false
        
    }
    
    
    
    func cropImage(_ aimage: UIImage, withRect rect: CGRect) -> UIImage? {
        
        cameraImageView.image = image
        let croppedImage = ZImageCropper.cropImage(ofImageView: self.cameraImageView, withinPoints: [
            CGPoint(x: rect.origin.x, y: rect.origin.y),   //Start point
            CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y),
            CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y+rect.size.height),
            CGPoint(x: rect.origin.x, y: rect.origin.y+rect.size.height)  //End point
            ])
        let result = croppedImage?.cropAlpha()
        return result
    }
    
    
    
    
    
    //get the sampleBuffer into an image buffer
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if isTap{
            pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            image = UIImage(pixelBuffer: pixelBuffer)!
        }
        
    }
    
    
    //Prepare for the animation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        infoView.isHidden=true
        resultView.isHidden=true
        label.isHidden=true
        backButton.isHidden=true
        dragBoxLabel.isHidden=true
        seeResultLabel.isHidden=true
        view.backgroundColor=UIColor.white
    }
    
    
    //Add animation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        [dragBoxLabel,infoView,resultView,backButton,label].forEach{ changeAnimation(aView: $0) }
        image = UIImage(pixelBuffer: pixelBuffer)!
        updateUI(theConvertedImage: image)
        isTap = false
    }
    
    
    func changeAnimation(aView : UIView){
        aView.alpha = 0
        aView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            aView.alpha = 1
        }
    }
    
    
    //For the back button
    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        backButton.setTitleColor(UIColor.darkGray, for: .normal)
        isTap = false
        let homePageView = ViewController()
        //        navigationController?.pushViewController(homePageView, animated: true)
        show(homePageView, sender: self)
        //        present(ViewController(),animated: true,completion: nil)
    }
    
    
    //    //Tap to focus
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        let touchPoint = touches.first! as UITouch
    //        let screenSize = previewLayer.bounds.size
    //        let focusPoint = CGPoint(x: touchPoint.location(in: view).y / screenSize.height, y: 1.0 - touchPoint.location(in: view).x / screenSize.width)
    //
    //        if let device = AVCaptureDevice.default(for: .video) {
    //            do {
    //                try device.lockForConfiguration()
    //                if device.isFocusPointOfInterestSupported {
    //                    device.focusPointOfInterest = focusPoint
    //                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
    //                }
    //                if device.isExposurePointOfInterestSupported {
    //                    device.exposurePointOfInterest = focusPoint
    //                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
    //                }
    //                device.unlockForConfiguration()
    //
    //            } catch {
    //                // Handle errors here
    //            }
    //        }
    //    }
    
    
    //For the infoView button
    @objc func seeInfo(_ sender: UIButton){ //<- needs `@objc`
        if(seeResultLabel.isHidden==false){
            let result = (bankOfColors.selectSimilar(aColor: color!)=="Yes")
            
            print("\(bankOfColors.selectSimilar(aColor: color!)) \(bankOfColors.diff(aColor: color!))")
            
            
            if(result){
                let alert = UIAlertController(title: "UTI Detected", message: "Our result shows that you have UTI", preferredStyle: .alert)
                let getPrescribed = UIAlertAction(title: "Get prescribed", style: .default) { (UIAlertAction) in
                    self.present(PrescribedViewController(),animated: true,completion: nil)
                }
                let retestAction = UIAlertAction(title: "Retest", style: .default) { (UIAlertAction) in
                    print("Retest")
                }
                alert.addAction(retestAction)
                alert.addAction(getPrescribed)
                
                present(alert,animated: true,completion: nil)
            }else{
                let alert = UIAlertController(title: "No UTI Detected", message: "Our result shows that you don't have UTI", preferredStyle: .alert)
                let seeMoreInfo = UIAlertAction(title: "More info", style: .default) { (UIAlertAction) in
//                    self.present(MoreInfoViewController(),animated: true,completion: nil)
                }
                let retestAction = UIAlertAction(title: "Retest", style: .default) { (UIAlertAction) in
                    print("Retest")
                }
                alert.addAction(retestAction)
                alert.addAction(seeMoreInfo)
                present(alert,animated: true,completion: nil)
            }
        }
    }
    
    
    
    func updateUI(theConvertedImage : UIImage){
        let color = theConvertedImage.pickColor()
        resultView.backgroundColor = color
        let RGBA = color.rgba
        label.text="RGB: (\(Int(RGBA.red*255)),\(Int(RGBA.green*255)),\(Int(RGBA.blue*255)))"
        self.color = colors(r: Double(RGBA.red*255), g: Double(RGBA.green*255), b: Double(RGBA.blue*255))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

extension UIImage{
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &cgImage)
        if let cgImage = cgImage {
            self.init(cgImage: cgImage,scale: UIScreen.main.scale, orientation: .right)
        } else {
            return nil
        }
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
