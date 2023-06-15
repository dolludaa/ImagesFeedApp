//
//  FavoritesContracts.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

protocol FavoritesViewProtocol: UIView {
    func reloadData()
    func reloadRows(at indexPaths: [IndexPath])
}

protocol FavoritesViewControllerDelegate: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var title: String? { get set }
}
