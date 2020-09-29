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
    private let url = URL(string: "http://www.mocky.io/v2/5e669952310000d2fc23a20e")!
    
    func profileList() -> AnyPublisher<[ProfileWrapper], Error> {
        let urlSession = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: [ProfileWrapper].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            
        return urlSession
    }
    
    func updateProfile(name: String, nickName: String, biography: String) {
        UserDefaults.standard.set(name, forKey: "Username")
        UserDefaults.standard.set(biography, forKey: "Biography")
        UserDefaults.standard.set(nickName, forKey: "Nickname")
    }
}
