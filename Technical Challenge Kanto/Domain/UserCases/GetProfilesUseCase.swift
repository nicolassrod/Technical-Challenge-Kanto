//
//  GetProfilesUseCase.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import Foundation
import Combine

protocol GetProfileUseCaseProtocol {
    func execute() -> AnyPublisher<[ProfileWrapper], Error>
}

struct DefaultGetProfilesUseCase: GetProfileUseCaseProtocol{
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func execute() -> AnyPublisher<[ProfileWrapper], Error> {
        profileRepository.profileList()
    }
    
}
