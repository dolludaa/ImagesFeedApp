//
//  DetailViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {

    private let photoID: String
    private let imageService: ImagesLoaderServiceProtocol
    private let detailView: DetailViewProtocol

    init(
        photoID: String,
        detailView: DetailViewProtocol,
        imageService: ImagesLoaderServiceProtocol
    ) {
        self.photoID = photoID
        self.detailView = detailView
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotoDetails()
        detailView.didLoad()
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
        detailView.configure(model: model)
    }
}

extension DetailViewController: DetailViewControllerDelegate {
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
