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
    let address: Address
}
struct Address:Codable{
    let firstLine: String?
    let postCode: String?
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
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Request failed: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data returned from server")
            return
        }
        print(" Received \(data.count) bytes")
        do{
            let decoded = try JSONDecoder().decode(Responses.self,from:data)
            let firstTen = decoded.restaurants.prefix(10)
            for (index, restaurant) in firstTen.enumerated(){
                print("restaurant #\(index+1)")
                print("name:\(restaurant.name)")
                print("cuisines:\(restaurant.cuisines.map{$0.name}.joined(separator:", "))")
                if let rating = restaurant.rating?.starRating {
                    print("rating: \(rating)")
                } else {
                    print("rating: N/A")
                }
                print("Address:\(restaurant.address.firstLine ?? "N/A"),\(restaurant.address.postCode ?? "")")
            }
            
        }catch {
            print("decoding failed \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print(" Could not convert data to string")
            }
        }
        
        }.resume()
}
else{
    print("you didn't enter a postcode")
}

//EC4M7RF
RunLoop.main.run()




