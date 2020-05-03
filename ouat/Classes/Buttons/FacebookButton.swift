//
//  FacebookButton.swift
//  ouat
//
//  Created by Antique on 6/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit

class FacebookButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        round(corners: .allCorners, radius: 4)
    }
    
    
    func setup() {
        backgroundColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1.0)
    }
}
