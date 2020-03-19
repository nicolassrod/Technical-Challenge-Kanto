//
//  PrimaryUIButton.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit

@IBDesignable
class PrimaryUIButton: UIButton {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.titleLabel?.textColor = .black
        layer.cornerRadius = rect.size.height / 2
    }
    

}
