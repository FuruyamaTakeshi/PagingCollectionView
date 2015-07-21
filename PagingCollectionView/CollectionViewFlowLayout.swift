//
//  CollectionViewFlowLayout.swift
//  UICollectionView
//
//  Created by Furuyama Takeshi on 2015/07/04.
//  Copyright (c) 2015年 Furuyama Takeshi All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
   
    override func collectionViewContentSize() -> CGSize {
        // Only support single section for now.
        // Only support Horizontal scroll
        let canvasSize = self.collectionView!.frame.size
        var contentSize = canvasSize
        let cellSize = CGSizeMake(96.0, 96.0)
        
        if (self.scrollDirection == UICollectionViewScrollDirection.Horizontal) {
            let rowCount = floor((canvasSize.height - cellSize.height) / (cellSize.height + self.minimumInteritemSpacing) + 1)
            var columnletCount = floor((canvasSize.width - cellSize.width) / (cellSize.width + self.minimumLineSpacing) + 1)
            
            if let count = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: 0) {
                let itemCont = rowCount * columnletCount
                let page = ceil(CGFloat(count)/itemCont)
                contentSize = CGSizeMake(page * canvasSize.width, contentSize.height)
            }
            
        }
        return contentSize;
    }

    private func frameForItemAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        let canvasSize = self.collectionView?.frame.size ?? CGSizeZero

        let rowCount =  floor((canvasSize.height - self.sectionInset.top - self.sectionInset.bottom) / (self.itemSize.height + self.minimumInteritemSpacing))
        let columnCont = floor((canvasSize.width - self.sectionInset.left - self.sectionInset.right) / (self.itemSize.width + self.minimumLineSpacing))

        let pageMarginX = (canvasSize.width - columnCont * self.itemSize.width - (columnCont > 1 ? (columnCont - 1) * self.minimumLineSpacing : 0)) / 2.0
        let pageMarginY = (canvasSize.height - rowCount * self.itemSize.height - (rowCount > 1 ? (rowCount - 1) * self.minimumInteritemSpacing : 0)) / 2.0
        
        let pageIndex = indexPath.row%Int(rowCount * columnCont)
        let row     = pageIndex % Int(rowCount)
        let column  = pageIndex / Int(rowCount)
        
        var cellFrame = CGRectZero
        cellFrame.origin.x  = pageMarginX + CGFloat(column) * (self.itemSize.width + self.minimumLineSpacing)
        cellFrame.origin.y  = pageMarginY + CGFloat(row) * (self.itemSize.height + self.minimumInteritemSpacing)
        cellFrame.size.width    = self.itemSize.width
        cellFrame.size.height   = self.itemSize.height
        
        if (self.scrollDirection == UICollectionViewScrollDirection.Horizontal) {
            let page = floor(CGFloat(indexPath.row)/(rowCount * columnCont))
            cellFrame.origin.x += canvasSize.width * page
        }
        
        return cellFrame
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attr = super.layoutAttributesForItemAtIndexPath(indexPath)
        attr.frame = self.frameForItemAtIndexPath(indexPath)
        return attr
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attrs = [AnyObject]()
        if let originAttrs = super.layoutAttributesForElementsInRect(rect) {
            for var index = 0; index < self.collectionView?.numberOfItemsInSection(0); index++ {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                let itemFrame = self.frameForItemAtIndexPath(indexPath)
                if CGRectIntersectsRect(itemFrame, rect) {
                    let attr = self.layoutAttributesForItemAtIndexPath(indexPath)
                    attrs.append(attr)
                }
            }
        }
        return attrs
    }
}
