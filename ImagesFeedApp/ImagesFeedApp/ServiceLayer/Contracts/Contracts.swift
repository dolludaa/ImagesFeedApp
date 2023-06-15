//
//  Contracts.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/15/23.
//

import Foundation
import UIKit

protocol ImagesSearchServiceProtocol {
    func request(searchTerm: String, completion: @escaping (Result<SearchResults, Error>) -> Void)
}

protocol HTTPClientProtocol {
    func fetchData<T>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable

}

protocol ImagesLoaderServiceProtocol {
    func fetchImages(completion: @escaping (Result<[ImagesScreenModel], Error>) -> Void)
    func fetchInfo(photoID: String, completion: @escaping (Result<DetailImageModel, Error>) -> Void)
}
