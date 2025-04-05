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
    let semaphore = DispatchSemaphore(value: 0)
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
            let allowedCuisines = [
                "Pizza", "Burgers", "Indian", "Thai", "Chinese", "Japanese", "Korean", "Turkish",
                "Greek", "Italian", "Vietnamese", "Lebanese", "Caribbean", "African", "Middle Eastern",
                "Mexican", "American", "British", "Spanish", "French", "German", "Portuguese",
                "Brazilian", "Peruvian", "Colombian", "Argentinian", "Pakistani", "Bangladeshi",
                "Nigerian", "Ethiopian", "South Indian", "Sri Lankan", "Nepalese", "Persian",
                "Iranian", "Indonesian", "Malaysian", "Filipino", "Kurdish", "Ghanaian",
                "Vietnamese", "Taiwanese", "Jamaican", "Cantonese", "Syrian", "Polish", "Ukrainian",
                "Vegetarian", "Vegan", "Halal", "Healthy", "Salads", "Steak", "Grill", "BBQ", "Pasta",
                "Seafood", "Sandwiches", "Wraps", "Bagels", "Biryani", "Poke", "Burritos",
                "Doughnuts", "Waffles", "Crepes", "Cakes", "Bakery", "Desserts", "Bubble Tea",
                "Smoothies", "Ice Cream", "Coffee", "Noodles", "Sushi"
            ]

            for (index, restaurant) in firstTen.enumerated() {
                // Clean the cuisines
                let cleanCuisines = restaurant.cuisines
                    .map { $0.name }
                    .filter { name in
                        allowedCuisines.contains(where: { allowed in
                            name.localizedCaseInsensitiveContains(allowed)
                        })
                    }

                // Skip if it’s clearly a non-restaurant
                if cleanCuisines.isEmpty || restaurant.name.lowercased().contains("grocery") {
                    continue
                }
                print("\n Restaurant #\(index + 1)")
                print(" Name: \(restaurant.name)")

               
                print(" Cuisines: \(cleanCuisines.isEmpty ? "N/A" : cleanCuisines.joined(separator: ", "))")

                if let rating = restaurant.rating?.starRating, rating > 0 {
                    print(" Rating: \(rating)")
                } else {
                    print(" Rating: Not yet rated")
                }

                let fullAddress = "\(restaurant.address.firstLine ?? "N/A"), \(restaurant.address.postCode ?? "")"
                print(" Address: \(fullAddress)\(postcode)")
                print("──────────────────────────────")
            }
        } catch {
            print("decoding failed \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print(" Could not convert data to string")
            }
        }
        semaphore.signal()
            
       
        
        }.resume()
    semaphore.wait()
    
}
else{
    print("you didn't enter a postcode")
}

//EC4M7RF





