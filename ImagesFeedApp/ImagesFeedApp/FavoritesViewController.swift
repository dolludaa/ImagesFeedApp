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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()
        loadData()
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

        title = " Favorite Images"
        tableView.rowHeight = 450
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

    private func loadData() {
        imagesService.fetchImages { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteImageCell.reuseIdentifier, for: indexPath) as! FavoriteImageCell
        let photoItem = photos[indexPath.row]
        cell.configure(model: photoItem)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.photoID = selectedPhoto.id
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}
