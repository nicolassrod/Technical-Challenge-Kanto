//
//  ProfileEntiti.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import Foundation

// MARK: - ProfileWrapper
struct ProfileWrapper: Codable, Hashable {
    let id = UUID()
    let profile: Profile
    let description: String
    let recordVideo: String

    enum CodingKeys: String, CodingKey {
        case profile
        case description
        case recordVideo = "record_video"
    }
}

// MARK: - Profile
struct Profile: Codable, Hashable {
    let name: String
    let userName: String
    let img: String

    enum CodingKeys: String, CodingKey {
        case name
        case userName = "user_name"
        case img
    }
}

