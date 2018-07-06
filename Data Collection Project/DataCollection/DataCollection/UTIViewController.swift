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
    
    var infoView = UIButton(frame: .zero)
    var label = UILabel(frame: .zero)
    var dragBoxLabel = UILabel(frame: .zero)
    
    var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    var pixelBuffer : CVPixelBuffer!
    var isTap = true
    var cameraImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    //    var photoOutput : AVCapturePhotoOutput?
    
    var theNewlyTestedImage : UIImage?
    
    var caseview: UIImageView = UIImageView(frame: .zero)
    
    var torchButton : UIButton = UIButton(frame: .zero)
    
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
        [dragBoxLabel,infoView,resultView,label,caseview,exaView,torchButton].forEach{
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
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 115),
            label.widthAnchor.constraint(equalToConstant: 250),
            label.heightAnchor.constraint(equalToConstant: 40)])
        
        
        
        
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
        
        NSLayoutConstraint.activate([
            torchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            torchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:-100),
            torchButton.widthAnchor.constraint(equalToConstant: 200),
            torchButton.heightAnchor.constraint(equalToConstant: 30)])
        torchButton.layer.backgroundColor = UIColor.white.cgColor
        torchButton.setTitle("turn on/off light", for: .normal)
        torchButton.setTitleColor(UIColor.black, for: .normal)
        torchButton.addTarget(self, action: #selector(torchOnOff), for: .touchUpInside)
        
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
        let angle =  CGFloat(.pi/(2.0))
        let tr = CGAffineTransform.identity.rotated(by: angle)
        //
        exaView.transform = tr
        updateUI(theConvertedImage: aUiImage!)
        
    }
    
    
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
            let aUiImage = cropImage(image, withRect: caseview.frame)
            exaView.image = aUiImage
    
            let angle =  CGFloat(.pi/(2.0))
            let tr = CGAffineTransform.identity.rotated(by: angle)
            exaView.transform = tr
            updateUI(theConvertedImage: aUiImage!)
        }
    
    
    
    @objc func torchOnOff(_ sender: UIButton){
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if(device?.isTorchActive)!{
            toggleTorch(on: false)
        }else{
            toggleTorch(on: true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //        caseview.image = image.croppedInRect(rect: caseview.frame)
        let aUiImage = cropImage(image, withRect: caseview.frame)
        exaView.image = aUiImage
        //        let trimmed = aUiImage?.trim()
        dragBoxLabel.isHidden = true
        exaView.isHidden = true
        
        
        updateUI(theConvertedImage: aUiImage!)
        isTap = false
        
    }
    
    
    
    func cropImage(_ aimage: UIImage, withRect rect: CGRect) -> UIImage? {
        //获取屏幕的缩放因子
        let scale:CGFloat = UIScreen.main.scale
        
        let x = (rect.origin.y - 1.5*rect.size.width - 3) * scale
        let y = (rect.origin.x - rect.size.width + 2) * scale
        let width = rect.size.width * scale
        let height = rect.size.height * scale
        
        //        print(UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        //        print(aimage.size.width, aimage.size.height)
        //        print(x,y,width,height)
        
        //生成根据缩放因子转化后的裁剪区域(目的:由像素转化为点)
        let scaleRect = CGRect.init(x: x, y: y, width: width, height: height)
        
        
        if let cgImage = aimage.cgImage,let croppedCgImage = cgImage.cropping(to: scaleRect) {
            return UIImage.init(cgImage: croppedCgImage, scale: scale, orientation: .up)
            //            return UIImage.init(cgImage: croppedCgImage)
        } else if let ciImage = aimage.ciImage {
            let croppedCiImage = ciImage.cropped(to: scaleRect)
            return UIImage.init(ciImage: croppedCiImage, scale: scale, orientation: .up)
            //            return UIImage.init(cgImage: croppedCiImage as! CGImage)
        }else{
            print("裁剪区域超过原图啦,在裁剪区域超出原图的大小的情况下会出现")
        }
        return nil
        //        cameraImageView.image = image
        //        let croppedImage = ZImageCropper.cropImage(ofImageView: self.cameraImageView, withinPoints: [
        //            CGPoint(x: rect.origin.x, y: rect.origin.y),   //Start point
        //            CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y),
        //            CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y+rect.size.height),
        //            CGPoint(x: rect.origin.x, y: rect.origin.y+rect.size.height)  //End point
        //            ])
        //        print(rect.origin.x,rect.origin.y," \(testCounter)")
        //        testCounter+=1
        //        return croppedImage
        
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
        
        dragBoxLabel.isHidden=true
        
        view.backgroundColor=UIColor.white
    }
    
    
    //Add animation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        [dragBoxLabel,infoView,resultView,label].forEach{ changeAnimation(aView: $0) }
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
    
    
    
    
    
    
    func updateUI(theConvertedImage : UIImage){
        let color = theConvertedImage.pickColor()
        resultView.backgroundColor = color
        let RGBA = color.rgba
        label.text="RGB: (\(Int(RGBA.red*255)),\(Int(RGBA.green*255)),\(Int(RGBA.blue*255)))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
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
