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

struct DetailImageModel: Codable {
    let id: String
    let downloads: Int
    let createdAt: String
    let user: UserInfo
    let urls: ImageUrls
}

struct UserInfo: Codable {
    let id: String
    let name: String
    let location: String?

}

struct SearchResults: Decodable {
    let total: Int
    let results: [ImagesScreenModel]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue: String]

    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
