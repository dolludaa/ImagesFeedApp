//
//  FavoriteImageCell.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class FavoriteImageCell: UITableViewCell, FavoriteImageCellProtocol {

  static let reuseIdentifier = String(describing: FavoriteImageCell.self)

  private let likeButton = UIButton()
  private let photoImage = UIImageView()
  private var authorName = UILabel()
  private var photoID: String?
  private var onDidLike = {}

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setUpStyle()
    setUp()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    photoImage.image = nil
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupLayout() {
    contentView.addSubview(photoImage)
    contentView.addSubview(likeButton)
    contentView.addSubview(authorName)

    photoImage.translatesAutoresizingMaskIntoConstraints = false
    likeButton.translatesAutoresizingMaskIntoConstraints = false
    authorName.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      photoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      photoImage.widthAnchor.constraint(equalToConstant: 150),

      authorName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      authorName.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 15),
      authorName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

      likeButton.topAnchor.constraint(equalTo: authorName.bottomAnchor, constant: 30),
      likeButton.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 20)
    ])
  }

  private func setUpStyle() {

    backgroundColor = UIColor(named: "backgroundColor")

    likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    likeButton.tintColor = .red
    likeButton.imageView?.contentMode = .scaleAspectFit
    likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

    photoImage.layer.cornerRadius = 14
    photoImage.clipsToBounds = true
    photoImage.contentMode = .scaleAspectFill

    authorName.font = .boldSystemFont(ofSize: 20)
    authorName.textColor = UIColor(named: "secondaryTextColor")
  }

  private func setUp() {
    likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
  }

  func configure(model: ImagesScreenModel, isLiked: Bool, onDidLike: @escaping () -> Void) {
    if isLiked {
      likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red), for: .normal)
    } else {
      likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    self.onDidLike = onDidLike
    photoID = model.id
    authorName.text = model.user.name
    guard let url = URL(string: model.urls.regular) else { return }
    photoImage.kf.setImage(with: url)
  }

  @objc private func likeButtonTapped() {
    onDidLike()
  }
}
