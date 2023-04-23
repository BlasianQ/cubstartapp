//
//  Api.swift
//  hw6
//
//  Created by Andy Huang on 3/8/23.
//

import Foundation

/* Returns a Dog optional type from calling the dogAPI and decoding the fetched JSON.
 Do NOT use this in ContentView after you are done implementing it. Use fetchDoggy() instead.
 
 Ex1 fetchDog() is able to get a valid response from API: fetchDog() -> Dog
 Ex2 fetchDog() is NOT able to get a valid response from API: fetchDog() -> nil
 */
func fetchDog() async -> Dog? {
    // TODO: Part 2b - Create url object.
    guard let url = URL(string: "https://api.api-ninjas.com/v1/randomword") else {
        return nil
    }
    
    // Wrap api call inside a do/catch block in case an error is thrown.
    do {
        // TODO: Part 2b - Send request and get data from api.
        // TODO: Part 2b - Decode JSON of the data from api into a Dog. Return the decoded response.
        let (data, _) = try await URLSession.shared.data(from: url)
        if let decodedResponse = try? JSONDecoder().decode(Dog.self, from: data) {
            return decodedResponse
        }
    } catch {
        // Note: You may be getting a yellow warning that this block is unreachable. Don't worry about it, it should disappear after you finish Part 2b.
        return nil
    }
    return nil
    
}


/* Continuously calls fetchDog() until a Dog is returned and returns that Dog. */
func fetchDoggy() async -> Dog {
    // Try to get a Dog
    var newDog = (await fetchDog()) ?? nil
    
    // Check if there is a Dog
    while (newDog == nil) {
        // Try again to get Dog
        newDog = (await fetchDog()) ?? nil
    }
    
    // Can force-unwrap because newDog is guaranteed a dog.
    return newDog!
}

