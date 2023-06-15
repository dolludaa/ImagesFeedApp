//
//  FavoritesViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation
import UIKit

final class FavoritesViewController: UIViewController {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let imagesService = ImagesLoaderService()
    private var photos: [ImagesScreenModel] = []
    private let localStorage = LocalStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        localStorage.update()
        photos = localStorage.getSavedPhotos()
        tableView.reloadData()
    }

    private func setUpLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    private func setUpStyle() {
        view.backgroundColor = .white

        title = "Favorite Images"
        tableView.rowHeight = 100
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteImageCell.self, forCellReuseIdentifier: FavoriteImageCell.reuseIdentifier)
        tableView.layer.cornerRadius = 9
        tableView.tableHeaderView = searchBar
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }

    private func didLikeOrDislike(indexPath: IndexPath) {
        let photoModel = photos[indexPath.row]
        localStorage.toggle(photoItem: photoModel)
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
        let detailViewController = DetailViewControllerAssembly().create(imageService: imagesService)
        detailViewController.photoID = selectedPhoto.id

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
