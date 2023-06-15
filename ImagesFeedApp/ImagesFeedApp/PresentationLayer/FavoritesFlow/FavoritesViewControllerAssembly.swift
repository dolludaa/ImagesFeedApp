//
//  FavoritesViewControllerAssembly.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

struct FavoritesViewControllerAssembly {
    func create() -> UIViewController {
        let view = FavoritesView()
        let controller = FavoritesViewController(
            detailView: view,
            imagesService: ImagesLoaderService(),
            localStorage: LocalStorage()
        )
        view.delegate = controller
        return controller
    }
}
