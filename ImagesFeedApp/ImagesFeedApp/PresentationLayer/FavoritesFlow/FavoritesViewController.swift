//
//  FavoritesViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class FavoritesViewController: UIViewController {

  private let imagesService: ImagesLoaderServiceProtocol
  private let localStorage: LocalStorageProtocol
  private var photos: [ImagesScreenModel] = []

  private let detailView: FavoritesViewProtocol

  init(
    detailView: FavoritesViewProtocol,
    imagesService: ImagesLoaderServiceProtocol,
    localStorage: LocalStorageProtocol
  ) {
    self.detailView = detailView
    self.imagesService = imagesService
    self.localStorage = localStorage
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
    detailView.didLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    localStorage.update()
    photos = localStorage.getSavedPhotos()
    detailView.reloadData()
  }

  private func didLikeOrDislike(indexPath: IndexPath) {
    let photoModel = photos[indexPath.row]
    localStorage.toggle(photoItem: photoModel)
    detailView.reloadRows(at: [indexPath])
  }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: FavoriteImageCell.reuseIdentifier,
      for: indexPath)
            as? FavoriteImageCell else {
      fatalError("The dequeued cell is not an instance of FavoriteImageCell.")
    }
    let photoItem = photos[indexPath.row]
    let isLiked = localStorage.isLiked(photoId: photoItem.id)
    cell.configure(model: photoItem, isLiked: isLiked) { [weak self] in
      self?.didLikeOrDislike(indexPath: indexPath)
    }
    cell.selectionStyle = .none
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPhoto = photos[indexPath.row]
    let detailViewController = DetailViewControllerAssembly().create(
      photoModel: selectedPhoto,
      imageService: imagesService,
      localStorage: LocalStorage()
    )

    let alert = UIAlertController(
      title: "Navigate",
      message: "Do you really want to go to the detail screen?",
      preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let navigateAction = UIAlertAction(title: "Navigate", style: .default) { [weak self] _ in
      self?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    alert.addAction(cancelAction)
    alert.addAction(navigateAction)

    self.present(alert, animated: true, completion: nil)
  }
}

extension FavoritesViewController: FavoritesViewControllerDelegate { }
