//
//  ImagesLoaderService.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import Foundation

final class ImagesLoaderService: ImagesLoaderServiceProtocol {

    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

  func fetchImages(page: Int = 1, completion: @escaping (Result<[ImagesScreenModel], Error>) -> Void) {
      var urlComponents = URLComponents(
        url: AppConstants.defaultBaseURL.appendingPathComponent("photos"),
        resolvingAgainstBaseURL: false)!
      urlComponents.queryItems = [
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "per_page", value: "5")
      ]

      guard let url = urlComponents.url else {
          completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
          return
      }

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
}
