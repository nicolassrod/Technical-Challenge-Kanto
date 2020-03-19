//
//  ProfileRepository.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import Foundation
import Combine

protocol ProfileRepository {
    func profileList() -> AnyPublisher<[ProfileWrapper], Error>
}
