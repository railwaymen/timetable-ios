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
        return image ?? #imageLiteral(resourceName: "profile_icon")
    }()
    
    static let delete: UIImage = {
        let image = UIImage(systemName: "trash.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "icon-trash")
    }()
    
    static let duplicate: UIImage = {
        let image = UIImage(systemName: "doc.on.doc.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "add-icon")
    }()
     
    static let history: UIImage = #imageLiteral(resourceName: "history_icon")
    
    static let plus: UIImage = {
        let image = UIImage(systemName: "plus.circle.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "add-icon")
    }()
}
