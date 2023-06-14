//
//  DetailViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {

    var photoID = ""
    private let imageService = ImagesLoaderService()
    private let detailPhotoImage = UIImageView()
    private let userName = UILabel()
    private let creationDate = UILabel()
    private let location = UILabel()
    private let downloadsCount = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()
        fetchPhotoDetails()
    }

    private func setUpLayout() {
        view.addSubview(detailPhotoImage)
        view.addSubview(userName)
        view.addSubview(creationDate)
        view.addSubview(location)
        view.addSubview(downloadsCount)

        detailPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        creationDate.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        downloadsCount.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailPhotoImage.topAnchor.constraint(equalTo: view.topAnchor),
            detailPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailPhotoImage.heightAnchor.constraint(equalToConstant: 400),

            creationDate.topAnchor.constraint(equalTo: detailPhotoImage.bottomAnchor, constant: 10),
            creationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creationDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            userName.topAnchor.constraint(equalTo: creationDate.bottomAnchor, constant: 10),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            location.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            location.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            location.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            downloadsCount.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            downloadsCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            downloadsCount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }


    private func setUpStyle() {
        view.backgroundColor = .white

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

    private func fetchPhotoDetails() {
        imageService.fetchInfo(photoID: photoID) { [weak self] result in
            switch result {
            case .success(let photo):
                self?.configure(model: photo)
            case .failure(let error):
                print("Error fetching photo details: \(error)")
            }
        }
    }

    private func configure(model: DetailImageModel) {

        let dateString = model.createdAt

        userName.text = "Author: \(model.user.name)"
        location.text = "Location: \(model.user.location ?? "Unknown location")"
        downloadsCount.text = "People downloaded it: \(String(model.downloads)) times"
        guard let url = URL(string: model.urls.regular) else { return }
        detailPhotoImage.loadImage(from: url) { [weak self] image in
            self?.detailPhotoImage.image = image
        }

        if let formattedDate = formatDate(dateString) {
            creationDate.text = "Created at: \(formattedDate)".uppercased()
        } else {
            print("Invalid date string")
        }
    }

    func formatDate(_ dateString: String) -> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale(identifier: "en_US")
        dateFormatterOutput.dateFormat = "dd MMMM yyyy"

        if let date = dateFormatterInput.date(from: dateString) {
            return dateFormatterOutput.string(from: date)
        } else {
            return nil
        }
    }
}


