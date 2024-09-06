//
//  File.swift
//
//
//  Created by Ricardo Silva Vale on 30/08/24.
//

import Foundation
import Vapor
import Fluent

final class Movie: Model, Content, @unchecked Sendable {
    
    static let schema = "movies"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "year")
    var year: Int
    
    @Siblings(through: RentalMovie.self, from: \.$movie, to: \.$rental)
    var rentals: [Rental]
    
    init() { }
    
    init(id: UUID? = nil, title: String, year: Int)  {
        self.id = id
        self.title = title
        self.year = year
    }
}
