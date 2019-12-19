//
//  PinterestLayout.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 01.12.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewFlowLayout {

    weak var delegate: PinterestLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {

        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        //self.cache.removeAll()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            // offset for section header
            if item == 0 || item == 1 {
                yOffset[column] = yOffset[column] + 30
            }
            
            let indexPath = IndexPath(item: item, section: 0)

            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 100
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        return layoutAttributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutAttributesInRect = super.layoutAttributesForElements(in: rect) else { return nil }
        var visibleLayoutsAttributes: [UICollectionViewLayoutAttributes] = []

        /*
        for (indexOfAttributesSet, attributesOfItem) in layoutAttributesInRect.enumerated() {
            
            if attributesOfItem.representedElementCategory == .supplementaryView {
                // add header and footer attributes
                visibleLayoutsAttributes.append(attributesOfItem)
                
            } else if attributesOfItem.representedElementCategory == .cell {
                // add cell attributes, omit header
                visibleLayoutsAttributes.append(cache[indexOfAttributesSet])
            }
 
        }
        */

        if let sectionHeaderAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) {
            visibleLayoutsAttributes.append(sectionHeaderAttributes)
        }
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutsAttributes.append(attributes)
            }
        }
        
        print("visible.attr.count", visibleLayoutsAttributes.count)
        return visibleLayoutsAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func invalidateLayout() {
        self.cache.removeAll()
        super.invalidateLayout()
    }
}
