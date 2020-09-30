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

class ProfileTableViewController: UITableViewController, ProfileCellDelegate, EditProfileDelegate {
    private let cellProfileRowIdentifier = "profile_row"
    private let cellProfileContentIdentifier = "profile_content_row"
    private var cancellable: AnyCancellable?
    
    @IBOutlet var profileView: ProfileUIView!
    @IBOutlet var profileHeigth: NSLayoutConstraint!
    @IBOutlet var profileTop: NSLayoutConstraint!
    @IBOutlet var profileBotton: NSLayoutConstraint!
    
    var originalHeight: CGFloat!
    var navBarHeigth: CGFloat!
    
    var userName: String = ""
    
    private lazy var dataSource = makeDataSource()
    
    enum Section: CaseIterable {
        case content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalHeight = profileHeigth.constant
        if let navBarHeigth = self.navigationController?.navigationBar.frame.height {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            self.navBarHeigth = navBarHeigth + topPadding
        }
        
        tableView.dataSource = dataSource
        profileView.delegate = self
        
        self.cancellable = DefaultGetProfilesUseCase(profileRepository: DefaultProfileRepository())
            .execute()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { data in
                DispatchQueue.main.async { [weak self] in
                    self?.updateProfileContent(profiles: data)
                    self?.updateProfile(profile: data[0])
                    self?.navigationItem.title = data[0].profile.name
                }
                
                guard let name = UserDefaults.standard.string(forKey: "Username") else { return }
                DispatchQueue.main.async {
                    self.navigationItem.title = name                     
                }
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let name = UserDefaults.standard.string(forKey: "Username") else { return }
        self.userName = name
        self.navigationItem.title = self.userName
    }
    
    // MARK: - Scroll Logic
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y <= 220 {
            UIView.animate(withDuration: 1) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
                self.profileBotton.constant = 15
            }
        } else {
            UIView.animate(withDuration: 1) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                self.profileBotton.constant = 100
            }
        }
    
        let offset = scrollView.contentOffset.y
        let baseline = -navBarHeigth
        
        if offset < baseline {
            profileTop.constant = offset
            profileHeigth.constant = originalHeight + abs (baseline - offset)
        } else {
            let navOffset = offset + navBarHeigth
            let profileBotton = baseline + originalHeight
            if navOffset >= profileBotton {
                profileTop.constant = baseline + abs(navOffset - profileBotton)
            } else {
                profileTop.constant = baseline
            }
            profileHeigth.constant = originalHeight
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
    
    // Delegates
    func callSegueFromCell() {
        performSegue(withIdentifier: "goToEditProfile", sender: nil)
    }
    
    func profileEditionDidEnd() {
        tableView.reloadData()
        guard let name = UserDefaults.standard.string(forKey: "Username") else { return }
        guard let biography = UserDefaults.standard.string(forKey: "Biography") else { return }
        guard let nickname = UserDefaults.standard.string(forKey: "Nickname") else { return }
        
        self.profileView.profileUserName.text = name
        self.profileView.profileBiography.text = biography
        self.profileView.profileUniqueUserName.text = nickname
        
        self.userName = name
        
        self.navigationItem.title = self.userName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditProfile" {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let editprofileVC = navigationController.topViewController as? EditProfileViewController else { return }
            editprofileVC.delegate = self
        }
    }
    
    func updateProfile(profile: ProfileWrapper) {
        self.profileView.profileUserName.text = UserDefaults.standard.string(forKey: "Username") ?? profile.profile.name
        self.profileView.profileBiography.text = UserDefaults.standard.string(forKey: "Biography") ?? profile.description
        self.profileView.profileFollowers.text = "5000"
        self.profileView.profileFollowing.text = "500"
        self.profileView.profileViews.text = "321,115"
    }
}

// MARK: - Table view data source
extension ProfileTableViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProfileWrapper> {
        let dataSource = UITableViewDiffableDataSource<Section, ProfileWrapper>(tableView: tableView, cellProvider: { (tableView, indexPath, profileRow) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellProfileContentIdentifier, for: indexPath) as! ProfileContentTableViewCell
                let url = URL(string: profileRow.profile.img)
                cell.contentUserImage.kf.setImage(with: url)
                cell.contentUserName.text = profileRow.profile.name
                cell.contentUserNickname.text = profileRow.profile.userName
                cell.contentUserDescription.text = profileRow.description
                cell.setContentUserVideoPlayer(url: profileRow.recordVideo)
                return cell
        })
            
        return dataSource
    }
    
    func updateProfileContent(profiles: [ProfileWrapper]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProfileWrapper>()
        snapshot.appendSections([.content])
        snapshot.appendItems(profiles, toSection: .content)
        
        dataSource.apply(snapshot)
    }
}
