//
//  ImageFeedView.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

final class ImageFeedView: UIView {

    weak var delegate: ImagesFeedViewControllerDelegate?

    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    private func setUpLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    private func setUpStyle() {
        backgroundColor = .white

        delegate?.title = "Images"
        tableView.rowHeight = 400
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.register(ImageInfoCell.self, forCellReuseIdentifier: ImageInfoCell.reuseIdentifier)
        tableView.layer.cornerRadius = 9
        tableView.tableHeaderView = searchBar
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)

        searchBar.sizeToFit()
        searchBar.delegate = delegate
    }
}

extension ImageFeedView: ImageFeedViewProtocol {
    func reloadTableContent() {
        tableView.reloadData()
    }

    func reloadRows(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func didLoad() {
        setUpLayout()
        setUpStyle()
    }
}
