//  Created by Gagandeep Singh on 6/8/20.

import Foundation
import Combine

protocol Endpoint {
    var path: String { get }
}

protocol API {
    var baseURL: URL { get }
    var dataLoader: DataLoader { get }
    var cancellable: AnyCancellable? { get set }
}

extension API {
    func url(for endpoint: Endpoint) -> URL {
        baseURL.appendingPathComponent(endpoint.path)
    }
    
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) -> AnyCancellable? {
        let request = URLRequest(url: url(for: endpoint))
        return dataLoader.load(request)
            .map(\.value)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            }, receiveValue: { (value: T) in
                completion(.success(value))
            })
    }
}
