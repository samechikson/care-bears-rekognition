//
//  FaceDetectDelegate.swift
//  care-bears
//
//  Created by Samuel Echikson on 12/28/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit

protocol FaceDetectDelegate {
    
    func didDetectFace(_ sender: FaceDetect)
    
    func didDetectFaceInCenter(_ sender: FaceDetect, selfie: UIImage)
}
