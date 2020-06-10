import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    //MARK: - GET
    router.get { req -> Future<View> in
        
        struct PageData: Content {
            var restaurants: [Restaurant]
            var orders: [Order]
        }
        
        let cakes = Restaurant.query(on: req).all()
        let orders = Order.query(on: req).all()
        
        return flatMap(to: View.self, cakes, orders) { cakesArray, ordersArray in
            let context = PageData(restaurants: cakesArray, orders: ordersArray)
            return try req.view().render("home", context)
        }
    }
    
    
    router.get("orders") { req -> Future<View> in
        return Order.query(on: req).all().flatMap(to: View.self) { orders in
            return try req.view().render("orders", ["orders": orders])
        }
    }
    
    
    router.get("restaurants") { req -> Future<[Restaurant]> in
        return Restaurant.query(on: req).sort(\.name).all()
    }
    
    //MARK: - POST
    
    router.post(Restaurant.self, at: "add") { req, cupcake -> Future<Response> in
        return cupcake.save(on: req).map(to: Response.self) { cupcake in
            return req.redirect(to: "/")
        }
    }
    
    router.post(Order.self, at: "order") { req, order -> Future<Order> in
        var orderCopy = order
        orderCopy.date = Date()
        return orderCopy.save(on: req)
    }
}
