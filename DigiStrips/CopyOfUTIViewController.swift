//
//  ViewController.swift
//  TestCamera
//
//  Created by Kaixuan Zhou on 5/21/18.
//  Copyright © 2018 Kaixuan Zhou. All rights reserved.
//
import UIKit
import Vision
import VideoToolbox
import AVFoundation


class CopyOfUTIViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    
    
    var image : UIImage = UIImage()
    var cameraButton : UIButton = UIButton()
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureImage: UIImage?
    
    
    func styleCaptureButton() {
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.masksToBounds = false
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
    }
    
    @objc func pictureTakeButtonPressed(_ sender: UIButton){
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        view.addSubview(cameraButton)
        cameraButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 25, y: UIScreen.main.bounds.height - 100, width: 60, height: 60)
        
        
        cameraButton.addTarget(self, action: #selector(pictureTakeButtonPressed), for: .touchUpInside)
        styleCaptureButton()
        
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
        //        instructionView.layer.borderColor = UIColor.black.cgColor
        //        instructionView.layer.borderWidth = 4
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentDevice = backCamera
    }
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
            
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = view.frame
        
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
    
    
}

