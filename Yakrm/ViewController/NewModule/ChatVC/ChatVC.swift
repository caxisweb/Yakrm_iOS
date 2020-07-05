//
//  ChatVC.swift
//  Tawseeel
//
//  Created by Gaurav Parmar on 18/02/20.
//  Copyright © 2020 Gaurav Parmar. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension String {
    var toDouble : Double {
        if let dbl = Double(self) {
            return dbl
        }
        return 0.0
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension Date {
    var hour: Int { return Calendar.autoupdatingCurrent.component(.hour, from: self) }
    var minute: Int { return Calendar.autoupdatingCurrent.component(.minute, from: self) }
    var second: Int { return Calendar.autoupdatingCurrent.component(.second, from: self) }
}



class ChatVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var barBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var actionButtons: [UIButton]!
    
    private var messages = [Message]()
    var orderId : String!
    var name : String!
    var phone : String!
    var app = AppDelegate()
    var bottomInset: CGFloat {
      return view.safeAreaInsets.bottom + 50
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessages()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
      guard let text = inputTextField.text, !text.isEmpty else { return }
        let message = Message()
        message.message = text
        message.orderId = orderId
        inputTextField.text = nil
        message.date = Date().string(format: "EEE, MMM d, yyyy")
        message.time = Date().string(format: "hh:mm a")
        message.customerName = self.app.strName
        message.customerId = self.app.strMobile
        message.driverId = phone ?? ""
        message.driverName = name ?? ""
        message.userType = "customer"
        
        let date = Date().string(format: "yyyy-MM-dd")
        let time = String(Date().hour) + String(Date().minute) + String(Date().second)
        let fDate = date + "_" + time
        var dic = [String : Any]()
        dic[fDate] = message.toDictionary()
        Database.database().reference().child("OrdersChat").child(orderId).updateChildValues(dic)
    }
    
    @IBAction func btnBackTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ChatVC {
    
    private func fetchMessages() {
        AppFirebase.shared.messages(for: orderId) {[weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
            self?.tableView.scroll(to: .bottom, animated: true)
        }
    }
}
//MARK: UITableView Delegate & DataSource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = messages[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: message.userType?.lowercased() == "driver" ? "MessageTableViewCell" : "UserMessageTableViewCell") as! MessageTableViewCell
      cell.set(message)
      return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard tableView.isDragging else { return }
    cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    UIView.animate(withDuration: 0.3, animations: {
      cell.transform = CGAffineTransform.identity
    })
  }
}

//MARK: UItextField Delegate
extension ChatVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

    return true
  }
}

extension UITableView {
  
  func scroll(to: Position, animated: Bool) {
    let sections = numberOfSections
    let rows = numberOfRows(inSection: numberOfSections - 1)
    switch to {
    case .top:
      if rows > 0 {
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: animated)
      }
      break
    case .bottom:
      if rows > 0 {
        let indexPath = IndexPath(row: rows - 1, section: sections - 1)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
      }
      break
    }
  }
  
  enum Position {
    case top
    case bottom
  }
}
