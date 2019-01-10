//
//  RekognizeController.swift
//  care-bears-rekognition
//
//  Created by Samuel Echikson on 12/11/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit
import AWSRekognition
import AWSS3

class Rekognize {
    
    var rekognition: AWSRekognition!
    var s3: AWSS3TransferUtility!
    var image: UIImage!
    
    var delegate: RekognizeDelegate?
    
    init() {
        rekognition = AWSRekognition.default()
        print("Initialized Rekognition")
        s3 = AWSS3TransferUtility.default()
        print("Initialized S3")
    }
    
    init(image: UIImage) {
        rekognition = AWSRekognition.default()
        print("Initialized Rekognition")
        s3 = AWSS3TransferUtility.default()
        print("Initialized S3")
        self.image = image
        
        if (self.image != nil) {
            saveImageToS3(image: self.image)
        } else {
            print("No input Image!")
        }
    }
    
    func saveImageToS3(image: UIImage) {
        print("Saving Image to S3 Bucket")
        
        let imageData:Data = image.pngData()!
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                print("upload in process \(progress.fractionCompleted)")
//                self.s3Progress.setProgress(Float(progress.fractionCompleted), animated: true)
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                print("upload completed1 \(task.bucket)")
                print("upload completed2 \(String(describing: task.response))")
                print("upload completed3 \(task.key)")
                
                self.rekognizeFaces()
            })
        }
        
        s3.uploadData(imageData,
                      bucket: "care-bears-faces",
                      key: "rekognition-image.png",
                      contentType: "image/png",
                      expression: expression,
                      completionHandler: completionHandler).continueWith { (task) -> Any? in
                        if let error = task.error {
                            print("Error: \(error.localizedDescription)")
                        }
                        
                        if let _ = task.result {
                            print("something upload completed \(String(describing: task.result.debugDescription))")
                            
                            self.delegate?.didUploadToS3(self)
                            //                            DispatchQueue.main.async {
                            //                                self.showLoading(text: "Analyzing image...")
                            //                            }
                        }
                        return nil;
        }
    }
    
    func rekognizeFaces() {
        
        let s3Image = AWSRekognitionS3Object()
        s3Image?.bucket = "care-bears-faces"
        s3Image?.name = "rekognition-image.png"
        
        let rekognitionImage = AWSRekognitionImage()
        rekognitionImage?.s3Object = s3Image
        
        let req = AWSRekognitionSearchFacesByImageRequest()!
        req.collectionId = "care-bear-faces"
        req.maxFaces = 2
        req.image = rekognitionImage
        
        rekognition.searchFaces(byImage: req).continueWith(block: { (task) -> Any? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let response = task.result {
                let likelyhood = response.faceMatches!.first!.face!.externalImageId!
                print("Most likely: \(likelyhood)")
                
                let confidence = response.faceMatches!.first!.similarity!
                print("Confidence: \(confidence.stringValue)%")
                
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 2
                
                DispatchQueue.main.async {
                    self.delegate?.didRecognizeFace(self, name: likelyhood, confidence: Double(truncating: confidence))
//                    self.rekognitionResultName.text = likelyhood
//                    self.rekognitionResultName.isHidden = false
//                    self.rekognitionResultConfidence.text = "\(formatter.string(from: confidence) ?? "0")%"
//                    self.rekognitionResultConfidence.isHidden = false
//                    self.hideLoading()
                }
            }
            return nil;
        })
    }
}
