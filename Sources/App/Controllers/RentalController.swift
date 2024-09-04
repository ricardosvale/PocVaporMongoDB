//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 04/09/24.
//

import Foundation
import Vapor
import Fluent
import FluentMongoDriver


class RentalController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let rentals = routes.grouped("rentals")
        
        // POST: /api/rental
        rentals.post("rental", use: create)

    }
    
    func create(req: Request) async throws -> Rental {
        
        let rental = try req.content.decode(Rental.self)
        try await rental.save(on: req.db)
        return rental
    }
}
