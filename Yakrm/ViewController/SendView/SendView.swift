//
//  SendView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 15/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster
import MobileCoreServices
import AVKit
import AVFoundation
import Photos
import DatePickerDialog

@available(iOS 11.0, *)
class SendView: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIVideoEditorControllerDelegate {
    // MARK: - Outlet
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!

    @IBOutlet var txtNumber: UITextField!
    @IBOutlet var viewSearch: UIView!

    @IBOutlet var lblFriendInfo: UILabel!
    @IBOutlet var lblFriendsName: UILabel!
    @IBOutlet var lblEmail: UILabel!

    @IBOutlet var txtSendingData: UITextField!
    @IBOutlet var txtMessage: UITextView!

    @IBOutlet var imgVideo: UIImageView!
    @IBOutlet var btnVideo: UIButton!

    @IBOutlet var btnComplete: UIButton!

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!
    var arabMessage: String!

    var app = AppDelegate()

    var strMobile = String()
    var strDesc = String()
    var isCheck = Bool()

    var strVoucherID = String()
    var strVoucherPaymentID = String()
    var strImage = String()
    var strName = String()
    var strPrice = String()
    var strScanVoucherType = String()

    var picker = UIImagePickerController()

    var videoURL: URL!

    var isUpload = Bool()
    let dateFormatter = DateFormatter()

    var strFullDate = String()

    var strMESSAGE = "Hello Friend. I Am Sending You This Voucher To Express My Love And Gratitude For You As A Friend I Hope That You Will Be Happy During Every Single Moment Of Your Life"

    var strAddPhoto = "Add Video!"
    var strTakePhoto = "Record video from camera"
    var strChoosefromGallery = "Select video from gallery"
    var strCancel = "Cancel"

    // MARK: -
    override func viewDidLoad() {

        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.picker.delegate = self

        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)
        self.txtNumber.maxLength = 12

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if self.app.isEnglish {
            self.lblName.textAlignment = .left
            self.lblPrice.textAlignment = .left

            self.lblFriendInfo.textAlignment = .left
            self.lblFriendsName.textAlignment = .left
            self.lblEmail.textAlignment = .left

            self.txtNumber.textAlignment = .left
            self.txtSendingData.textAlignment = .left
            self.txtMessage.textAlignment = .left
            self.lblTitle.textAlignment = .left
        } else {
            self.lblName.textAlignment = .right
            self.lblPrice.textAlignment = .right

            self.lblFriendInfo.textAlignment = .right
            self.lblFriendsName.textAlignment = .right
            self.lblEmail.textAlignment = .right

            self.txtNumber.textAlignment = .right
            self.txtSendingData.textAlignment = .right
            self.txtMessage.textAlignment = .right
            self.lblTitle.textAlignment = .right

 //           self.lblTitle.text = "إرسال لصديق"
//            self.txtNumber.placeholder = "أدخل رقم جوال صديقك"

            self.imgVideo.frame = CGRect(x: self.btnVideo.frame.origin.x + self.btnVideo.frame.size.width, y: self.imgVideo.frame.origin.y, width: self.imgVideo.frame.size.width, height: self.imgVideo.frame.size.height)
            self.btnVideo.contentHorizontalAlignment = .right
        }
        self.lblTitle.text = "Send to a friend".localized
        self.txtNumber.placeholder = "Friend mobile number".localized

        if DeviceType.IS_IPHONE_5 {
            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-2)
            self.lblPrice.font = self.lblPrice.font.withSize(self.lblPrice.font.pointSize-2)//(15)

            self.txtNumber.font = self.txtNumber.font!.withSize(self.txtNumber.font!.pointSize-2)//(15)

            self.lblFriendInfo.font = self.lblFriendInfo.font.withSize(self.lblFriendInfo.font.pointSize-2)//(15)
            self.lblFriendsName.font = self.lblFriendsName.font.withSize(self.lblFriendsName.font.pointSize-2)//(13)
            self.lblEmail.font = self.lblEmail.font.withSize(self.lblEmail.font.pointSize-2)//(13)

