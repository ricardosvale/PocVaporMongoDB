//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 10/09/24.
//

import Foundation
extension Movie {
    
    func toMovieDto() -> MovieData {
       
        return MovieData(title: self.title, year: self.year)
    }
}
