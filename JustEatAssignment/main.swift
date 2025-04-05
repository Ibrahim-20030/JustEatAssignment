//
//  main.swift
//  JustEatAssignment
//
//  Created by Ibrahim Khizer on 25/03/2025.
//
// structs to match the JSON structure from the API


import Foundation
// This is the top-level object in the JSON response.
// It contains an array of restaurants we're interested in.
struct Responses:Codable{
    let restaurants: [Restaurant]
}
// Each restaurant has a name, a list of cuisines, a rating object, and an address object.
struct Restaurant:Codable{
    let name:String
    let cuisines:[Cuisine]
    let rating:Rating?
    let address: Address
}
// Address is a nested object inside each restaurant that holds fields like firstLine and postCode.
// These fields are optional because some restaurants might be missing them.
struct Address:Codable{
    let firstLine: String?
    let postCode: String?
}
// Rating is also a nested object. We're only interested in the starRating field.
struct Rating:Codable{
    let starRating: Double
}
// Cuisine is a simple struct where we extract the name of each cuisine offered by the restaurant.
struct Cuisine:Codable{
    let name: String
}

// 1. Ask the user to enter a UK postcode
print("Enter your postcode")
// 2. Read their input from the console and ensure it is not empty
if let postcode = readLine(), !postcode.isEmpty{
    print("you entered \(postcode)")
    // Format the API URL with the user-entered postcode.
    let urlString = "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/\(postcode)"
    // Safely create a URL from the string. If it's invalid, exit the program.
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        exit(1)
    }
    //print("URL is valid \(url)")
    
    // Semaphore is used to pause the program until the asynchronous API call is complete.
    // This ensures the program doesn't exit before we get data back from Just Eat.
    let semaphore = DispatchSemaphore(value: 0)
    // Start an asynchronous request to fetch data from the Just Eat API
    URLSession.shared.dataTask(with: url) { data, response, error in
        
        // If there's a network or server error, print it and stop.
        if let error = error {
            print("Request failed: \(error.localizedDescription)")
            return
        }
        // Make sure data was returned, otherwise stop.
        guard let data = data else {
            print("No data returned from server")
            return
        }
        //print(" Received \(data.count) bytes")
        
        // Attempt to decode the JSON into our Swift structs
        do{
            let decoded = try JSONDecoder().decode(Responses.self,from:data)
            // We're only interested in the first 10 restaurants as per the assignment rules
            let firstTen = decoded.restaurants.prefix(10)
            
            // This is our "whitelist" of cuisines we're allowing to appear
            // Anything outside this list will be filtered out (e.g. "Low Delivery Fee", "Deals", etc.)
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
            // Loop through each of the 10 restaurants
            for (index, restaurant) in firstTen.enumerated() {
                // Clean the cuisines to only those approved in the list
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
                // print the restaurants
                print("\n Restaurant #\(index + 1)")
                print(" Name: \(restaurant.name)")
                print(" Cuisines: \(cleanCuisines.isEmpty ? "N/A" : cleanCuisines.joined(separator: ", "))")
                
                // Only show the rating if it's greater than 0 (skip unrated restaurants)
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
        // Signal the semaphore to allow the program to continue and exit after printing.
        semaphore.signal()
            
       
        
        }.resume()
    // This line pauses the program until the API response is processed.
    semaphore.wait()
    
}
// If the user didn’t type anything, let them know.
else{
    print("you didn't enter a postcode")
}

//EC4M7RF





