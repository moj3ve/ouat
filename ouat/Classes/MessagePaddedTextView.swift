//
//  MessagePaddedTextView.swift
//  ouat
//
//  Created by Jarrod Norwell on 30/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class MessagePaddedTextView : UITextView {
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
        
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
