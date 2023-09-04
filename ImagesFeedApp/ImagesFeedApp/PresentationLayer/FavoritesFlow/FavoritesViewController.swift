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
  private var isUpdating = false

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
    addObservers()
    updateLikesData()
  }

  private func didDislike(indexPath: IndexPath) {
    isUpdating = true

    let photoModel = photos.remove(at: indexPath.row)
    localStorage.unlikePhoto(photoItem: photoModel)
    detailView.deleteRows(at: [indexPath])

    isUpdating = false
  }

  private func presentNavigationAlert(completion: @escaping () -> Void) {
    let alert = UIAlertController(
      title: "Navigate",
      message: "Do you really want to go to the detail screen?",
      preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let navigateAction = UIAlertAction(title: "Navigate", style: .default) { _ in
      completion()
    }

    alert.addAction(cancelAction)
    alert.addAction(navigateAction)

    self.present(alert, animated: true, completion: nil)
  }

  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateLikesData),
      name: .didUpdateLikes,
      object: nil)
  }

  @objc private func updateLikesData() {
    guard !isUpdating else { return }

    localStorage.update()
    photos = localStorage.getSavedPhotos()
    detailView.reloadData()
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
      self?.didDislike(indexPath: indexPath)
    }
    cell.selectionStyle = .none
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presentNavigationAlert { [weak self] in
      guard let self else { return }
      let selectedPhoto = self.photos[indexPath.row]
      let detailViewController = DetailViewControllerAssembly().create(
        photoModel: selectedPhoto,
        imageService: self.imagesService,
        localStorage: LocalStorage()
      )
      self.navigationController?.pushViewController(detailViewController, animated: true)
    }
  }
}

extension FavoritesViewController: FavoritesViewControllerDelegate { }
