//
//  ProfileTableViewController.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

class ProfileTableViewController: UITableViewController {
    private let cellProfileRowIdentifier = "profile_row"
    private let cellProfileContentIdentifier = "profile_content_row"
    private var cancellable: AnyCancellable?
    @IBOutlet weak var PanGestureRecognizer: UIPanGestureRecognizer!
    
    var profileCellIsReady = false
    var lastContentOffset: CGFloat = 0
    
    private lazy var dataSource = makeDataSource()
    
    enum Section: CaseIterable {
        case profile
        case content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        self.cancellable = DefaultGetProfilesUseCase(profileRepository: DefaultProfileRepository())
            .execute()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: {
                self.updateProfiles(profiles: $0)
            })
    }
    
    // MARK: - Scroll Logic
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // Did move down
            guard scrollView.contentOffset.y > 0,
                scrollView.contentOffset.y <= 338,
                profileCellIsReady == true else {
                    return
            }
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            profileCellIsReady = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? ProfileContentTableViewCell else { return };
        
        videoCell.playerLayer.player?.pause();
        videoCell.playerLayer.player?.replaceCurrentItem(with: nil)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isDecelerating && !scrollView.isDragging {
            playVideo()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            playVideo()
        }
    }
    
    func playVideo() {
        for cell in tableView.visibleCells {
            guard let videoCell = (cell as? ProfileContentTableViewCell) else { return }
            videoCell.playerLayer.player?.play()
        }
    }
    
}

// MARK: - Table view data source
extension ProfileTableViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProfileWrapper> {
        let dataSource = UITableViewDiffableDataSource
            <Section, ProfileWrapper>(tableView: tableView, cellProvider: { (tableView, indexPath, profileRow) -> UITableViewCell? in
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellProfileRowIdentifier, for: indexPath) as! ProfileTableViewCell
                    cell.profileUserName.text = UserDefaults.standard.string(forKey: "Username") ?? profileRow.profile.name
                    cell.profileBiography.text = UserDefaults.standard.string(forKey: "Biography") ?? profileRow.description
                    cell.profileFollowers.text = "5000"
                    cell.profileFollowing.text = "500"
                    cell.profileViews.text = "321,115"
                    return cell
                } else if indexPath.section == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellProfileContentIdentifier, for: indexPath) as! ProfileContentTableViewCell
                    let url = URL(string: profileRow.profile.img)
                    cell.contentUserImage.kf.setImage(with: url)
                    cell.contentUserName.text = profileRow.profile.name
                    cell.contentUserNickname.text = profileRow.profile.userName
                    cell.contentUserDescription.text = profileRow.description
                    cell.setContentUserVideoPlayer(url: profileRow.recordVideo)
                    return cell
                } else {
                    return nil
                }
            })
        return dataSource
    }
    
    func updateProfiles(profiles: [ProfileWrapper]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProfileWrapper>()
        snapshot.appendSections([.profile, .content])
        snapshot.appendItems(profiles, toSection: .content)
        snapshot.appendItems([profiles.first!], toSection: .profile)
        
        dataSource.apply(snapshot)
    }
}
