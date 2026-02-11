//
//  PostViewController.swift
//  BeReal
//
//  Created by Bryan Puckett on 2/9/26.
//

import UIKit
import ParseSwift
import PhotosUI
import MapKit
import CoreLocation

class PostViewController: UIViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!

    private var pickedImage: UIImage?
    private var pickedLocation: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.attributedPlaceholder = NSAttributedString(
            string: "Write a caption...",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        captionTextField.delegate = self

        // Set initial location label state
        locationLabel.text = "No location detected"
        locationLabel.textColor = .gray

        // Tap anywhere to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func onPickPhotoTapped(_ sender: Any) {
        // Dismiss keyboard first
        view.endEditing(true)

        // Use PHPickerConfiguration with photoLibrary to get asset identifiers
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func onShareTapped(_ sender: Any) {
        // Dismiss keyboard first
        view.endEditing(true)

        guard let image = pickedImage,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            showAlert(description: "Please select a photo first.")
            return
        }

        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        var post = Post()
        post.imageFile = imageFile
        post.caption = captionTextField.text
        post.user = User.current
        post.location = pickedLocation

        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let savedPost):
                    print("Post saved: \(savedPost)")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    // If session token is invalid, trigger logout
                    if error.code == .invalidSessionToken {
                        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
                    } else {
                        self?.showAlert(description: error.localizedDescription)
                    }
                }
            }
        }
    }

    // MARK: - Location Extraction

    private func extractLocation(from assetIdentifier: String) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
        guard let asset = fetchResult.firstObject,
              let location = asset.location else {
            pickedLocation = nil
            DispatchQueue.main.async {
                self.locationLabel.text = "No location detected"
                self.locationLabel.textColor = .gray
            }
            return
        }

        // Reverse geocode the coordinates to a readable location using MapKit
        guard let request = MKReverseGeocodingRequest(location: location) else {
            pickedLocation = nil
            DispatchQueue.main.async {
                self.locationLabel.text = "No location detected"
                self.locationLabel.textColor = .gray
            }
            return
        }
        Task {
            do {
                let mapItems = try await request.mapItems
                guard let mapItem = mapItems.first else {
                    await MainActor.run {
                        self.pickedLocation = nil
                        self.locationLabel.text = "No location detected"
                        self.locationLabel.textColor = .gray
                    }
                    return
                }

                // Use the new MKAddress API to get a readable location string
                let locationString = mapItem.address?.shortAddress ?? mapItem.address?.fullAddress

                await MainActor.run {
                    self.pickedLocation = locationString
                    if let loc = locationString {
                        self.locationLabel.text = "📍 \(loc)"
                        self.locationLabel.textColor = .white
                    } else {
                        self.locationLabel.text = "No location detected"
                        self.locationLabel.textColor = .gray
                    }
                }
            } catch {
                await MainActor.run {
                    self.pickedLocation = nil
                    self.locationLabel.text = "No location detected"
                    self.locationLabel.textColor = .gray
                }
            }
        }
    }

    private func showAlert(description: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: description,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        // Extract location from the asset identifier if available
        if let assetIdentifier = result.assetIdentifier {
            extractLocation(from: assetIdentifier)
        }

        let provider = result.itemProvider
        guard provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(description: error.localizedDescription)
                }
                return
            }

            guard let image = object as? UIImage else { return }

            DispatchQueue.main.async {
                self?.previewImageView.image = image
                self?.pickedImage = image
            }
        }
    }
}
