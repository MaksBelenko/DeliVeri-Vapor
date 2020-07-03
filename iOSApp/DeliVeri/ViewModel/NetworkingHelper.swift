//
//  NetworkingHelper.swift
//  DeliVeri
//
//  Created by Maksim on 03/07/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import Foundation

class NetworkingHelper {

    let mainUrl = "http://localhost:8080"
    var restaurants: Observable<[Restaurant]> = Observable([])
    
    
    
    func fetchData() {
        let url = URL(string: mainUrl + "/restaurants")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            
            if let rests = try? decoder.decode([Restaurant].self, from: data) {
                DispatchQueue.main.async {
                    self.restaurants.value = rests
                    print("Loaded \(rests.count) restaurants.")
                }
            } else {
                print("Unable to parse JSON response")
            }
            
        }.resume()
    }
    
    
    
    func order(_ restaurant: Restaurant, for name: String) {
        let order = Order(restaurantName: restaurant.name, buyerName: name)
        let url = URL(string: mainUrl + "/order")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(order)
        
        URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let item = try? decoder.decode(Order.self, from: data) {
                    print("Order processed for \(item.buyerName)")
                } else {
                    print("Bad JSON received back.")
                }
            }
        }.resume()
    }
}
