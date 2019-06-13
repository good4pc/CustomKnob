//
//  Extensions.swift
//  PlayLog
//
//  Created by Prasanth pc on 2019-04-01.
//  Copyright © 2019 Prasanth pc. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension CGFloat {
     func deg2rad() -> CGFloat {
        return self * .pi / 180
    }
    
    func radToDegree() -> CGFloat {
        return (self * 180) * .pi
    }
}

extension PHAsset {
    func getUIImage() -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: self, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}
