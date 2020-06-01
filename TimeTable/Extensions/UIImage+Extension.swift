//
//  UIImage+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

extension UIImage {
    static let profile: UIImage = {
        let image = UIImage(systemName: "person.crop.circle")
        assert(image != nil)
        return image ?? UIImage()
    }()
    
    static let delete: UIImage = {
        let image = UIImage(systemName: "trash.fill")
        assert(image != nil)
        let resizedImage = image?.aspectFit(toHeight: 29).withRenderingMode(.alwaysTemplate)
        return resizedImage ?? UIImage()
    }()
    
    static let duplicate: UIImage = {
        let image = UIImage(systemName: "doc.on.doc.fill")
        assert(image != nil)
        let resizedImage = image?.aspectFit(toHeight: 29).withRenderingMode(.alwaysTemplate)
        return resizedImage ?? UIImage()
    }()
     
    static let history: UIImage = {
        let image = #imageLiteral(resourceName: "history_icon")
        let resizedImage = image.aspectFit(toHeight: 30).withRenderingMode(.alwaysTemplate)
        return resizedImage
    }()
    
    static let plus: UIImage = {
        let image = UIImage(systemName: "plus.circle.fill")
        assert(image != nil)
        return image ?? UIImage()
    }()
    
    // MARK: - Internal
    func aspectFit(toHeight newHeight: CGFloat) -> UIImage {
        let aspectRatio = self.size.width / self.size.height
        let newWidth = aspectRatio * newHeight
        return self.resized(to: CGSize(width: newWidth, height: newHeight))
    }
    
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
