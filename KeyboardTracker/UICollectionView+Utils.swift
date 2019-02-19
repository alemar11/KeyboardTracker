//
//  UICollectionView+Utils.swift
//  Experiment-AccessoryInputBar
//
//  Created by Alessandro Marzoli on 24/01/2019.
//  Copyright © 2019 Alessandro Marzoli. All rights reserved.
//

import UIKit

extension UICollectionView {

  var availableWidth: CGFloat {
    if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
      let horizontal = flowLayout.sectionInset.left + flowLayout.sectionInset.right
      return bounds.width - horizontal
    } else {
      return bounds.width
    }
  }

  func scrollToBottom(animated: Bool) {
    setContentOffset(contentOffset, animated: false)

    let lineSpacing: CGFloat
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      lineSpacing = layout.minimumLineSpacing
    } else {
      lineSpacing = CGFloat(0)
    }

    let offsetY = max(-contentInset.top, collectionViewLayout.collectionViewContentSize.height - bounds.height + contentInset.bottom + lineSpacing)

    if animated {
      UIView.animate(withDuration: 0.33) {
        self.contentOffset = CGPoint(x: 0, y: offsetY)
      }
    } else {
      contentOffset = CGPoint(x: 0, y: offsetY)
    }
  }

}

