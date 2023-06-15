//
//  ImagesSearchService.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation

class ImagesSearchService: ImagesSearchServiceProtocol {
    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

    func request(searchTerm: String, completion: @escaping (Result<SearchResults, Error>) -> Void) {
        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = prepareURL(with: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "GET"

        client.fetchData(for: request) { (result: Result<SearchResults, Error>) in
            completion(result)
        }
    }

    private func prepareHeaders() -> [String: String] {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(AppConstants.accessKey)"
        return headers
    }

    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = "1"
        parameters["per_page"] = "30"
        return parameters
    }

    private func prepareURL(with parameters: [String: String]) -> URL {
        var components = URLComponents(url: AppConstants.defaultBaseURL, resolvingAgainstBaseURL: true)
        components?.path = "/search/photos"
        components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return components?.url ?? URL(string: "")!
    }
}
