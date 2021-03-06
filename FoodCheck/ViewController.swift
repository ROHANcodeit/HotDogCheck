//
//  ViewController.swift
//  FoodCheck
//
//  Created by Rohan Tyagi on 24/12/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        if let userPickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage     {
     
                imageView.image = userPickerImage
            
            guard let ciImage = CIImage(image: userPickerImage)else{
                fatalError("Could not convert UI Image")
            }
            
            detect(image: ciImage)
            
            }
     
           imagePicker.dismiss(animated: true, completion: nil)
     
    }

    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation]else{
                fatalError("Model Failed to process image")
            }
            
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title="Hotdog"
                }else{
                    self.navigationItem.title=" Not Hotdog"
                }
            }
            
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
            do{
                try handler.perform([request])
            }catch{
                print(error)
            }
        }
        
        
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

