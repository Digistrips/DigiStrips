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
    var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    var isTap = false
    var pixelBuffer : CVPixelBuffer!
    var image : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // here is where we start up the camera
        let captureSession = AVCaptureSession()
        //        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        captureSession.addInput(input!)
        captureSession.startRunning()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoQueue"))
        captureSession.addOutput(dataOutput)
    
        
        
        //add the layer so that we can see the layer
        view.layer.addSublayer(previewLayer)
        
        let cameraButton = UIButton(frame:CGRect.init(x: UIScreen.main.bounds.width/2 - 25, y: UIScreen.main.bounds.height - 100, width: 60, height: 60))
        view.addSubview(cameraButton)

        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.masksToBounds = false
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
        
        cameraButton.addTarget(self, action: #selector(pictureTakeButtonPressed), for: .touchUpInside)
        
        let instructionView = UIImageView(frame: .zero)
        view.addSubview(instructionView)
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 130),
            instructionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 130)])
        instructionView.image = UIImage(named: "P-Cup.png")
        instructionView.contentMode = .scaleAspectFit
        
    }
    
    
    
    
    
    @objc func pictureTakeButtonPressed(_ sender: UIButton){
        print("Implement")
        image = UIImage(pixelBuffer: pixelBuffer)!
        let nextView = PreviewViewController(image: image)
        show(nextView, sender: self)
    }
    
    //get the sampleBuffer into an image buffer
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
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
