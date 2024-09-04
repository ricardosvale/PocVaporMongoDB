//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 04/09/24.
//
import Foundation
import Vapor
import Fluent

final class RentalMovie: Model {

    static let schema = "rental_movie"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "rental_id")
    var rental: Rental

    @Parent(key: "movie_id")
    var movie: Movie

    init() { }

    init(rentalID: UUID, movieID: UUID) {
        self.$rental.id = rentalID
        self.$movie.id = movieID
    }
}
