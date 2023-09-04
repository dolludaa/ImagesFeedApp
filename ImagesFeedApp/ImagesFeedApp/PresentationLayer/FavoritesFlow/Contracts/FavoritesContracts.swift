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
  func deleteRows(at indexPaths: [IndexPath])
  func didLoad()
}

protocol FavoritesViewControllerDelegate: AnyObject, UITableViewDelegate, UITableViewDataSource {
  var title: String? { get set }
}
