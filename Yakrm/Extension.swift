//
//  Extension.swift
//  Yakrm
//
//  Created by Gaurav Parmar on 18/05/20.
//  Copyright © 2020 Krutik V. Poojara. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.text = text?.localizeString()
    
    }
}

extension UISearchBar {
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.placeholder = self.placeholder?.localizeString()
    }
}

extension UITextField {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.text = text?.localizeString()
        self.placeholder = placeholder?.localizeString()
        
    }
}

extension UITextView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.text = text?.localizeString()
    
    }
}

extension UIButton {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        let normalTitle = self.title(for: .normal)?.localizeString()
        let highlightedTitle = self.title(for: .highlighted)?.localizeString()
        let selectedTitle = self.title(for: .selected)?.localizeString()
        
        self.setTitle(normalTitle, for: .normal)
        self.setTitle(highlightedTitle, for: .highlighted)
        self.setTitle(selectedTitle, for: .selected)

    }
}

private var appLangBundle: Bundle? = Bundle.main

extension String {
    func localizeString() -> String {
        return appLangBundle!.localizedString(forKey: self, value: "", table: nil)
    }
    
    func localizeString(_ args: String) -> String {
        let str = appLangBundle!.localizedString(forKey: self, value: "", table: nil)
        
        return String(format: str, args)
    }
}
