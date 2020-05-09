//
//  BarcodeView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import Toaster

class BarcodeView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewDetails: UIView!

    /// This color will be set on camera overlay
    public var overlayColor: UIColor = UIColor.red
    /// This width be set on camera overlay
    public var borderWidth: Float = 5

    fileprivate var captureSession: AVCaptureSession = AVCaptureSession()
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    //-----------------------------------------------------
    var app = AppDelegate()

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.viewDetails.frame = CGRect(x: self.viewDetails.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.viewDetails.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        if self.app.isEnglish {
            self.lblTitle.textAlignment = .left
        } else {
            self.lblTitle.textAlignment = .right
        }
        self.setupView()
    }

    fileprivate func setupView() {
        AVCaptureDevice.requestAccess(for: .video) { (isGranted) in

            DispatchQueue.main.async {

                    if !isGranted {
                        print("CameraPermissionIsNotGranted")
                        return
                    } else {
                        self.setUpViewAfterCameraAccess()
                    }
            }
        }
    }

    //-----------------------------------------------------

    fileprivate func setUpViewAfterCameraAccess() {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .denied:

            self.SettingAlertAction(strTitle: "Camera Permission Is Not Granted")
            print("CameraPermissionIsNotGranted")

        case .restricted:

            self.SettingAlertAction(strTitle: "Camera Permission Is Restricted")
            print("CameraPermissionIsRestricted")

        case .notDetermined:

            self.SettingAlertAction(strTitle: "Camera Permission Is Not Determined")
            print("CameraPermissionIsNotDetermined")

        default:
            debugPrint("Camera access is given.")
        }

        var deviceType: AVCaptureDevice.DeviceType
        if #available(iOS 10.2, *) {
            deviceType = .builtInWideAngleCamera
        } else {
            deviceType = .builtInDuoCamera
        }

        self.view.layer.masksToBounds = true

        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [deviceType], mediaType: .video, position: .back)

        guard let capureDevice = discoverySession.devices.first else {
//            self.AlertAction()
            print("Camera Not found.")
            self.SettingAlertAction(strTitle: "Camera Not found.")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: capureDevice)
            captureSession.addInput(input)

            let captureMetaOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetaOutput)

            captureMetaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaOutput.metadataObjectTypes = [.qr, .code128, .code39, .aztec, .code39Mod43, .ean13, .ean8]

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = self.view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            captureSession.startRunning()

        } catch {
            debugPrint(error.localizedDescription)
            return
        }

        self.setOverlayLayer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }
    //-----------------------------------------------------

    fileprivate func setOverlayLayer() {
        let overlayPath = UIBezierPath(rect: view.bounds)

        let overlayWidth = self.view.frame.size.width * 80 * 0.01
        let x: CGFloat = view.bounds.width/2 - overlayWidth/2
        let y: CGFloat = view.bounds.height/2 - overlayWidth/2 + 44

        let transparentPath = UIBezierPath(rect: CGRect(x: x, y: y, width: overlayWidth, height: overlayWidth))
        overlayPath.append(transparentPath)
        overlayPath.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
//        fillLayer.frame = CGRect(x:0, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width:ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor =  UIColor.black.withAlphaComponent(0.5).cgColor
        self.view.layer.addSublayer(fillLayer)

        let lineHeight = overlayWidth/4

        //for top left corner
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: x, y: y))
        path1.addLine(to: CGPoint(x: x+lineHeight, y: y))

        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: x, y: y))
        path2.addLine(to: CGPoint(x: x, y: y+lineHeight))
        path1.append(path2)

        //for top right corner
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: x+overlayWidth, y: y))
        path3.addLine(to: CGPoint(x: x+overlayWidth, y: y+lineHeight))
        path1.append(path3)

        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: x+overlayWidth, y: y))
        path4.addLine(to: CGPoint(x: x+overlayWidth-lineHeight, y: y))
        path1.append(path4)

        //for bottom right
        let path5 = UIBezierPath()
        path5.move(to: CGPoint(x: x+overlayWidth, y: y+overlayWidth))
        path5.addLine(to: CGPoint(x: x+overlayWidth, y: y+overlayWidth-lineHeight))
        path1.append(path5)

        let path6 = UIBezierPath()
        path6.move(to: CGPoint(x: x+overlayWidth, y: y+overlayWidth))
        path6.addLine(to: CGPoint(x: x+overlayWidth-lineHeight, y: y+overlayWidth))
        path1.append(path6)

        //for bottom left
        let path7 = UIBezierPath()
        path7.move(to: CGPoint(x: x, y: y+overlayWidth))
        path7.addLine(to: CGPoint(x: x+lineHeight, y: y+overlayWidth))
        path1.append(path7)

        let path8 = UIBezierPath()
        path8.move(to: CGPoint(x: x, y: y+overlayWidth))
        path8.addLine(to: CGPoint(x: x, y: y+overlayWidth-lineHeight))
        path1.append(path8)

        let layer = CAShapeLayer()
        layer.path = path1.cgPath
        layer.lineWidth = CGFloat(borderWidth)
        layer.lineCap = CAShapeLayerLineCap.square
        layer.lineJoin = CAShapeLayerLineJoin.bevel
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = overlayColor.cgColor
        self.view.layer.addSublayer(layer)

        self.view.addSubview(self.viewNavigation)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnNext(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCouponView") as! AddCouponView
        self.navigationController?.pushViewController(VC, animated: true)
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {
            return
        }

//        self.captureSession.stopRunning()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

        if let metaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let strVal = metaObject.stringValue {
                print("val : \(strVal)")
//                searchAPI(codeNumber: strVal)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddCouponView") as! AddCouponView
                VC.strNumber = strVal
                self.navigationController?.pushViewController(VC, animated: true)
            } else {
                print("BarcodeDidNotScanned")
            }

        } else {
            print("BarcodeDidNotScanned")
        }
    }

    func searchAPI(codeNumber: String) {
        // The URL we will use to get out album data from Discogs
        let discogsURL = "\(DISCOGS_AUTH_URL)\(codeNumber)&?barcode&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"

        AppWebservice.shared.request(discogsURL, method: .get, parameters: nil, headers: nil, loader: true) { (statusCode, response, error) in
            if statusCode == 200 {
                let json = response!
                print(json)
            }else {
                Toast(text: error?.localizedDescription).show()
            }
        }
    }

    func AlertAction() {
        let alertController = UIAlertController(title: "Yakrm", message: "Camera Not found.", preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction!) in
            print("you have pressed OK button")

        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func SettingAlertAction(strTitle: String) {
        let alertController = UIAlertController(title: "Yakrm", message: strTitle, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction!) in
            print("you have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Setting", style: .default) { (_: UIAlertAction!) in
            print("you have pressed OK button")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

class Barcode {
    class func fromString(string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let outputCIImage = filter.outputImage {
                return UIImage(ciImage: outputCIImage)
            }
        }
        return nil
    }
}
