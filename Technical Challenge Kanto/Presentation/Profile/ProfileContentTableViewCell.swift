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
    @IBOutlet var contentUserImage: UIImageView!
    @IBOutlet var contentUserName: UILabel!
    @IBOutlet var contentUserNickname: UILabel!
    @IBOutlet var contentUserDescription: UILabel!
    @IBOutlet var contentUserVideoPlayer: UIView!
    lazy var player: AVPlayer = AVPlayer(playerItem: nil)
    lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspect
        player.volume = 0.0
        return playerLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentUserVideoPlayer.layer.insertSublayer(playerLayer, at: 0)
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
