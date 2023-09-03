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

  private var timer: Timer?
  private var photos: [ImagesScreenModel] = []

  init(
    imageFeedView: ImageFeedViewProtocol,
    imagesService: ImagesLoaderServiceProtocol,
    searchService: ImagesSearchServiceProtocol) {
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

    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false

  }

  private func loadData() {
    let size = getCellSize()
    if currentPage <= totalPages {
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

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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

    let widthPerItem = collectionView.frame.width / 2
    let imageUrl = photoItem.urls.regular
//    let processor = ResizingImageProcessor(referenceSize: CGSize(width: widthPerItem, height: widthPerItem))

    cell.configure(model: photoItem)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
      getCellSize()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

