//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 05/09/24.
//

import Foundation
extension Rental{
    
    func toDto() -> CreateRentalWithMoviesData {
        return CreateRentalWithMoviesData(
            name: self.name,
            movies: self.movies.map { movie in
                MovieData(title: movie.title, year: movie.year)
            }
        )
    }
}
