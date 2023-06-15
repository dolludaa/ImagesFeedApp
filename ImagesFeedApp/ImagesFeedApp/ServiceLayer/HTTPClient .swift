//
//  HTTPClient .swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import Foundation

protocol HTTPClientProtocol {
    func fetchData<T>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable

}

final class HTTPClient: HTTPClientProtocol {
    func fetchData<T>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        let completionOnMain = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }

            guard let data = data else {
                completionOnMain(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(T.self, from: data)
                completionOnMain(.success(object))
            } catch let decoderError {
                completionOnMain(.failure(decoderError))
            }
        }.resume()
    }
}
