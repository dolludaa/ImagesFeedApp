//
//  FavoriteImageCell.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class FavoriteImageCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FavoriteImageCell.self)

    private let likeButton = UIButton()
    private let photoImage = UIImageView()
    private let imageService = ImagesLoaderService()
    private var photoID: String?

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

        photoImage.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            photoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            photoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            photoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

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

    }

    private func setUp() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    func configure(model: ImagesScreenModel) {
        guard let url = URL(string: model.urls.regular) else { return }
        photoImage.loadImage(from: url) { [weak self] image in
            self?.photoImage.image = image
        }
        photoID = model.id
    }

    @objc private func likeButtonTapped() {
        guard let photoID = photoID else { return }
        likeButton.isSelected = !likeButton.isSelected

        if likeButton.isSelected {
            likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red), for: .normal)
            imageService.likePhoto(photoID: photoID) { result in
                switch result {
                case .success:
                    print("Photo liked successfully")
                case .failure(let error):
                    print("Failed to like photo: \(error)")
                }
            }
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            imageService.unlikePhoto(photoID: photoID) { result in
                switch result {
                case .success:
                    print("Photo unliked successfully")
                case .failure(let error):
                    print("Failed to unlike photo: \(error)")
                }
            }
        }
    }
}
