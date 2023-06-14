//
//  ImagesFeedViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import UIKit
import Foundation

class ImagesFeedViewController: UIViewController {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var timer: Timer?
    private let imagesService = ImagesLoaderService()
    private let searchService = ImagesSearchService()
    private var photos: [ImagesScreenModel] = []
    private let localStorage = LocalStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        localStorage.update()
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

        title = "Images"
        tableView.rowHeight = 400
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageInfoCell.self, forCellReuseIdentifier: ImageInfoCell.reuseIdentifier)
        tableView.layer.cornerRadius = 9
        tableView.tableHeaderView = searchBar
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)

        searchBar.sizeToFit()
        searchBar.delegate = self
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

    private func didLikeOrDislike(indexPath: IndexPath) {
        let photoModel = photos[indexPath.row]
        localStorage.toggle(photoItem: photoModel)
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
        let detailViewController = DetailViewController()
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
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                searchBar.resignFirstResponder()
            }
        })
    }
}
