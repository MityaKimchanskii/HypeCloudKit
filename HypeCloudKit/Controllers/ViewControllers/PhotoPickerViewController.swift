//
//  PhotoPickerViewController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/14/22.
//

import UIKit


protocol PhotoPickerDelegate: AnyObject {
    func photoPickerSelected(image: UIImage)
}

class PhotoPickerViewController: UIViewController {
    
    // MARK: - Properties
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var selectPhotoButton: UIButton!
    weak var delegate: PhotoPickerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func photoButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Helper Methods
    func setupViews() {
        profilePhotoImageView.contentMode = .scaleAspectFill
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.backgroundColor = .lightGray
        imagePicker.delegate = self
    }
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            let alert = UIAlertController(title: "No Camera Access", message: "Please, allow access to the Camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            let alert = UIAlertController(title: "No Photo Library Access", message: "Please, allow access to the Photo Library.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoPickerSelected(image: pickedImage)
            profilePhotoImageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }
}
