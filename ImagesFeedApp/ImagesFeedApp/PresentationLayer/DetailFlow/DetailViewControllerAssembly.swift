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
    photoModel: ImagesScreenModel,
    imageService: ImagesLoaderServiceProtocol,
    localStorage: LocalStorageProtocol
  ) -> UIViewController {
    let detailView = DetailView()

    let controller = DetailViewController(
      photoModel: photoModel,
      detailView: detailView,
      imageService: imageService,
      localStorage: localStorage

    )
    detailView.delegate = controller

    return controller
  }
}
