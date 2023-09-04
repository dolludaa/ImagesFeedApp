//
//  ImagesSearchService.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation

class ImagesSearchService: ImagesSearchServiceProtocol {

  private let client: HTTPClientProtocol
  private let debouncer = Debouncer(delay: 1)

  init(client: HTTPClientProtocol = HTTPClient()) {
    self.client = client
  }

  func request(searchTerm: String, completion: @escaping (Result<SearchResults, Error>) -> Void) {
    guard let url = prepareURL(with: prepareParameters(searchTerm: searchTerm)) else {
      completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
      return
    }

    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = prepareHeaders()
    request.httpMethod = "GET"

    debouncer.debounce { [weak self] in
      self?.client.fetchData(for: request, completion: completion)
    }
  }

  private func prepareHeaders() -> [String: String] {
    return ["Authorization": "Client-ID \(AppConstants.accessKey)"]
  }

  private func prepareParameters(searchTerm: String?) -> [String: String] {
    return [
      "query": searchTerm ?? "",
      "page": "1",
      "per_page": "30"
    ]
  }

  private func prepareURL(with parameters: [String: String]) -> URL? {
    var components = URLComponents(url: AppConstants.defaultBaseURL, resolvingAgainstBaseURL: true)
    components?.path = "/search/photos"
    components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    return components?.url
  }
}
