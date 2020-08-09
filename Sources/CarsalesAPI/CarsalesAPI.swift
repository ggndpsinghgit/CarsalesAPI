//  Created by Gagandeep Singh on 6/8/20.

import UIKit
import Combine

open class CarsalesAPI: API {
    let baseURL: URL = URL(string: "https://mocky.io")!
    var dataLoader: DataLoader = .init()
    var cancellable: AnyCancellable?
    
    public init() {}
    
    open func getList(completion: @escaping (Result<ListResult, Error>) -> Void){
        cancellable = request(endpoint: CarsalesEndpoint.list, completion: completion)
    }

    open func getDetails(path: String, completion: @escaping (Result<CarDetails, Error>) -> Void){
        cancellable = request(endpoint: CarsalesEndpoint.details(path), completion: completion)
    }
}

enum CarsalesEndpoint: Endpoint {
    case list
    case details(String)
    
    var path: String {
        switch self {
        case .list:
            return "v3/e8c52b55-7f44-41a8-b059-5d042269b520"
        case .details(let uri):
            return uri
        }
    }
}

