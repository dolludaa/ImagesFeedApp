//
//  ImageInfoCellProtocol.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

protocol ImageInfoCellProtocol: UICollectionViewCell {
  func configure(model: ImagesScreenModel )
}
