//
//  KeyboardTracker.swift
//  KeyboardTracker
//
//  Created by Alessandro Marzoli on 25/01/2019.
//  Copyright © 2019 Alessandro Marzoli. All rights reserved.
//

import UIKit

protocol KeyboardTrackerDelegate: class {
  func keyboardTracker(_: KeyboardTracker, didChangeOrigin: CGPoint)
}

final class KeyboardTracker {

  weak var delegate: KeyboardTrackerDelegate?
  private let notificationCenter = NotificationCenter.default
  private var isTracking = false

  var trackingView: UIView {
    return keyboardTrackingView
  }

  private lazy var keyboardTrackingView: KeyboardTrackingView = {
    let trackingView = KeyboardTrackingView()

    trackingView.onOriginPositionChanged = { [weak self] origin in
      guard let self = self else { return }

      self.delegate?.keyboardTracker(self, didChangeOrigin: origin)
    }

    return trackingView
  }()

  init() { }

  deinit {
    stopTracking()
  }

  func startTracking() {
    isTracking = true
  }

  func stopTracking() {
    isTracking = false
  }

}

// MARK: - Keyboard Tracking View

private final class KeyboardTrackingView: UIView {

  var onOriginPositionChanged: ((CGPoint) -> Void)?

  private var observationToken: NSKeyValueObservation?
  private var observedView: UIView?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    autoresizingMask = .flexibleHeight
    isUserInteractionEnabled = false
    backgroundColor = .clear
    isHidden = true
  }

  override func willMove(toSuperview newSuperview: UIView?) {
    observationToken = nil
    observedView = nil

    guard let newSuperview = newSuperview else {
      return
    }

    observationToken = newSuperview.observe(\.center, options: [.new, .old]) { [weak self] (view, change) in
      guard let self = self else { return }
      guard let superview = self.superview else { return }
      guard view === superview else { return }

      let oldCenter = change.oldValue
      let newCenter = change.newValue

      if oldCenter != newCenter {
        self.onOriginPositionChanged?(view.frame.origin)
      }

    }

    observedView = newSuperview

    super.willMove(toSuperview: newSuperview)
  }

}
