//
//  Order.swift
//  App
//
//  Created by Maksim on 23/04/2020.
//

import Foundation
import FluentSQLite
import Vapor

struct Order: Content, SQLiteModel, Migration {
    var id: Int?
    var restaurantName: String
    var buyerName: String
    var date: Date?
}
