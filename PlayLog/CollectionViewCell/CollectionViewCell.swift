//
//  CollectionViewCell.swift
//  PlayLog
//
//  Created by Prasanth pc on 2019-04-01.
//  Copyright © 2019 Prasanth pc. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImagesToCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImagesToCell() {
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        imageView.backgroundColor = UIColor.clear
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
}
