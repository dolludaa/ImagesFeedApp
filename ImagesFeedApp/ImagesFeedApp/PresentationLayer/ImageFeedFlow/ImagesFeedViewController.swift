//
//  ImagesFeedViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import UIKit
import Foundation

class ImagesFeedViewController: UIViewController {

    private let localStorage: LocalStorageProtocol
    private let imageFeedView: ImageFeedViewProtocol
    private let imagesService: ImagesLoaderServiceProtocol
    private let searchService: ImagesSearchServiceProtocol

    private var timer: Timer?
    private var photos: [ImagesScreenModel] = []

    init(
        localStorage: LocalStorageProtocol,
        imageFeedView: ImageFeedViewProtocol,
        imagesService: ImagesLoaderServiceProtocol,
        searchService: ImagesSearchServiceProtocol) {
            self.localStorage = localStorage
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        localStorage.update()
    }

    private func loadData() {
        imagesService.fetchImages { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.imageFeedView.reloadTableContent()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func didLikeOrDislike(indexPath: IndexPath) {
        let photoModel = photos[indexPath.row]
        localStorage.toggle(photoItem: photoModel)
        imageFeedView.reloadRows(indexPath: indexPath)
    }
}

extension ImagesFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageInfoCell.reuseIdentifier,
            for: indexPath) as? ImageInfoCell
        else {
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
            photoID: selectedPhoto.id,
            imageService: imagesService
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

extension ImagesFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            if searchBar.text?.isEmpty == true {
                self?.loadData()
            } else {
                self?.searchService.request(searchTerm: searchText) { [weak self] result in
                    switch result {
                    case .success(let photos):
                        self?.photos = photos.results
                        self?.imageFeedView.reloadTableContent()
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                searchBar.resignFirstResponder()
            }
        })
    }
}

extension ImagesFeedViewController: ImagesFeedViewControllerDelegate {}
