//  Created by Gagandeep Singh on 6/8/20.

import Foundation

extension CarsalesAPI {
    public struct CarDetails: Identifiable {
        public let id: String
        public let title: String
        public let comments: String
        public let saleStatus: Status
        
        private let overview: Overview
        
        public init(
            id: String = UUID().uuidString,
            saleStatus: Status = .comingSoon,
            title: String = "",
            overview: CarDetails.Overview = .init(),
            comments: String = "")
        {
            self.id = id
            self.saleStatus = saleStatus
            self.title = title
            self.overview = overview
            self.comments = comments
        }
        
        // MARK: Computed Properties
        
        public var priceString: String {
            guard let price = self.overview.price else { return "Contact seller for price" }
            return price.currencyString ?? price
        }
        
        public var locationString: String {
            overview.location ?? "Australia"
        }
        
        public var photos: [String] {
            overview.photos
        }
    }
}

// MARK: - Overview

extension CarsalesAPI.CarDetails {
    public struct Overview: Decodable {
        public let location: String?
        public let price: String?
        public let photos: [String]
        
        public init(
            location: String? = nil,
            price: String? = nil,
            photos: [String] = [])
        {
            self.location = location
            self.price = price
            self.photos = photos
        }
        
        
        private enum CodingKeys: String, CodingKey {
            case location = "Location"
            case price = "Price"
            case photos = "Photos"
        }
    }
}

// MARK: - Sale Status

extension CarsalesAPI.CarDetails {
    public enum Status: String, Decodable {
        case available = "Available"
        case comingSoon = "Coming Soon"
    }
}

// MARK: - Decodable

extension CarsalesAPI.CarDetails: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case saleStatus = "SaleStatus"
        case title = "Title"
        case overview = "Overview"
        case comments = "Comments"
    }
}

// MARK: - Sample Item

extension CarsalesAPI.CarDetails {
    public static var sample: Self {
        .init(
            title: "2019 Mercedes Benz C300 Coupe",
            overview: .init(
                location: "New South Wales",
                price: "$103,400",
                photos: []),
            comments: "Across the centuries a billion trillion how far away rings of Uranus a mote of dust suspended in a sunbeam Euclid. Concept of the number one take root and flourish the carbon in our apple pies a still more glorious dawn awaits intelligent beings invent the universe. Vastness is bearable only through love gathered by gravity bits of moving fluff dream of the mind's eye as a patch of light paroxysm of global death and billions upon billions upon billions upon billions upon billions upon billions upon billions.")
    }
}
