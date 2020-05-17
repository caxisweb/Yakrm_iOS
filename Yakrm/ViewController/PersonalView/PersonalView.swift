//
//  PersonalView.swift
//  Yakrm
//
//  Created by Krutik V. Poojara on 06/12/18.
//  Copyright © 2018 Krutik V. Poojara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Toaster

class PersonalView: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Outlet

    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewBorder: UIView!

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgUser: UIImageView!

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!

    @IBOutlet var txtNAME: UITextField!
    @IBOutlet var txtCOUNTRY: UITextField!
    @IBOutlet var txtMOBILE: UITextField!
    @IBOutlet var txtEMAIL: UITextField!
    @IBOutlet var txtPASSWORD: UITextField!

    @IBOutlet var viewName: UIView!
    @IBOutlet var viewCountry: UIView!
    @IBOutlet var viewMobile: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPassword: UIView!

    @IBOutlet var btnModify: UIButton!
    @IBOutlet var btnCamera: UIButton!

    let salutations = ["Saudi Arabia"]

    var loadingNotification: MBProgressHUD!
    var json: JSON!
    var strMessage: String!

    var app = AppDelegate()

    var strName = String()
    var strEmail = String()
    var strMobile = String()
    var strPassword = String()
    var strImage = String()
    var strCountryID = "1"

    var picker = UIImagePickerController()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        app = UIApplication.shared.delegate as! AppDelegate

        self.btnCamera.layer.cornerRadius = self.btnCamera.frame.size.height / 2
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
        self.imgProfile.clipsToBounds = true
        strImage = self.app.strProfile.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        self.imgProfile.sd_setImage(with: URL(string: "\(self.app.ImageURL)user_profile/\(self.strImage)"), placeholderImage: UIImage(named: "user.png")!)

        self.picker.delegate = self

        if self.app.strUserID.isEmpty {
            self.txtName.text = ""
            self.txtCountry.text = ""
            self.txtMobile.text = ""
            self.txtEmail.text = ""
        } else {
            self.txtName.text = self.app.strName
            self.txtCountry.text = "Saudi Arabia"
            self.txtMobile.text = self.app.strMobile
            self.txtEmail.text = self.app.strEmail
        }

        self.txtMobile.maxLength = 12
        self.viewNavigation.backgroundColor = UIColor.init(rgb: 0xEE4158)

        self.viewBorder.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 1, scale: true)

        if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_XR {
            self.viewNavigation.frame = CGRect(x: self.viewNavigation.frame.origin.x, y: self.viewNavigation.frame.origin.y, width: self.viewNavigation.frame.size.width, height: 88)
            self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.viewNavigation.frame.origin.y + self.viewNavigation.frame.size.height, width: self.scrollView.frame.size.width, height: ScreenSize.SCREEN_HEIGHT - self.viewNavigation.frame.size.height)
        }
        if DeviceType.IS_IPHONE_5 {
            self.txtName.font = self.txtName.font!.withSize(self.txtName.font!.pointSize-1)
            self.txtCountry.font = self.txtCountry.font!.withSize(self.txtCountry.font!.pointSize-1)
            self.txtMobile.font = self.txtMobile.font!.withSize(self.txtMobile.font!.pointSize-1)
            self.txtEmail.font = self.txtEmail.font!.withSize(self.txtEmail.font!.pointSize-1)
            self.txtPassword.font = self.txtPassword.font!.withSize(self.txtPassword.font!.pointSize-1)

            self.txtNAME.font = self.txtNAME.font!.withSize(self.txtNAME.font!.pointSize-1)
            self.txtCOUNTRY.font = self.txtCOUNTRY.font!.withSize(self.txtCOUNTRY.font!.pointSize-1)
            self.txtMOBILE.font = self.txtMOBILE.font!.withSize(self.txtMOBILE.font!.pointSize-1)
            self.txtEMAIL.font = self.txtEMAIL.font!.withSize(self.txtEMAIL.font!.pointSize-1)
            self.txtPASSWORD.font = self.txtPASSWORD.font!.withSize(self.txtPASSWORD.font!.pointSize-1)

//            self.lblName.font = self.lblName.font.withSize(self.lblName.font.pointSize-1)

            self.btnModify.titleLabel!.font = self.btnModify.titleLabel!.font.withSize(self.btnModify.titleLabel!.font.pointSize-1)
        }

