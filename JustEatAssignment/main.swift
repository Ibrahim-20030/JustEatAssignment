//
//  main.swift
//  JustEatAssignment
//
//  Created by Ibrahim Khizer on 25/03/2025.
//

import Foundation

// 1. Ask the user to enter a UK postcode
print("Enter your postcode")
// 2. Read their input from the console
if let postcode = readLine(), !postcode.isEmpty{
    print("you entered \(postcode)")
    let urlString = "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/\(postcode)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        exit(1)
    }
    print("URL is valid \(url)")
}else{
    print("you didn't enter a postcode")
}





