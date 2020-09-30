//
//  ProfileCustomNavigationViewController.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 9/30/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit

class ProfileCustomNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
