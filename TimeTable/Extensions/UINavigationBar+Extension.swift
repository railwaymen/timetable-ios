//
//  UINavigationBar+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setLargeTitleRightViews(_ views: [UIView]) {
        guard let UINavigationBarLargeTitleView = NSClassFromString("_UINavigationBarLargeTitleView") else { return }
        guard let largeTitleView = self.subviews.first(where: {
            $0.isKind(of: UINavigationBarLargeTitleView.self)
        }) else { return }
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        largeTitleView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(
                equalTo: largeTitleView.safeAreaLayoutGuide.trailingAnchor,
                constant: -16),
            stackView.bottomAnchor.constraint(
                equalTo: largeTitleView.bottomAnchor,
                constant: -6),
            stackView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
