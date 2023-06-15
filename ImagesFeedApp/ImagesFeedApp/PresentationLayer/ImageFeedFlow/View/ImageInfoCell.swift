//
//  ImageInfoCell.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import Foundation
import UIKit

final class ImageInfoCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ImageInfoCell.self)

    private let likeButton = UIButton()
    private let photoImage = UIImageView()
    private let likeQuestion = UILabel()
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
        contentView.addSubview(likeQuestion)
        contentView.addSubview(likeButton)

        photoImage.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeQuestion.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            likeButton.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: -10),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            likeQuestion.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            likeQuestion.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: -2),
            likeQuestion.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }

    private func setUpStyle() {
        photoImage.layer.cornerRadius = 14
        photoImage.clipsToBounds = true

        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .red
        likeButton.imageView?.contentMode = .scaleAspectFit

        likeQuestion.text = "Do you like this photo?"
        likeQuestion.textColor = .black
        likeQuestion.font = .boldSystemFont(ofSize: 15)
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
        guard let url = URL(string: model.urls.regular) else { return }
        photoImage.loadImage(from: url) { [weak self] image in
            self?.photoImage.image = image
        }
    }

    @objc private func likeButtonTapped() {
        onDidLike()
    }
}
