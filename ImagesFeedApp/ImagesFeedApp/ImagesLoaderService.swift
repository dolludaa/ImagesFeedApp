//
//  ImagesLoaderService.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import Foundation

protocol ImagesLoaderServiceProtocol {
    func fetchImages(completion: @escaping (Result<[ImagesScreenModel], Error>) -> Void)
}

final class ImagesLoaderService: ImagesLoaderServiceProtocol {

    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

    func fetchImages(completion: @escaping (Result<[ImagesScreenModel], Error>) -> Void) {
        let url = AppConstants.defaultBaseURL.appendingPathComponent("photos")
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(AppConstants.accessKey)", forHTTPHeaderField: "Authorization")
        client.fetchData(for: request) { result in
            completion(result)
        }
    }

    func fetchInfo(photoID: String, completion: @escaping (Result<DetailImageModel, Error>) -> Void) {
        let url = AppConstants.defaultBaseURL.appendingPathComponent("photos/\(photoID)")
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(AppConstants.accessKey)", forHTTPHeaderField: "Authorization")
        client.fetchData(for: request) { result in
            completion(result)
            
        }
    }

    func likePhoto(photoID: String, completion: @escaping (Result<[ImagesScreenModel], Error>) -> Void) {
        let url = AppConstants.defaultBaseURL.appendingPathComponent("photos/\(photoID)/like")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Client-ID \(AppConstants.accessKey)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer \(AppConstants.accessKey)", forHTTPHeaderField: "Authorization")

        client.fetchData(for: request) { result in
            completion(result)
        }
    }

    func unlikePhoto(photoID: String, completion: @escaping (Result<[ImagesScreenModel], Error>) -> Void) {
        let url = AppConstants.defaultBaseURL.appendingPathComponent("photos/\(photoID)/like")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Client-ID \(AppConstants.accessKey)", forHTTPHeaderField: "Authorization")

        client.fetchData(for: request) { result in
            completion(result)
        }
    }
}

