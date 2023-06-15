//
//  DetailViewControllerAssembly.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

struct DetailViewControllerAssembly {
    func create(
        photoID: String,
        imageService: ImagesLoaderServiceProtocol
    ) -> UIViewController {
        let detailView = DetailView()

        let controller = DetailViewController(
            photoID: photoID,
            detailView: detailView,
            imageService: imageService
        )
        detailView.delegate = controller

        return controller
    }
}
