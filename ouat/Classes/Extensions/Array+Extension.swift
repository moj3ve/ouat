//
//  Array+Extension.swift
//  ouat
//
//  Created by Antique on 9/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


extension Array where Element : Equatable {
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}
