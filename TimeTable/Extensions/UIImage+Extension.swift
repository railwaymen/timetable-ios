//
//  UIImage+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

extension UIImage {
    static let projects: UIImage = {
        var image = UIImage(systemName: "rectangle.grid.2x2.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "project_icon")
    }()
    
    static let timesheet: UIImage = {
        var image = UIImage(systemName: "clock.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "work_times_icon")
    }()
    
    static let profile: UIImage = {
        var image = UIImage(systemName: "person.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "profile_icon")
    }()
    
    static let delete: UIImage = {
        var image = UIImage(systemName: "trash.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "icon-trash")
    }()
    
    static let duplicate: UIImage = {
        var image = UIImage(systemName: "doc.on.doc.fill")
        assert(image != nil)
        return image ?? #imageLiteral(resourceName: "add-icon")
    }()
     
    static let history: UIImage = #imageLiteral(resourceName: "history_icon")
}
