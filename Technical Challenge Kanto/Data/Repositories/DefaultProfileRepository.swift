//
//  DefaultProfileRepository.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/17/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import Foundation
import Combine

struct DefaultProfileRepository: ProfileRepository {
    func profileList() -> AnyPublisher<[ProfileWrapper], Error> {
        let urlSession = URLSession
            .shared
            .dataTaskPublisher(for: URL(string: "http://www.mocky.io/v2/5e3a01073200006700ddfe05")!)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: [ProfileWrapper].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            
        return urlSession
    }
    
    
}
