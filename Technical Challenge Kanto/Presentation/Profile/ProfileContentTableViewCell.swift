//
//  ProfileContentTableViewCell.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileContentTableViewCell: UITableViewCell {
    @IBOutlet weak var contentUserImage: UIImageView!
    @IBOutlet weak var contentUserName: UILabel!
    @IBOutlet weak var contentUserNickname: UILabel!
    @IBOutlet weak var contentUserDescription: UILabel!
    @IBOutlet weak var contentUserVideoPlayer: UIView!
    lazy var player: AVPlayer = AVPlayer(playerItem: nil)
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspect
        return playerLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentUserVideoPlayer.layer.addSublayer(self.playerLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentUserVideoPlayer.layer.bounds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setContentUserVideoPlayer(url: String) {
        guard let videoURL = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        player.replaceCurrentItem(with: playerItem)
    }
    
    
}
