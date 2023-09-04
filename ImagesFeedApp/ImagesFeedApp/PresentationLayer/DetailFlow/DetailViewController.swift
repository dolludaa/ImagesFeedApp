//
//  DetailViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {

  private let photoModel: ImagesScreenModel
  private var detailModel: DetailImageModel?
  private let imageService: ImagesLoaderServiceProtocol
  private let detailView: DetailViewProtocol
  private let localStorage: LocalStorageProtocol

  init(
    photoModel: ImagesScreenModel,
    detailView: DetailViewProtocol,
    imageService: ImagesLoaderServiceProtocol,
    localStorage: LocalStorageProtocol
  ) {
    self.localStorage = localStorage
    self.photoModel = photoModel
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    localStorage.update()

    guard let detailModel else { return }
    configure(model: detailModel)
  }

  private func fetchPhotoDetails() {

    imageService.fetchInfo(photoID: photoModel.id) { [weak self] result in
      switch result {
      case .success(let photo):
        self?.configure(model: photo)
        self?.detailModel = photo
      case .failure(let error):
        print("Error fetching photo details: \(error)")
      }
    }
  }

  private func didLikeOrDislike() {

    localStorage.toggle(photoItem: photoModel)
    guard let detailModel else { return }
    configure(model: detailModel)
  }

  private func configure(model: DetailImageModel) {

    let isLiked = localStorage.isLiked(photoId: photoModel.id)

    detailView.configure(model: model, isLiked: isLiked) { [weak self] in
      self?.didLikeOrDislike()
    }

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
