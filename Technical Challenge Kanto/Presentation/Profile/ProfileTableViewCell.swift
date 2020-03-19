//
//  ProfileTableViewCell.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileTableViewCell: UITableViewCell {
    @IBInspectable var degreeColor1: UIColor = UIColor.blue
    @IBInspectable var degreeColor2: UIColor = UIColor.systemTeal
    
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileUniqueUserName: UILabel!
    @IBOutlet weak var profileBiography: UILabel!
    @IBOutlet weak var profileFollowers: UILabel!
    @IBOutlet weak var profileFollowing: UILabel!
    @IBOutlet weak var profileViews: UILabel!
    
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [degreeColor1.cgColor,
                           degreeColor2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        //        gradient.mask = shape
        self.contentView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
