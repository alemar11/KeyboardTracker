//
//  UIEdgeInset+Utils.swift
//  Experiment-AccessoryInputBar
//
//  Created by Alessandro Marzoli on 24/01/2019.
//  Copyright © 2019 Alessandro Marzoli. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

  internal var vertical: CGFloat {
    return top + bottom
  }

  internal var horizontal: CGFloat {
    return left + right
  }

}
