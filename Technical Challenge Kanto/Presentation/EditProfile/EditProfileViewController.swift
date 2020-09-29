//
//  EditProfileViewController.swift
//  Technical Challenge Kanto
//
//  Created by Nicolás A. Rodríguez on 3/19/20.
//  Copyright © 2020 Nicolás A. Rodríguez. All rights reserved.
//

import UIKit

protocol EditProfileDelegate: class {
    func profileEditionDidEnd()
}

class EditProfileViewController: UIViewController {
    weak var delegate: EditProfileDelegate?
    
    private var profile = DefaultUpdateProfileUseCase(profileRepository: DefaultProfileRepository())
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var biographyTextField: UITextField!
    
    weak var profileTebleViewController: ProfileTableViewController?
    private let imagePicker = UIImagePickerController()
    
    private var userName = UserDefaults.standard.string(forKey: "Username") ?? ""
    private var biography = UserDefaults.standard.string(forKey: "Biography") ?? ""
    private var nickname = UserDefaults.standard.string(forKey: "Nickname") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = userName
        nickNameTextField.text = nickname
        biographyTextField.text = biography
        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        profile.update(name: self.userName, nickName: self.nickname, biography: self.biography)
        delegate?.profileEditionDidEnd()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.userName = text
    }
    
    @IBAction func nicknameTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.nickname = text
       
    }
    
    @IBAction func bioTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.biography = text
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
