//
//  ImagesScreenModel.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import Foundation

struct ImagesScreenModel: Codable {
    let id: String
    let likedByUser: Bool
    let urls: ImageUrls
    let user: UserInfo
}

struct ImageUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
