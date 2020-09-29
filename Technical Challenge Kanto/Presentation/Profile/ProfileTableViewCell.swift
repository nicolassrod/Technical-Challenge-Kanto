//
//  ProfileTableViewCell.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate: class {
    func callSegueFromCell()
}

@IBDesignable
class ProfileTableViewCell: UITableViewCell {
    weak var delegate: ProfileCellDelegate?
    @IBInspectable var degreeColor1: UIColor = UIColor.purple
    @IBInspectable var degreeColor2: UIColor = UIColor.systemPurple
    
    @IBOutlet var profileAvatarImageView: UIImageView!
    @IBOutlet var profileUserName: UILabel!
    @IBOutlet var profileUniqueUserName: UILabel!
    @IBOutlet var profileBiography: UILabel!
    
    @IBOutlet var profileStackContainer: UIStackView!
    @IBOutlet var profileFollowers: UILabel!
    @IBOutlet var profileFollowing: UILabel!
    @IBOutlet var profileViews: UILabel!
    
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [degreeColor1.cgColor,
                           degreeColor2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        //        gradient.mask = shape
        self.contentView.layer.insertSublayer(gradient, at: 0)
        self.profileStackContainer.isLayoutMarginsRelativeArrangement = true
        self.profileStackContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 7, leading: 20, bottom: 7, trailing: 20)
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBAction func EditProfileButton(_ sender: UIButton) {
        delegate?.callSegueFromCell()
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
