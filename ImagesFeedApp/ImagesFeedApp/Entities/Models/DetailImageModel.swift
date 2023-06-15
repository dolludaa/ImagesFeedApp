//
//  DetailImageModel.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation

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
