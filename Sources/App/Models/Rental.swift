//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 04/09/24.
//

import Foundation
import Vapor
import Fluent

final class Rental: Model, Content {
  
    static let schema = "rentals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: RentalMovie.self, from: \.$rental, to: \.$movie)
    var movies: [Movie]
    
    init() { }
    
    init(id: UUID? = nil, name: String){
        self.id = id
        self.name = name
    }
}
