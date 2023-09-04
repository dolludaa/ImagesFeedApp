//
//  ImageFeedView.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

final class ImageFeedView: UIView {

  weak var delegate: ImagesFeedViewControllerDelegate?

  lazy var collectionLayout = UICollectionViewFlowLayout()
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)

  private func setUpLayout() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12)
    ])
  }

  private func setUpStyle() {
    backgroundColor = UIColor(named: "backgroundColor")

    delegate?.title = "Images"

    collectionView.delegate = delegate
    collectionView.dataSource = delegate
    collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.reuseIdentifier)

    collectionView.backgroundColor = UIColor(named: "backgroundColor")
    collectionView.layer.cornerRadius = 9
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    collectionLayout.minimumLineSpacing = 10
    collectionLayout.minimumInteritemSpacing = 10

  }
}

extension ImageFeedView: ImageFeedViewProtocol {
  func reloadTableContent() {
    collectionView.reloadData()
  }

  func reloadRows(indexPath: IndexPath) {
    collectionView.reloadItems(at: [indexPath])
  }

  func didLoad() {
    setUpLayout()
    setUpStyle()
  }
}
