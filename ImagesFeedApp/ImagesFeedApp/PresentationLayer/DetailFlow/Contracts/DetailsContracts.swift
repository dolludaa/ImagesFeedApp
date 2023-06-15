//
//  DetailsContracts.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

protocol DetailViewProtocol: UIView {
    func configure(model: DetailImageModel)
    func didLoad()
}

protocol DetailViewControllerDelegate: AnyObject {
    func formatDate(_ dateString: String) -> String?
}
