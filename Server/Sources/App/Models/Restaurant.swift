//
//  Cupcake.swift
//  App
//
//  Created by Maksim on 22/04/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct Restaurant: Content, SQLiteModel, Migration {
    var id: Int?
    var name: String
    var description: String
    var price: Int
}
