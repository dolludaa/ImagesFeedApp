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
    private let imageService = ImagesLoaderService()
    private var photoID: String?
    private var onDidLike = {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setUpStyle()
        setUp()
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
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            photoImage.widthAnchor.constraint(equalToConstant: 100),

            authorName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            authorName.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 15),

            likeButton.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: -5),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setUpStyle() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .red
        likeButton.imageView?.contentMode = .scaleAspectFit

        photoImage.layer.cornerRadius = 14
        photoImage.clipsToBounds = true

        authorName.font = .boldSystemFont(ofSize: 20)
        authorName.textColor = .darkGray
    }

    private func setUp() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    func configure(model: ImagesScreenModel, isLiked: Bool, onDidLike: @escaping () -> Void ) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.onDidLike = onDidLike
        photoID = model.id
        authorName.text = model.user.name
        guard let url = URL(string: model.urls.regular) else { return }
        photoImage.loadImage(from: url) { [weak self] image in
            self?.photoImage.image = image
        }
    }

    @objc private func likeButtonTapped() {
        onDidLike()
    }
}
