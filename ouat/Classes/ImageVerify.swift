//
//  ImageVerify.swift
//  ouat
//
//  Created by Antique on 6/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class ImageVerify : NSObject {
    func verify(image: UIImage) -> Bool {
        return findfaces(image: image)
    }
    
    
    func findfaces(image: UIImage) -> Bool {
        let ciImage = CIImage(cgImage: image.cgImage!)

        let options = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!

        let faces = faceDetector.features(in: ciImage)
        if faces.count == 0 {
            print("[e]: Error finding a face in the provided image.")
            return false
        } else {
            return true
        }
    }
}
