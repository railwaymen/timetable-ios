//
//  ProjectsCollectionViewLayout.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectsCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForUsersTableViewAtIndexPath indexPath: IndexPath) -> CGFloat
}

class ProjectsCollectionViewLayout: UICollectionViewFlowLayout {
    weak var delegate: ProjectsCollectionViewLayoutDelegate?
    
    private let minWidthForCell: CGFloat = 300
    private let cellPadding: CGFloat = 5
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    // MARK: - Overridden
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        guard self.cache.isEmpty else { return }
        self.resizeView()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cache.reduce([UICollectionViewLayoutAttributes](), { $1.frame.intersects(rect) ? $0 + [$1] : $0 })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        self.resizeView()
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.cache.removeAll()
    }
}

// MARK: - Private
extension ProjectsCollectionViewLayout {
    private func resizeView() {
        guard let collectionView = self.collectionView else { return }
        
        let numberOfItemsPerRow = Int(collectionView.frame.width) / Int(self.minWidthForCell)
        let widthPerItem = self.contentWidth / CGFloat(numberOfItemsPerRow)
        var xOffset = [CGFloat]()
        (0..<numberOfItemsPerRow).forEach { xOffset.append(CGFloat($0) * widthPerItem) }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfItemsPerRow)
        
        var contentHeight: CGFloat = 0
        (0..<collectionView.numberOfItems(inSection: 0)).forEach {
            let indexPath = IndexPath(item: $0, section: 0)
            let tableViewHeight = self.delegate?.collectionView(collectionView, heightForUsersTableViewAtIndexPath: indexPath) ?? 0
            let height = self.cellPadding * 2 + tableViewHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: widthPerItem, height: height)
            let insetFrame = frame.insetBy(dx: self.cellPadding, dy: self.cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfItemsPerRow - 1) ? (column + 1) : 0
        }
        self.contentHeight = contentHeight
    }
}
