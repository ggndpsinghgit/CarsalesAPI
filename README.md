# Carsales Challenge API

A Swift Package to fetch data from a REST endpoint that contains:
- a generic API protocol that implements a shared `request` method which loads and decodes the response into a Decodable object. 
- the CarsalesAPI that conforms to the API protocol to load cars list & car details from the mocky.io endpoint.
- decodable models:
    -  `ListResult` for the list endpoint response
    - `ListItem` for the individual item in the list response
    - `CarDetails` for the details endpoint response

## How to use
- Add to your Xcode project's Swift Packages using the `main` branch as the target.
