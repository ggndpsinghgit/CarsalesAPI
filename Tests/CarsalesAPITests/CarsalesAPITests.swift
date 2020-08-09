@testable import CarsalesAPI
import XCTest
import Combine

final class MockAPI: API {
    var baseURL: URL = URL(string: "https://testcarsalesapi.com")!
    var dataLoader: DataLoader = .init()
    
    @discardableResult
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) -> AnyCancellable? {
        switch endpoint {
        case CarsalesEndpoint.list:
            completion(.success(CarsalesAPI.ListResult(objects: [.sample]) as! T))
        case CarsalesEndpoint.details:
            completion(.success(CarsalesAPI.CarDetails.sample as! T))
        default:
            completion(.failure(NSError(domain: "", code: 500, userInfo: nil)))
        }
        return nil
    }
}

final class CarsalesAPITests: XCTestCase {
    func testAPIListResponse() {
        let api = MockAPI()
        
        let expectation = XCTestExpectation(description: "listItem")
        api.request(endpoint: CarsalesEndpoint.list) { (result: Result<CarsalesAPI.ListResult, Error>) in
            switch result {
            case .success(let value):
                XCTAssertEqual(value.objects.first?.title, CarsalesAPI.ListItem.sample.title)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testAPIDetailsResponse() {
        let api = MockAPI()
        
        let expectation = XCTestExpectation(description: "details")
        api.request(endpoint: CarsalesEndpoint.details("")) { (result: Result<CarsalesAPI.CarDetails, Error>) in
            switch result {
            case .success(let value):
                XCTAssertEqual(value.title, CarsalesAPI.CarDetails.sample.title)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testListItemDeserialisation() {
        let json = """
        { \
          "Id": "AD-5989286", \
          "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
          "Location": "Victoria", \
          "Price": "$53,081", \
          "MainPhoto": "https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg", \
          "DetailsUrl": "/v3/9ea9359e-c29d-4493-ad02-69662dcb5586" \
        }
        """
        
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode(CarsalesAPI.ListItem.self, from: data!))
        
        let details = try! decoder.decode(CarsalesAPI.ListItem.self, from: data!)
        XCTAssertEqual(details.title, "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab")
        XCTAssertEqual(details.locationString, "Victoria")
        XCTAssertEqual(details.priceString, "$53,081")
        XCTAssertEqual(details.photoPath, "https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg")
        XCTAssertEqual(details.detailsURL, "/v3/9ea9359e-c29d-4493-ad02-69662dcb5586")
    }
    
    func testMultipleListItemDeserialisation() {
        let json = """
        [
            { \
              "Id": "AD-5989286", \
              "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
              "Location": "Victoria", \
              "Price": "$53,081", \
              "MainPhoto": "https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg", \
              "DetailsUrl": "/v3/9ea9359e-c29d-4493-ad02-69662dcb5586" \
            },
            { \
              "Id": "AD-5989287", \
              "Title": "Mercedes Benz C300 Coupe", \
              "Location": "New South Wales", \
              "Price": "$103,400", \
              "MainPhoto": "https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg", \
              "DetailsUrl": "/v3/9ea9359e-c29d-4493-ad02-69662dcb5589" \
            }
        ]
        """
        
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode([CarsalesAPI.ListItem].self, from: data!))
    }
    
    func testListItemDeserialisationWithNilLocation() {
        let json = """
        { \
          "Id": "AD-5989286", \
          "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
          "Location": null, \
          "Price": "$53,081", \
          "MainPhoto": "https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg", \
          "DetailsUrl": "/v3/9ea9359e-c29d-4493-ad02-69662dcb5586" \
        }
        """
        
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode(CarsalesAPI.ListItem.self, from: data!))
    }
    
    func testListItemDeserialisationWithNilPrice() {
        let noPriceJSON = """
        { \
          "Id": "AD-5989286", \
          "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
          "Location": null, \
          "Price": null, \
          "MainPhoto": "https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg", \
          "DetailsUrl": "/v3/9ea9359e-c29d-4493-ad02-69662dcb5586" \
        }
        """
        
        let decoder = JSONDecoder()
        let data = noPriceJSON.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode(CarsalesAPI.ListItem.self, from: data!))
    }
    
    
    func testDetailsDeserialisation() {
        let json = """
        { \
          "Id": "AD-5989286", \
          "SaleStatus": "Available", \
          "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
          "Overview": { \
            "Location": "Victoria", \
            "Price": "$53,081", \
            "Photos": ["https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg"] \
          }, \
          "Comments": "Car details" \
        }
        """
        
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode(CarsalesAPI.CarDetails.self, from: data!))
    }
    
    func testDetailsDeserialisationWithNilLocation() {
        let json = """
        { \
          "Id": "AD-5989286", \
          "SaleStatus": "Available", \
          "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
          "Overview": { \
            "Location": null, \
            "Price": "$53,081", \
            "Photos": ["https://carsales.pxcrush.net/carsales/car/cil/bjk2g3yi1gxy2xfg6xf9ugyd7.jpg"] \
          }, \
          "Comments": "Car details" \
        }
        """
        
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode(CarsalesAPI.CarDetails.self, from: data!))
    }
    
    func testDetailsDeserialisationWithNilPrice() {
        let json = """
        { \
          "Id": "AD-5989286", \
          "SaleStatus": "Available", \
          "Title": "2019 Mitsubishi Triton GLS MR Auto 4x4 MY19 Double Cab", \
          "Overview": { \
            "Location": null, \
            "Price": null, \
            "Photos": [] \
          }, \
          "Comments": "Car details" \
        }
        """
        
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try decoder.decode(CarsalesAPI.CarDetails.self, from: data!))
    }

    static var allTests = [
        ("testAPIListResponse", testAPIListResponse),
        ("testAPIDetailsResponse", testAPIDetailsResponse),
        ("testListItemDeserialisation", testListItemDeserialisation),
        ("testMultipleListItemDeserialisation", testMultipleListItemDeserialisation),
        ("testListItemDeserialisationWithNilLocation", testListItemDeserialisationWithNilLocation),
        ("testListItemDeserialisationWithNilPrice", testListItemDeserialisationWithNilPrice),
        ("testDetailsDeserialisation", testDetailsDeserialisation),
        ("testDetailsDeserialisationWithNilLocation", testDetailsDeserialisationWithNilLocation),
        ("testDetailsDeserialisationWithNilPrice", testDetailsDeserialisationWithNilPrice)
    ]
}
