//
//  MessageTableViewCell.swift
//  Tawseeel
//
//  Created by Gaurav Parmar on 18/02/20.
//  Copyright © 2020 Gaurav Parmar. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profilePic: UIImageView?
  @IBOutlet weak var messageTextView: UITextView?
  
  func set(_ message: Message) {
    messageTextView?.text = message.message
  }
}
