//
//  main.swift
//  JustEatAssignment
//
//  Created by Ibrahim Khizer on 25/03/2025.
//

import Foundation
//need to decode name cuisine rating address
// define swift structs
struct Responses:Codable{
    let restaurants: [Restaurant]
}
struct Restaurant:Codable{
    let name:String
    let cuisines:[Cuisine]
    let rating:Rating?
    let address: String
}
struct Rating:Codable{
    let starRating: Double
}
struct Cuisine:Codable{
    let name: String
}
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
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Request failed: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("No data returned from server")
            return
        }
        print(" Received \(data.count) bytes")
        print(" Raw JSON data (as string):")

        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        } else {
            print(" Could not convert data to string")
        }

    }

    task.resume()

}else{
    print("you didn't enter a postcode")
}

//EC4M7RF
sleep(10)




