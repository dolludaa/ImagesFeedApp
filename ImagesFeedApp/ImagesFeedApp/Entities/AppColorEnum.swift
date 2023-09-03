//
//  AppColorEnum.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 2023-09-01.
//

import Foundation
import UIKit

enum AppColorEnum {
    case backgroundColor
    case descriptionTextColor

    func color(for traitCollection: UITraitCollection) -> UIColor {
        switch self {
        case .backgroundColor:
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: 0x404040)
            default:
                return UIColor.white
            }
        case .descriptionTextColor:
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: 0x96959B)
            default:
                return UIColor.black
            }
        }
    }
}
