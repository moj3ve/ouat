//
//  ContinueButton.swift
//  ouat
//
//  Created by Antique on 6/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit

class GeneralButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(color: .systemBlue)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(color: .systemBlue)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        round(corners: .allCorners, radius: 14)
    }
    
    
    func setup(color: UIColor) {
        backgroundColor = color
    }
}
