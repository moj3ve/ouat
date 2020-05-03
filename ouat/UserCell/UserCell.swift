//
//  UserCell.swift
//  ouat
//
//  Created by Antique on 15/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit


class UserCell : UICollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .white

        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .right
        label.textColor = .secondaryLabel

        return label
    }()
    
    
    var imageView = UIImageView()
    
    
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
        round(corners: .allCorners, radius: 14)
        
        if imageView.image?.isDark ?? true {
            titleLabel.textColor = .white
            titleLabel.shadowColor = .black
        } else {
            titleLabel.textColor = .black
            titleLabel.shadowColor = .white
        }
    }
    
    
    func setup() {
        backgroundColor = .secondarySystemBackground

        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
        addSubview(subtitleLabel)
        
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        
        addSubview(titleLabel)
        
        titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
}
