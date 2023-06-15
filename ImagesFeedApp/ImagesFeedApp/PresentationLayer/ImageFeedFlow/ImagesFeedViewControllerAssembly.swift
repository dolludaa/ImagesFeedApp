//
//  File.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

struct ImagesFeedViewControllerAssembly {
    func create() -> UIViewController {
        let imageFeedView = ImageFeedView()
        let localStorage = LocalStorage()
        let imagesService = ImagesLoaderService()
        let searchService = ImagesSearchService()
        let controller = ImagesFeedViewController(
            localStorage: localStorage,
            imageFeedView: imageFeedView,
            imagesService: imagesService,
            searchService: searchService)
        imageFeedView.delegate = controller

        return controller
    }
}
