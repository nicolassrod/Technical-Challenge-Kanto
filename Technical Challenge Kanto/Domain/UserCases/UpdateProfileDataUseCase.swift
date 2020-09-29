//
//  UpdateProfileDataUseCase.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 9/29/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import Foundation
import Combine

protocol UpdateProfileUseCaseProtocol {
    func update(name: String, nickName: String, biography: String)
}

struct DefaultUpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func update(name: String, nickName: String, biography: String) {
        profileRepository.updateProfile(name: name, nickName: nickName, biography: biography)
    }
    
}
