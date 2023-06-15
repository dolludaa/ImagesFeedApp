//
//  Contracts.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

protocol ImageFeedViewProtocol: UIView {
    func reloadTableContent()
    func reloadRows(indexPath: IndexPath)
    func didLoad()
}

protocol ImagesFeedViewControllerDelegate: AnyObject, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var title: String? { get set }
}
