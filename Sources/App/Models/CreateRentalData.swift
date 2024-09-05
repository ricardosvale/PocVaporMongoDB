//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 05/09/24.
//

import Foundation
import Vapor
import Fluent

struct CreateRentalData: Content {
    var name: String
    var movieIds: [UUID]
}

struct CreateRentalWithMoviesData: Content {
    var name: String
    var movies: [MovieData]
}

struct MovieData: Content {
    var title: String
    var year: Int
}
