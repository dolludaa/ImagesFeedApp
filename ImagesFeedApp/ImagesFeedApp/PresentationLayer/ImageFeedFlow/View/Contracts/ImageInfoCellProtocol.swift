//
//  ImageInfoCellProtocol.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

protocol ImageInfoCellProtocol: UITableViewCell {
    func configure(model: ImagesScreenModel, isLiked: Bool, onDidLike: @escaping () -> Void )
}
