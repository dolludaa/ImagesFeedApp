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
    private let userName = UILabel()
    private let creationDate = UILabel()
    private let location = UILabel()
    private let downloadsCount = UILabel()

    private func setUpLayout() {
        addSubview(detailPhotoImage)
        addSubview(userName)
        addSubview(creationDate)
        addSubview(location)
        addSubview(downloadsCount)

        detailPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        creationDate.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        downloadsCount.translatesAutoresizingMaskIntoConstraints = false

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
            downloadsCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setUpStyle() {
        backgroundColor = .white

        detailPhotoImage.layer.cornerRadius = 30
        detailPhotoImage.clipsToBounds = true
        detailPhotoImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        userName.font = .italicSystemFont(ofSize: 15)
        userName.textColor = .black
        creationDate.font = .systemFont(ofSize: 15)
        creationDate.textColor = .darkGray

        location.font = .systemFont(ofSize: 15)
        location.textColor = .black

        downloadsCount.font = .systemFont(ofSize: 15)
        downloadsCount.textColor = .black

    }
}

extension DetailView: DetailViewProtocol {
    func configure(model: DetailImageModel) {
        let dateString = model.createdAt

        userName.text = "Author: \(model.user.name)"
        location.text = "Location: \(model.user.location ?? "Unknown location")"
        downloadsCount.text = "People downloaded it: \(String(model.downloads)) times"
        guard let url = URL(string: model.urls.regular) else { return }
        detailPhotoImage.loadImage(from: url) { [weak self] image in
            self?.detailPhotoImage.image = image
        }

        if let formattedDate = delegate?.formatDate(dateString) {
            creationDate.text = "Created at: \(formattedDate)".uppercased()
        } else {
            print("Invalid date string")
        }
    }
    func didLoad() {
        setUpLayout()
        setUpStyle()
    }
}
