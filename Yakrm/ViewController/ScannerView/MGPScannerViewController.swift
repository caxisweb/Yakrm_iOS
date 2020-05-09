//
//  MGPScannerViewController.swift
//  ScannerDemo
//
//  Created by Mahendra on 23/05/18.
//  Copyright © 2018 Mahendra. All rights reserved.
//

import AVFoundation
import UIKit

/// ErrorCode enum describe the errors that may occure
///
/// - cameraNotFound: when camera is not available in device
/// - cameraPermissionNotGranted: when camera permission is not granted to app
/// - cameraPermissionRestricted: when camera permission is restricted
/// - camerePermissionNotDetermined: when camera permission can't be determined
/// - barCodeNotScanned: when barcode is not get scanned
/// - unknown: when an unknow error occured (which is not covered)
public enum ErrorCode {
    case cameraNotFound
    case cameraPermissionNotGranted
    case cameraPermissionRestricted
    case camerePermissionNotDetermined
    case barCodeNotScanned
    case unknown
}

/// ScanningError struct to combine error with code
public struct ScanningError: Error {
    public let code: ErrorCode
    public let msg: String
}

/// Scanned item
///
/// - link: link detected
/// - text: plain text detected
/// - number: number detected
/// - email: email id detected
/// - other: other than above mentioned items
public enum ScannedItem {
    case link
    case text
    case number
    case email
    case other
}

/// Set the direction of the close bar button direction
///
/// - right: to show bar button on left side
/// - left: to show bar button on right side
public enum CloseBarButtonDirection {
    case right
    case left
}

/// This delegate method repoponds to the event when any qr code or barcode detected and also respond to an error event.
public protocol MGPScannerViewControllerDelegate {

    func cameraPermission(error: ScanningError)
    func barcodeDidScannedWith(text: String, OfType: ScannedItem, error: ScanningError?)
}

/// This class detects qr code, barcode, etc.
public class MGPScannerViewController: UIViewController {

    // MARK: - Properties

    /// This color will be set on camera overlay
    public var overlayColor: UIColor = UIColor.red

    /// This width be set on camera overlay
    public var borderWidth: Float = 5

    /// to close view controller you can set custom bar button
    public var closeBarButton: UIBarButtonItem?

    /// customize the place of the bar button left/right
    public var closeBarButtonDirection: CloseBarButtonDirection = .left

    /// delegate to respons to the caller
    public var delegate: MGPScannerViewControllerDelegate?

    fileprivate var captureSession: AVCaptureSession = AVCaptureSession()
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    //-----------------------------------------------------

    // MARK: - Memory Management Method

    //-----------------------------------------------------

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    //-----------------------------------------------------

    // MARK: - Class Method

    //-----------------------------------------------------

    public class func viewControllerFrom(storyboard: String, withIdentifier identifier: String) -> MGPScannerViewController? {

        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as? MGPScannerViewController
    }

    //-----------------------------------------------------

    // MARK: - View Life Cycle Methods

    //-----------------------------------------------------

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()

    }

    //-----------------------------------------------------

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    //-----------------------------------------------------

}

//-----------------------------------------------------

// MARK: - AVCaptureMetadataOutputObjectsDelegate

//-----------------------------------------------------

extension MGPScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {
            return
        }

        self.captureSession.stopRunning()

        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

        if let metaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let strVal = metaObject.stringValue {
                print("val : \(strVal)")
            } else {
               print("BarcodeDidNotScanned")
            }

        } else {
            print("BarcodeDidNotScanned")
        }
    }
}

//-----------------------------------------------------

// MARK: - Custom Methods

//-----------------------------------------------------

extension MGPScannerViewController {

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

            print("CameraPermissionIsNotGranted")

        case .restricted:

            print("CameraPermissionIsRestricted")

        case .notDetermined:

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
            print("Camera Not found.")
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
    }

}
