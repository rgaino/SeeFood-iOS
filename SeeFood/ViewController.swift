//
//  ViewController.swift
//  SeeFood
//
//  Created by Rafael Gaino on 22/05/18.
//  Copyright © 2018 Rafael Gaino. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            guard let ciImage = CIImage(image: image) else {
                fatalError()
            }
            detectImage(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil )
    }
    
    func detectImage(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Fatal error loading CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Couldn't get observations")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hot Dog"
                } else {
                    self.navigationItem.title = "Not Hot Dog"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        try! handler.perform([request])
        
    }

    @IBAction func cameraTApped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated:true, completion: nil)
        
    }
    
}

