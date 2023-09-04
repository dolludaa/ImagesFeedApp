//
//  ImageInfoCell.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import Foundation
import UIKit
import Kingfisher

final class ImageInfoCell: UICollectionViewCell, ImageInfoCellProtocol {

  static let reuseIdentifier = String(describing: ImageInfoCell.self)

  private let photoImage = UIImageView()
  private var photoID: String?

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupLayout()
    setUpStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    photoImage.image = nil
  }

  private func setupLayout() {
    contentView.addSubview(photoImage)

    photoImage.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      photoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }

  private func setUpStyle() {
    photoImage.layer.cornerRadius = 14
    photoImage.clipsToBounds = true
    photoImage.contentMode = .scaleAspectFill
  }

  func configure(model: ImagesScreenModel ) {
    photoID = model.id
    guard let url = URL(string: model.urls.regular) else { return }
    photoImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
  }
}