//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        txtCountry.inputView = pickerView

        self.setTextfildDesign(txt: self.txtName, vv: self.viewName, isView: false)
        self.setTextfildDesign(txt: self.txtCountry, vv: self.viewCountry, isView: false)
        self.setTextfildDesign(txt: self.txtMobile, vv: self.viewMobile, isView: false)
        self.setTextfildDesign(txt: self.txtEmail, vv: self.viewEmail, isView: false)
        self.setTextfildDesign(txt: self.txtPassword, vv: self.viewPassword, isView: false)

        self.setTextfildDesign(txt: self.txtNAME, vv: self.viewName, isView: true)
        self.setTextfildDesign(txt: self.txtCOUNTRY, vv: self.viewCountry, isView: true)
        self.setTextfildDesign(txt: self.txtMOBILE, vv: self.viewMobile, isView: true)
        self.setTextfildDesign(txt: self.txtEMAIL, vv: self.viewEmail, isView: true)
        self.setTextfildDesign(txt: self.txtPASSWORD, vv: self.viewPassword, isView: true)

        self.btnModify.layer.cornerRadius = 5

//        let stringsize: CGSize = self.lblName.text!.size(withAttributes: [NSAttributedString.Key.font : self.lblName.font])
//        self.lblName.frame = CGRect(x:self.lblName.frame.origin.x, y:self.lblName.frame.origin.y, width:stringsize.width, height:self.lblName.frame.size.height)
//        self.lblName.center.x = self.imgProfile.center.x
        if self.app.isEnglish {
//            self.imgUser.frame = CGRect(x:self.lblName.frame.origin.x - self.imgUser.frame.size.width - 5, y:self.imgUser.frame.origin.y, width:self.imgUser.frame.size.width, height:self.imgUser.frame.size.height)
            self.lblTitle.textAlignment = .left
        } else {
//            self.imgUser.frame = CGRect(x:self.lblName.frame.origin.x + self.lblName.frame.size.width + 5, y:self.imgUser.frame.origin.y, width:self.imgUser.frame.size.width, height:self.imgUser.frame.size.height)

            self.setTexfieldFrame(txt: self.txtName, TXT: self.txtNAME)
            self.setTexfieldFrame(txt: self.txtCountry, TXT: self.txtCOUNTRY)
            self.setTexfieldFrame(txt: self.txtMobile, TXT: self.txtMOBILE)
            self.setTexfieldFrame(txt: self.txtEmail, TXT: self.txtEMAIL)
            self.setTexfieldFrame(txt: self.txtPassword, TXT: self.txtPASSWORD)

            self.lblTitle.textAlignment = .right
        }
        self.setScrollViewHeight()
    }

    func setTexfieldFrame(txt: UITextField, TXT: UITextField) {
//        let tt = UITextField()
//        tt.frame.origin.x = txt.frame.origin.x
        txt.frame.origin.x = TXT.frame.origin.x
        TXT.frame.origin.x = txt.frame.origin.x + txt.frame.size.width + 5
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func setScrollViewHeight() {
        for viewAll: UIView in scrollView.subviews {
            if viewAll.tag == 100 {
                scrollView.contentSize = CGSize(width: CGFloat(scrollView.frame.size.width), height: CGFloat(viewAll.frame.origin.y + viewAll.frame.size.height + 15))
            }
        }
    }

    func setTextfildDesign(txt: UITextField, vv: UIView, isView: Bool) {
        txt.delegate = self
        txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
        if isView {
            txt.placeHolderColor = UIColor.darkGray.withAlphaComponent(0.5)
            if self.app.isEnglish {
                if self.app.isLangEnglish {
                    txt.setLeftPaddingPoints(vv)
                } else {
                    txt.setRightPaddingPoints(vv)
                }
            } else {
                if self.app.isLangEnglish {
                    txt.setRightPaddingPoints(vv)
                } else {
                    txt.setLeftPaddingPoints(vv)
                }
            }
        }
        if self.app.isEnglish {
            txt.textAlignment = .left
        } else {
            txt.textAlignment = .right
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if self.txtMobile == textField
//        {
//            let ACCEPTABLE_CHARACTERS = "0123456789"
//            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//            
//            return (string == filtered)
//        }
//        return true
//    }
//    
    @IBAction func btnChangePasswordAction(_ sender: UIButton) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordView") as! ChangePasswordView
//        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func btnModifyAction(_ sender: UIButton) {
        self.txtName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtMobile.resignFirstResponder()

        self.strName = self.txtName.text!
        self.strEmail = self.txtEmail.text!
        self.strMobile = self.txtMobile.text!

        if self.strName.isEmpty {
            Toast(text: "Please Enter Name").show()
        } else if self.strName.characters.count < 3 {
            Toast(text: "Name should be minimum of 3 characters").show()
        } else if self.strEmail.isEmpty {
            Toast(text: "Please Enter Email").show()
        } else if self.strEmail.isValidEmail() == false {
            Toast(text: "Please Enter Valid Email").show()
        } else if self.strMobile.isEmpty {
            Toast(text: "Please Enter Mobile Number").show()
        } else if self.strMobile.characters.count < 10 {
            Toast(text: "Mobile Number should be minimum of 10 characters").show()
        } else {
            if self.app.isConnectedToInternet() {
                self.UpdateProfileAPI()
            } else {
                Toast(text: self.app.InternetConnectionMessage).show()
            }
        }
    }

    // MARK: - Sign Up API
    func UpdateProfileAPI() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

        let headers: HTTPHeaders = ["Authorization": self.app.strToken,
                                     "Content-Type": "application/json"]

        let parameters: Parameters = ["name": self.strName,
                                      "email": self.strEmail,
                                      "phone": self.strMobile,
                                      "country_id": "1"]
        print(JSON(parameters))

        AppWebservice.shared.request("\(self.app.BaseURL)update_user_profile", method: .post, parameters: parameters, headers: headers, loader: true) { (statusCode, response, error) in
            if statusCode == 200 {
                self.json = response!
                print(self.json)

                let strStatus: String = self.json["status"].stringValue
                self.strMessage = self.json["message"].stringValue
                Toast(text: self.strMessage).show()

                if strStatus == "1" {
                    self.app.strName = self.json["name"].stringValue
                    self.app.strEmail = self.json["email"].stringValue
                    self.app.strMobile = self.json["phone"].stringValue
                    self.app.strToken = self.json["token"].stringValue

                    self.app.defaults.setValue(self.app.strName, forKey: "name")
                    self.app.defaults.setValue(self.app.strEmail, forKey: "email")
                    self.app.defaults.setValue(self.app.strMobile, forKey: "mobile")
                    self.app.defaults.setValue(self.app.strToken, forKey: "token")

                    self.app.defaults.synchronize()
                }
            } else {
                Toast(text: error?.localizedDescription).show()
            }
        }
    }

    @IBAction func btnUploadPrfile(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Photo!", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Take Photo", style: .default, handler: { (_) -> Void in
            self.openCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
            print("Cancel Button Pressed")
        })
        let  delete = UIAlertAction(title: "Choose from Gallery", style: .default) { (_) -> Void in
            self.openGallary()
        }

        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addAction(delete)

        present(alertController, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            //            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            //            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            //            alert.addAction(ok)
            //            present(alert, animated: true, completion: nil)
            self.openGallary()
        }
    }

    func openGallary() {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let imageSelected = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage

        picker .dismiss(animated: true, completion: nil)

        if self.app.isConnectedToInternet() {
            self.UpdateImageFileAPI(img: imageSelected!)
        } else {
            Toast(text: self.app.InternetConnectionMessage).show()
        }
    }

    func UpdateImageFileAPI(img: UIImage) {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: false)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
