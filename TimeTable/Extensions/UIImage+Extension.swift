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
        var image: UIImage = #imageLiteral(resourceName: "project_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "rectangle.grid.2x2.fill") {
            image = sfSymbol
        }
        return image
    }()
    
    static let timesheet: UIImage = {
        var image: UIImage = #imageLiteral(resourceName: "work_times_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "clock.fill") {
            image = sfSymbol
        }
        return image
    }()
    
    static let profile: UIImage = {
        var image: UIImage = #imageLiteral(resourceName: "profile_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "person.fill") {
            image = sfSymbol
        }
        return image
    }()
    
    static let delete: UIImage = {
        var image: UIImage = #imageLiteral(resourceName: "icon-trash")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "trash.fill") {
            image = sfSymbol
        }
        return image
    }()
    
    static let duplicate: UIImage = {
        var image: UIImage = #imageLiteral(resourceName: "add-icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "doc.on.doc.fill") {
            image = sfSymbol
        }
        return image
    }()
}
