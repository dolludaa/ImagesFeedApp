//
//  FavoritesView.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

final class FavoritesView: UIView {

    weak var delegate: FavoritesViewControllerDelegate?

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        setUpStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        delegate?.title = "Favorite Images"
        tableView.rowHeight = 100
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.register(FavoriteImageCell.self, forCellReuseIdentifier: FavoriteImageCell.reuseIdentifier)
        tableView.layer.cornerRadius = 9
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
}

extension FavoritesView: FavoritesViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }

    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }

    func didLoad() {
        setUpLayout()
        setUpStyle()
    }
}
