//
//  ViewController.swift
//  KeyboardTracker
//
//  Created by Alessandro Marzoli on 25/01/2019.
//  Copyright © 2019 Alessandro Marzoli. All rights reserved.
//

import UIKit

class TrackedView: UIView {

  override var inputAccessoryView: UIView? {
    return dummyView
  }

  var dummyView: UIView?
}

extension ViewController: KeyboardTrackerDelegate {

  func keyboardTracker(_: KeyboardTracker, didChangeOrigin point: CGPoint) {
    bottom = view.frame.size.height - point.y

    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
}

class ViewController: UIViewController {

  private let cellId = "cellId"
  private let containerViewHeight = CGFloat(50)

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: view.bounds.width, height: 200)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.keyboardDismissMode = .interactive
    collectionView.alwaysBounceVertical = true
    collectionView.showsVerticalScrollIndicator = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.allowsSelection = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.delegate = self
    collectionView.dataSource = self

    return collectionView
  }()

  var keyboardTracker: KeyboardTracker!

  lazy var inputContainerView: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .green
    return view
  }()

  override func loadView() {
    view = TrackedView()
    view.backgroundColor = .white
  }

  var bottom: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      ])

    view.addSubview(inputContainerView)
    bottom = view.safeAreaInsets.bottom

    let textField = UITextField()
    textField.backgroundColor = .blue
    textField.placeholder = "Test"
    textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    inputContainerView.addSubview(textField)

    keyboardTracker = KeyboardTracker()
    keyboardTracker.delegate = self

    (self.view as? TrackedView)?.dummyView = keyboardTracker?.trackingView
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    let maxBottom = max(view.safeAreaInsets.bottom, bottom)
    let origin = CGPoint(x: 0, y: view.bounds.height - containerViewHeight - maxBottom)
    let size = CGSize(width: view.bounds.width , height: containerViewHeight)

    inputContainerView.frame = CGRect(origin: origin, size: size)
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.keyboardTracker?.startTracking()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.scrollToBottom(animated: false)
  }

}

extension ViewController: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 300
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    cell.contentView.backgroundColor = .black
    return cell
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

}

extension ViewController: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.availableWidth, height: [20, 40, 80, 120].randomElement()!)
  }

}
