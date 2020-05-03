//
//  PaddedTextView.swift
//  ouat
//
//  Created by Antique on 9/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class PaddedTextView : UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup() {
        backgroundColor = .secondarySystemBackground
        isScrollEnabled = false
        
        textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textContainer.lineBreakMode = .byTruncatingTail
        textContainer.maximumNumberOfLines = 5
    }
}