//        loadingNotification.dimBackground = true

        let Header: HTTPHeaders = ["Authorization": self.app.strToken]
        //,"Content-Type":"application/json"

//        AF.upload(multipartFormData: { multipartFormData in
//            if let imageData = img.jpegData(compressionQuality: 0.3) {
//                let format = DateFormatter()
//                format.dateFormat="yyyy-MM-dd-HH-mm-ss"
//                let currentFileName: String = "IMG-\(format.string(from: Date())).jpeg"
//
//                multipartFormData.append(imageData, withName: "user_profile", fileName: currentFileName, mimeType: "image/jpeg") //jpeg png
//            }
//
//        }, usingThreshold: UInt64.init(),
//          to: "\(self.app.BaseURL)profile_image_upload",
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
//
//                                if strStatus == "1" {
//                                    self.imgProfile.image = img
//
//                                    self.app.strProfile = self.json["user_profile"].stringValue
//                                    self.app.defaults.setValue(self.app.strProfile, forKey: "profile")
//                                    self.app.defaults.synchronize()
//                                }
////                                else
////                                {
//                                    Toast(text: self.strMessage).show()
////                                }
//                            }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    Toast(text: "Request time out.").show()
//                    self.loadingNotification.hide(animated: true)
//                }
//        })
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salutations.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return salutations[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCountry.text = salutations[row]
    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
