//
//  ImagesFeedViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import UIKit
import Foundation
import Kingfisher

class ImagesFeedViewController: UIViewController {

  private let imageFeedView: ImageFeedViewProtocol
  private let imagesService: ImagesLoaderServiceProtocol
  private let searchService: ImagesSearchServiceProtocol
  private let searchController = UISearchController(searchResultsController: nil)

  private var currentPage = 1
  private var totalPages = Int.max
  private var photos: [ImagesScreenModel] = []

  init(
    imageFeedView: ImageFeedViewProtocol,
    imagesService: ImagesLoaderServiceProtocol,
    searchService: ImagesSearchServiceProtocol
  ) {
    self.imageFeedView = imageFeedView
    self.imagesService = imagesService
    self.searchService = searchService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = imageFeedView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imageFeedView.didLoad()
    loadData()
    configureSearchController()
  }

  private func loadData() {
    guard currentPage <= totalPages else { return }
    imagesService.fetchImages(page: currentPage) { [weak self] result in
      switch result {
      case .success(let photos):
        self?.photos.append(contentsOf: photos)
        self?.imageFeedView.reloadTableContent()
        self?.currentPage += 1
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }

  private func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self

    navigationItem.searchController = searchController
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  private func navigateToDetail(photo: ImagesScreenModel) {
    let detailViewController = DetailViewControllerAssembly().create(
      photoModel: photo,
      imageService: imagesService,
      localStorage: LocalStorage()
    )
    navigationController?.pushViewController(detailViewController, animated: true)
  }

  private func presentNavigationAlert(for photo: ImagesScreenModel) {
    let alert = UIAlertController(
      title: "Navigate",
      message: "Do you really want to go to the detail screen?",
      preferredStyle: .alert
    )

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let navigateAction = UIAlertAction(title: "Navigate", style: .default) { [weak self] _ in
      self?.navigateToDetail(photo: photo)
    }

    alert.addAction(cancelAction)
    alert.addAction(navigateAction)

    present(alert, animated: true, completion: nil)
  }

  private func getCellSize() -> CGSize {
    let paddingSpace = 30.0
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / 2

    return CGSize(width: widthPerItem, height: widthPerItem)
  }

}

extension ImagesFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if indexPath.row == photos.count - 1 {
      loadData()
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ImageInfoCell.reuseIdentifier,
      for: indexPath) as? ImageInfoCell
    else {
      fatalError("The dequeued cell is not an instance of ImageInfoCell.")
    }
    let photoItem = photos[indexPath.row]

    cell.configure(model: photoItem)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {

      getCellSize()
    }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {

    let selectedPhoto = photos[indexPath.row]
    _ = DetailViewControllerAssembly().create(
      photoModel: selectedPhoto,
      imageService: imagesService,
      localStorage: LocalStorage()
    )

    presentNavigationAlert(for: selectedPhoto)
  }
}

extension ImagesFeedViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      self.searchService.request(searchTerm: searchText) { [weak self] result in
        switch result {
        case .success(let photos):
          self?.photos = photos.results
          self?.imageFeedView.reloadTableContent()
        case .failure(let error):
          print("Error: \(error)")
        }
      }
      searchController.resignFirstResponder()
    } else {
      loadData()
    }
  }
}

extension ImagesFeedViewController: ImagesFeedViewControllerDelegate {}
