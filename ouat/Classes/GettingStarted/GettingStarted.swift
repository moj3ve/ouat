//
//  GettingStarted.swift
//  ouat
//
//  Created by Antique on 8/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class GettingStarted : NSObject {
    var hobbies = [String]()
    var userDetails = [String]()
    var biography = String()
    var location = [Double]()
    var locale = String()
    var profile_image = Data()
    
    
    var savedDetails = false
    var savedBiography = false
    var savedHobbies = false
    var savedLocation = false
    var chosenImage = false
}
