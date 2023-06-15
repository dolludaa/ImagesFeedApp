//
//  SearchResults.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [ImagesScreenModel]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: ImageUrls
}
