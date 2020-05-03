//
//  SenderCell.swift
//  ouat
//
//  Created by Antique on 30/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class SenderCell : UICollectionViewCell {
    var textView = MessagePaddedTextView()
    
    
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
        textView.round(corners: .allCorners, radius: 14)
        //textView.addGradientToViewWithCornerRadiusAndShadow(radius: 14, firstColor: .systemBlue, secondColor: UIColor.systemBlue.withAlphaComponent(0.8), locations: [0, 1])
    }
    
    
    func setup() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        textView = MessagePaddedTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .systemBlue
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textAlignment = .right
        textView.textColor = .white
        contentView.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80).isActive = true
        //textView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        
        contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
    }
    
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
