//
//  String+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isHTTP: Bool {
        let httpRegExp = try? NSRegularExpression(pattern: "^http://", options: .caseInsensitive)
        guard let regExp = httpRegExp else { return false }
        return regExp.matches(in: self).count == 1
    }
    
    var isHTTPS: Bool {
        let httpRegExp = try? NSRegularExpression(pattern: "^https://", options: .caseInsensitive)
        guard let regExp = httpRegExp else { return false }
        return regExp.matches(in: self).count == 1
    }
    
    func apiSuffix() -> String {
        let slashRegExp = try? NSRegularExpression(pattern: "/$", options: .caseInsensitive)
        let apiRegExp = try? NSRegularExpression(pattern: "(?:^|\\W)api(?:$|\\W)", options: .caseInsensitive)
        
        if let regExp = apiRegExp, regExp.matches(in: self).count > 0,
            let firstPart = self.components(separatedBy: "api").first {
            return firstPart.apiSuffix()
        } else if let regExp = slashRegExp, regExp.matches(in: self).count > 0 {
            return self + "api"
        }
        return (self + "/api").apiSuffix()
    }
    
    func httpPrefix() -> String {
        let httpRegExp = try? NSRegularExpression(pattern: "^(http|https)://", options: .caseInsensitive)
        guard let regExp = httpRegExp, regExp.matches(in: self).count == 0 else {
            return self
        }
        return "https://" + self
    }
}
