//
//  RekognizeDelegate.swift
//  care-bears
//
//  Created by Samuel Echikson on 12/31/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit

protocol RekognizeDelegate {
    
    func didRecognizeFace(_ sender: Rekognize, name: String, confidence: Double)
    
    func didNotRecognizeFace(_ sender: Rekognize)
    
    func didUploadToS3(_ sender: Rekognize)
}