            self.txtSendingData.font = self.txtSendingData.font!.withSize(self.txtSendingData.font!.pointSize-2)//(15)
            self.txtMessage.font = self.txtMessage.font!.withSize(self.txtMessage.font!.pointSize-2)//(15)

            self.btnVideo.titleLabel?.font = self.btnVideo.titleLabel?.font.withSize(self.btnVideo.titleLabel!.font.pointSize-2)//(13)
            self.btnComplete.titleLabel?.font = self.btnComplete.titleLabel?.font.withSize((self.btnComplete.titleLabel?.font.pointSize)!-1)//(15)
        }

        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)voucher_images/\(self.strImage)"), placeholderImage: nil)

        self.lblName.text = self.strName
        self.lblPrice.text = "\(self.strPrice) " + "SR".localized
        self.lblFriendsName.text = "Name".localized + " : "//Mahmoud Abdel Mattal"
        self.lblEmail.text = "Email Address".localized + " : "//email@domain.dlt"

        self.txtMessage.text = strMESSAGE.localized

        self.btnComplete.layer.cornerRadius = 5

        self.setTextfildDesign(txt: self.txtNumber, vv: self.viewSearch, addView: true)
        self.setTextfildDesign(txt: self.txtSendingData, vv: self.viewSearch, addView: false)

        self.txtMessage.layer.borderWidth = 1
        self.txtMessage.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        self.txtMessage.delegate = self
        self.txtMessage.backgroundColor = UIColor.clear

        self.setScrollViewHeight()

        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        self.dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale

        strFullDate = dateFormatter.string(from: Date())
        self.txtSendingData.text = strFullDate
    }

    func setTextfildDesign(txt: UITextField, vv: UIView, addView: Bool) {
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        txt.delegate = self
        let VV = UIView()
        VV.backgroundColor = UIColor.clear
        VV.frame = CGRect(x: 0, y: 0, width: 10, height: txt.frame.size.height)
        if self.app.isEnglish {
            txt.textAlignment = .left
            if self.app.isLangEnglish {
                if addView {
                    txt.setRightPaddingPoints(vv)
                }
                txt.setLeftPaddingPoints(VV)
            } else {
                if addView {
                    txt.setLeftPaddingPoints(vv)
                }
                txt.setRightPaddingPoints(VV)
            }
        } else {
            if self.app.isLangEnglish {
                if addView {
                    txt.setLeftPaddingPoints(vv)
                }
                txt.setRightPaddingPoints(VV)
            } else {
                if addView {
                    txt.setRightPaddingPoints(vv)
                }
                txt.setLeftPaddingPoints(VV)
            }
            txt.textAlignment = .right
        }
//        txt.placeHolderColor = UIColor.black
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

//    func textViewDidChange(_ textView: UITextView)
//    {
//        if self.txtMessage.text.isEmpty
//        {
//            self.txtMessage.text = "Hello Friend. I Am Sending You This Voucher To Express My Love And Gratitude For You As A Friend I Hope That You Will Be Happy During Every Single Moment Of Your Life".localized
//        }
//        else
//        {
//
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.txtMessage.text == strMESSAGE.localized {
            self.txtMessage.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if self.txtMessage.text.isEmpty {
            self.txtMessage.text = strMESSAGE.localized
        }
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 101 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDateAction(_ sender: UIButton) {
        var datePicker = UIDatePicker()
        var currentDate = Date()
        datePicker.minimumDate = currentDate

        //Only Future Date Allowed
        DatePickerDialog().show("Date Picker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: datePicker.minimumDate, datePickerMode: .date) { (date) in
            if let dt = date {
                self.dateFormatter.dateFormat = "dd-MM-yyyy"
                self.dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale

                self.strFullDate = self.dateFormatter.string(from: dt as Date)
                self.txtSendingData.text = self.strFullDate
            }
        }
    }

    @IBAction func btnSearch(_ sender: UIButton) {
        self.isCheck = false
        self.txtNumber.resignFirstResponder()
        self.txtMessage.resignFirstResponder()
        self.strMobile = self.txtNumber.text!

        if self.strMobile.isEmpty {
            Toast(text: "Please Enter Mobile Number".localized).show()
        } else if self.strMobile.count < 10 {
            Toast(text: "Mobile Number should be minimum of 10 characters".localized).show()
        } else {
            if self.app.isConnectedToInternet() {
                self.FindContactNumberAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage.localized).show()
            }
        }
    }

    // MARK: - Find Contact Number API
    func FindContactNumberAPI() {

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]
        //9429888309
        let parameters: Parameters = ["phone": self.strMobile]
        print(JSON(parameters))
        
        AppWebservice.shared.request("\(self.app.BaseURL)find_contact_no", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            
            if statusCode == 200 {
                        self.json = response!
                        print(self.json)

                        let strStatus: String = self.json["status"].stringValue
                        self.strMessage = self.json["message"].stringValue

                        var strFriendsName = String()
                        var strEmail = String()
                        if strStatus == "1" {
                            strFriendsName = self.json["name"].stringValue
                            strEmail = self.json["email"].stringValue
                            self.isCheck = true
                        } else {
                            if self.app.strLanguage == "ar" {
                                self.app.isEnglish = false
                                Toast(text: "Invalid contact number".localized).show()
                            } else {
                                self.app.isEnglish = true
                                Toast(text: self.strMessage).show()
                            }

                        }
                        self.lblFriendsName.text = "Name".localized + " : \(strFriendsName)"
                        self.lblEmail.text = "Email Address".localized + " : \(strEmail)"
            } else {
                Toast(text: self.app.RequestTimeOut.localized).show()
            }
        }
    }

    @IBAction func btnVideoAction(_ sender: UIButton) {
        self.OpenVidoePickerView()
    }
    func OpenVidoePickerView() {
        let alertController = UIAlertController(title: self.strAddPhoto.localized, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: self.strTakePhoto.localized, style: .default, handler: { (_) -> Void in
            self.openCamera()
        })
        let cancel = UIAlertAction(title: self.strCancel.localized, style: .cancel, handler: { (_) -> Void in
        })
        let  delete = UIAlertAction(title: self.strChoosefromGallery.localized, style: .default) { (_) -> Void in
            self.openGallary()
        }

        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addAction(delete)

        present(alertController, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.picker.sourceType = .camera
            self.picker.mediaTypes = ["public.movie"]
            present(self.picker, animated: true, completion: nil)
        } else {
            self.openGallary()
        }
    }

    func openGallary() {
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = ["public.movie"]
        present(self.picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        picker .dismiss(animated: true) {
            self.showEditor(for: self.videoURL)
        }

//        self.isUpload = true
//        if let videoURL = videoURL
//        {
//            let player = AVPlayer(url: videoURL)
//
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//
//            present(playerViewController, animated: true)
//            {
//                playerViewController.player!.play()
//            }
//        }
    }

    func showEditor(for outputUrl: URL) {
        guard UIVideoEditorController.canEditVideo(atPath: outputUrl.path) else {
            print("Can't edit video at \(outputUrl.path)")
            Toast(text: "Video Atteched successfully".localized).show()

            return
        }
        let vc = UIVideoEditorController()
        vc.videoPath = outputUrl.path
        vc.videoMaximumDuration = 15
        vc.videoQuality = UIImagePickerController.QualityType.typeIFrame960x540
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    static func deleteAsset(at path: String) {
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
            print("Deleted asset file at: \(path)")
        } catch {
            print("Failed to delete assete file at: \(path).")
            print("\(error)")
        }
    }

    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        print("Result saved to path: \(editedVideoPath)")
        Toast(text: "Video Atteched successfully".localized).show()

        videoURL = URL(fileURLWithPath: editedVideoPath)
        self.isUpload = true
        //        if let videoURL = videoURL
        //        {
        //            let player = AVPlayer(url: videoURL)
        //
        //            let playerViewController = AVPlayerViewController()
        //            playerViewController.player = player
        //
        //            present(playerViewController, animated: true)
        //            {
        //                playerViewController.player!.play()
        //            }
        //        }
        editor.dismiss(animated: true) {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
//                SendView.deleteAsset(at: editor.videoPath)
//            })
        }

    }

    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        dismiss(animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            SendView.deleteAsset(at: editor.videoPath)
        })
    }

    func videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error) {
        print("an error occurred: \(error.localizedDescription)")
        dismiss(animated: true)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            SendView.deleteAsset(at: editor.videoPath)
        })
    }

    @IBAction func btnComplete(_ sender: UIButton) {
        self.txtNumber.resignFirstResponder()
        self.txtMessage.resignFirstResponder()
        self.strDesc = self.txtMessage.text!

        if self.isCheck == false {
            Toast(text: "Please verify your friends mobile number".localized).show()
        } else if self.strDesc.isEmpty {
            Toast(text: "Please Enter Description".localized).show()
        } else {
            let alertController = UIAlertController(title: "Are you sure ?".localized, message: nil, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "NO".localized, style: .default) { (_: UIAlertAction!) in
                print("you have pressed the Cancel button")
            }
            alertController.addAction(cancelAction)

            let OKAction = UIAlertAction(title: "YES".localized, style: .default) { (_: UIAlertAction!) in
                print("you have pressed OK button")

                if self.app.isConnectedToInternet() {
                    self.SendVoucherAsGiftAPI()
                } else {
                    Toast(text: self.app.InternetConnectionMessage.localized).show()
                }
            }
            alertController.addAction(OKAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - SendVoucherAsGift API
    @available(iOS 11.0, *)
    func SendVoucherAsGiftAPI() {

        let Header: HTTPHeaders = ["Authorization": self.app.strToken]
        //,"Content-Type":"application/json"

//        Alamofire.upload(multipartFormData: { multipartFormData in
//
//            if self.isUpload {
//                let strFileName: String = self.videoURL.lastPathComponent
//                if let videoData = NSData(contentsOf: self.videoURL) {
//                    multipartFormData.append(videoData as Data, withName: "video_or_image", fileName: strFileName, mimeType: "video/mp4")
//                }
//            }
//
//            multipartFormData.append(self.strVoucherID.data(using: .utf8)!, withName: "voucher_id")
//            multipartFormData.append(self.strMobile.data(using: .utf8)!, withName: "phone")
//            multipartFormData.append(self.strDesc.data(using: .utf8)!, withName: "description")
//            multipartFormData.append(self.strVoucherPaymentID.data(using: .utf8)!, withName: "payment_replace_id")
//            multipartFormData.append(self.strScanVoucherType.data(using: .utf8)!, withName: "scan_voucher_type")
//            multipartFormData.append(self.strFullDate.data(using: .utf8)!, withName: "date")
//
//        }, usingThreshold: UInt64.init(),
//          to: "\(self.app.BaseURL)send_voucher_as_gift",
//            method: .post,
//            headers: Header,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                            self.loadingNotification.hide(animated: true)
//
//                            debugPrint("SUCCESS RESPONSE:- \(response)")
//                            if let value = response.result.value {
//                                self.json = JSON(value)
//                                print(self.json)
//
//                                let strStatus: String = self.json["status"].stringValue
//                                self.strMessage = self.json["message"].stringValue
//                                self.arabMessage = self.json["arab_message"].stringValue
//                                if self.app.strLanguage == "ar" {
//                                    self.app.isEnglish = false
//                                    Toast(text: self.arabMessage.localized).show()
//                                } else {
//                                    self.app.isEnglish = true
//                                    Toast(text: self.strMessage).show()
//                                }
//
//                                //Toast(text: self.strMessage).show()
//                                if strStatus == "1" {
//                                    let desiredViewController = self.navigationController!.viewControllers.filter { $0 is HomeView }.first!
//                                    self.navigationController!.popToViewController(desiredViewController, animated: true)
//                                }
//                            }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    Toast(text: self.app.RequestTimeOut.localized).show()
//                    self.loadingNotification.hide(animated: true)
//                }
//        })
    }

}
