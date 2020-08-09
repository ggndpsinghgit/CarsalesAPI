//  Created by Gagandeep Singh on 6/8/20.

import Foundation

// MARK: - List Result

extension CarsalesAPI {
    public struct ListResult: Decodable {
        public let objects: [ListItem]
        
        public init(objects: [ListItem]) {
            self.objects = objects
        }
        
        private enum CodingKeys: String, CodingKey {
            case objects = "Result"
        }
    }
}

// MARK: - List Item

extension CarsalesAPI {
    public struct ListItem: Identifiable {
        public let id: String = UUID().uuidString
        public let title: String
        public let photoPath: String
        public let detailsURL: String
        
        private let location: String?
        private let price: String?
        
        init(
            title: String,
            location: String,
            price: String,
            photoPath: String,
            detailsURL: String)
        {
            self.title = title
            self.location = location
            self.price = price
            self.photoPath = photoPath
            self.detailsURL = detailsURL
        }
        
        // MARK: Computed Properties
        
        public var priceString: String {
            price ?? "Contact seller for price"
        }
        
        public var locationString: String {
            location ?? "Australia"
        }
    }
}

// MARK: - Hashable

extension CarsalesAPI.ListItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(_ lhs: CarsalesAPI.ListItem, rhs: CarsalesAPI.ListItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Decodable

extension CarsalesAPI.ListItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case location = "Location"
        case price = "Price"
        case photoPath = "MainPhoto"
        case detailsURL = "DetailsUrl"
    }
}

// MARK: - Sample Item

extension CarsalesAPI.ListItem {
    public static var sample: Self {
        .init(
            title: "2019 Mercedes Benz C300",
            location: "New South Wales",
            price: "$103,400",
            photoPath: "",
            detailsURL: "")
    }
}
