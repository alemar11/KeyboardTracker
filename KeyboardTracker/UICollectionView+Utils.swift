//
//  UICollectionView+Utils.swift
//  Experiment-AccessoryInputBar
//
//  Created by Alessandro Marzoli on 24/01/2019.
//  Copyright © 2019 Alessandro Marzoli. All rights reserved.
//

import UIKit

public enum Constants {
  public static let animationDuration: TimeInterval = 0.33
  public static let threshold: CGFloat = 0.05 // in [0, 1]
}

extension UICollectionView {
  var availableWidth: CGFloat {
    if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
      return bounds.width - flowLayout.sectionInset.horizontal
    } else {
      return bounds.width
    }
  }
}

// MARK: - Position

extension CGFloat {
  static let epsilon: CGFloat = 0.001
}

extension UICollectionView {

  public enum VerticalEdge {
    case top
    case bottom
  }

  public func isScrolledAtBottom() -> Bool {
    guard numberOfSections > 0 && numberOfItems(inSection: 0) > 0 else { return true }

    let sectionIndex = numberOfSections - 1
    let itemIndex = numberOfItems(inSection: sectionIndex) - 1
    let lastIndexPath = IndexPath(item: itemIndex, section: sectionIndex)

    return self.isIndexPathVisible(lastIndexPath, atEdge: .bottom)
  }

  public func isScrolledAtTop() -> Bool {
    guard numberOfSections > 0 && numberOfItems(inSection: 0) > 0 else { return true }

    let firstIndexPath = IndexPath(item: 0, section: 0)

    return self.isIndexPathVisible(firstIndexPath, atEdge: .top)
  }

  public func isCloseToTop(threshold: CGFloat = Constants.threshold) -> Bool {
    guard contentSize.height > 0 else { return true }

    let result = (visibleRect.minY / contentSize.height) < threshold

    return result
  }

  public func isCloseToBottom(threshold: CGFloat = Constants.threshold) -> Bool {
    guard contentSize.height > 0 else { return true }

    let result = (visibleRect.maxY / contentSize.height) > (1 - threshold)

    return result
  }

  public var visibleRect: CGRect {
    let rect = CGRect(x: CGFloat(0),
                      y: contentOffset.y + contentInset.top,
                      width: bounds.width,
                      height: min(collectionViewLayout.collectionViewContentSize.height, bounds.height - contentInset.top - contentInset.bottom))

    return rect
  }

  func rectForItem(at indexPath: IndexPath) -> CGRect? {
    return collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
  }

  public func isIndexPathVisible(_ indexPath: IndexPath, atEdge edge: VerticalEdge) -> Bool {
    guard let attributes = collectionViewLayout.layoutAttributesForItem(at: indexPath) else { return false }

    let visibleRect = self.visibleRect
    let intersection = visibleRect.intersection(attributes.frame)
    if edge == .top {
      return abs(intersection.minY - attributes.frame.minY) < CGFloat.epsilon
    } else {
      return abs(intersection.maxY - attributes.frame.maxY) < CGFloat.epsilon
    }
  }

}

// MARK: - Scroll

extension UICollectionView {

  public func scrollToBottom(animated: Bool) {
    // Cancel current scrolling
    setContentOffset(contentOffset, animated: false)

    let lineSpacing: CGFloat
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      lineSpacing = layout.minimumLineSpacing
    } else {
      lineSpacing = CGFloat(0)
    }

    // Note that we don't rely on collectionView's contentSize. This is because it won't be valid after performBatchUpdates or reloadData
    // After reload data, collectionViewLayout.collectionViewContentSize won't be even valid, so you may want to refresh the layout manually
    let offsetY = max(-contentInset.top, collectionViewLayout.collectionViewContentSize.height - bounds.height + contentInset.bottom + lineSpacing)

    // Don't use setContentOffset(:animated). If animated, contentOffset property will be updated along with the animation for each frame update
    // If a message is inserted while scrolling is happening (as in very fast typing), we want to take the "final" content offset (not the "real time" one) to check if we should scroll to bottom again
    if animated {
      UIView.animate(withDuration: Constants.animationDuration) {
        self.contentOffset = CGPoint(x: 0, y: offsetY)
      }
    } else {
      contentOffset = CGPoint(x: 0, y: offsetY)
    }
  }

  public func scrollToPreservePosition(oldRefRect: CGRect?, newRefRect: CGRect?) {
    guard let oldRefRect = oldRefRect, let newRefRect = newRefRect else {
      return
    }

    let diffY = newRefRect.minY - oldRefRect.minY
    contentOffset = CGPoint(x: 0, y: contentOffset.y + diffY)
  }

}

