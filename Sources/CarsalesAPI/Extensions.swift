//  Created by Gagandeep Singh on 6/8/20.

import Foundation

extension String {
    var currencyString: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        let numericString: String = self.reduce(into: "") {
            if let number = Int(String($1)) {
                $0 += String(number)
            }
        }
        guard let numeric = Int(numericString) else { return nil }
        return formatter.string(from: NSNumber(value: numeric))
    }
}
