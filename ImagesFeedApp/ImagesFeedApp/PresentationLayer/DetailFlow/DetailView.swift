//
//  DetailView.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

final class DetailView: UIView {

  weak var delegate: DetailViewControllerDelegate?

  private let detailPhotoImage = UIImageView()
  private let likeButton = UIButton()
  private let likeQuestion = UILabel()
  private let userName = UILabel()
  private let creationDate = UILabel()
  private let location = UILabel()
  private let downloadsCount = UILabel()

  private var onDidLike = {}

  private func setUpLayout() {
    addSubview(detailPhotoImage)
    addSubview(userName)
    addSubview(creationDate)
    addSubview(location)
    addSubview(downloadsCount)
    addSubview(likeButton)
    addSubview(likeQuestion)

    detailPhotoImage.translatesAutoresizingMaskIntoConstraints = false
    userName.translatesAutoresizingMaskIntoConstraints = false
    creationDate.translatesAutoresizingMaskIntoConstraints = false
    location.translatesAutoresizingMaskIntoConstraints = false
    downloadsCount.translatesAutoresizingMaskIntoConstraints = false
    likeButton.translatesAutoresizingMaskIntoConstraints = false
    likeQuestion.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      detailPhotoImage.topAnchor.constraint(equalTo: topAnchor),
      detailPhotoImage.leadingAnchor.constraint(equalTo: leadingAnchor),
      detailPhotoImage.trailingAnchor.constraint(equalTo: trailingAnchor),
      detailPhotoImage.heightAnchor.constraint(equalToConstant: 400),

      creationDate.topAnchor.constraint(equalTo: detailPhotoImage.bottomAnchor, constant: 10),
      creationDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      creationDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

      userName.topAnchor.constraint(equalTo: creationDate.bottomAnchor, constant: 10),
      userName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

      location.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
      location.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      location.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

      downloadsCount.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
      downloadsCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      downloadsCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

      likeQuestion.topAnchor.constraint(equalTo: downloadsCount.bottomAnchor, constant: 50),
      likeQuestion.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

      likeButton.topAnchor.constraint(equalTo: downloadsCount.bottomAnchor, constant: 50),
      likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
    ])
  }

  private func setUpStyle() {

    backgroundColor = UIColor(named: "backgroundColor")

    detailPhotoImage.layer.cornerRadius = 30
    detailPhotoImage.clipsToBounds = true
    detailPhotoImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    detailPhotoImage.contentMode = .scaleAspectFill

    userName.font = .italicSystemFont(ofSize: 15)
    userName.textColor = UIColor(named: "secondaryTextColor")

    creationDate.font = .systemFont(ofSize: 15)
    creationDate.textColor = UIColor(named: "primaryTextColor")

    location.font = .systemFont(ofSize: 15)
    location.textColor = UIColor(named: "secondaryTextColor")

    downloadsCount.font = .systemFont(ofSize: 15)
    downloadsCount.textColor = UIColor(named: "secondaryTextColor")

    likeButton.setImage(UIImage(systemName: "star"), for: .normal)
    likeButton.tintColor = .red
    likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

    likeQuestion.text = "Add this photo to Favourites"
    likeQuestion.textColor = UIColor(named: "secondaryTextColor")
    likeQuestion.font = .boldSystemFont(ofSize: 15)
  }

  private func setUp() {

    likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
  }

  @objc private func likeButtonTapped() {

    onDidLike()
  }
}

extension DetailView: DetailViewProtocol {

  func configure(model: DetailImageModel, isLiked: Bool, onDidLike: @escaping () -> Void) {

    if isLiked {
      likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red), for: .normal)
    } else {
      likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    self.onDidLike = onDidLike

    let dateString = model.createdAt

    userName.text = "Author: \(model.user.name)"
    location.text = "Location: \(model.user.location ?? "Unknown location")"
    downloadsCount.text = "People downloaded it: \(String(model.downloads)) times"
    guard let url = URL(string: model.urls.regular) else { return }
    detailPhotoImage.kf.setImage(with: url)

    if let formattedDate = delegate?.formatDate(dateString) {
      creationDate.text = "Created at: \(formattedDate)".uppercased()
    } else {
      print("Invalid date string")
    }
  }
  func didLoad() {
    setUpLayout()
    setUpStyle()
    setUp()
  }
}
