//
//  String+Extension.swift
//  ouat
//
//  Created by Antique on 30/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation


extension String {
     func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}
