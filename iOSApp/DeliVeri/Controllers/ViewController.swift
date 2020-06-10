//
//  ViewController.swift
//  iOSCupcakes
//
//  Created by Maksim on 22/04/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var restaurants = [Restaurant]()
    let mainUrl = "http://localhost:8080"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Restaurants"
        
        fetchData()
    }

    
    
    
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
                    self.restaurants = rests
                    self.tableView.reloadData()
                    print("Loaded \(rests.count) cupcakes.")
                }
            } else {
                print("Unable to parse JSON response")
            }
            
        }.resume()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        
        cell.textLabel?.text = "\(restaurant.name) - £\(restaurant.price)"
        cell.detailTextLabel?.text = restaurant.description
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        
        let ac = UIAlertController(title: "Order a \(restaurant.name)", message: "Please enter your name", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Order it!", style: .default, handler: { action in
            guard let name = ac.textFields?[0].text else { return }
            self.order(restaurant, for: name)
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
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
    
    
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        fetchData()
    }
    
}

