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


struct RentalController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        
        // POST: api/rental1
        api.post("rental1", use: create1)
        
        // GET: /rental1
        api.get("rental1", use: getAll)
        
        // GET: /rental1/:rentalId
        api.get("rental1",":rentalId", use: getById)
        
        //PUT: /rental1/:rentalId/add-movie/:movieId
        api.put("rental1", ":rentalId", "add-movie", ":movieId",  use: addMovieToRental.self)
        
        //DELETE:  /rental1/:rentalId
        api.delete("rental1", ":rentalId", use: deleteRental)
        
    }
    
    @Sendable
    func create1(req: Request) async throws -> Rental {
        // Decodifica o JSON contendo o Rental e os filmes
        let createRentalData = try req.content.decode(CreateRentalWithMoviesData.self)
        
        // Cria o Rental
        let rental = Rental(name: createRentalData.name)
        try await rental.save(on: req.db)
        
        // Itera sobre os filmes fornecidos e cria cada um
        for movieData in createRentalData.movies {
            let existingMovie = try await Movie.query(on: req.db)
                .filter(\.$title == movieData.title)
                .filter(\.$year == movieData.year)
                .first()
            
            let movie: Movie
            if let existingMovie = existingMovie {
                movie = existingMovie
            } else {
                movie = Movie(title: movieData.title, year: movieData.year)
                try await movie.save(on: req.db)
            }
            
            // Associa o filme ao Rental
            try await rental.$movies.attach(movie, on: req.db)
        }
        // Retorna o Rental com os filmes criados
        return try await Rental.query(on: req.db)
            .with(\.$movies) // Inclui os filmes no retorno
            .filter(\.$id == rental.id!)
            .first()!
    }
    
    @Sendable
    // GET: /rentals/:rentalId (exemplo)
    func getById(req: Request) async throws -> CreateRentalWithMoviesData {
        guard let rentalId = req.parameters.get("rentalId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing rental ID.")
        }
        
        guard let rental = try await Rental.query(on: req.db)
            .with(\.$movies)
            .filter(\.$id == rentalId)
            .first() else {
            throw Abort(.notFound, reason: "Rental not found.")
        }
        
        return  rental.toDto()
    }
    
    
    @Sendable
    func getAll(req: Request) async throws -> [Rental] {
        // Consulta todos os Rentals e inclui os filmes associados
        
        return try await Rental.query(on: req.db)
            .with(\.$movies) // Inclui os filmes associados a cada Rental
            .all()
    }
    
    @Sendable
    func addMovieToRental(req: Request) async throws -> HTTPStatus {
        // Verifica se os Ids de movie e rental estão corretos
        
        guard let rentalId = req.parameters.get("rentalId", as: UUID.self),
              let movieId = req.parameters.get("movieId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid rental or movie ID.")
        }
        
        // Agora vou pegar a Rental
        guard let rental = try await Rental.find(rentalId, on: req.db) else {
            throw Abort(.notFound, reason: "Rental not found.")
        }
        
        // Agora faço memso para o Movie
        guard let movie = try await Movie.find(movieId, on: req.db) else {
            throw Abort(.notFound,  reason: "Movie not found")
        }
        
        // Agora faço a associação do filme a locadora
        try await rental.$movies.attach(movie, on: req.db)
        
        return .ok
    }
    
    @Sendable
    func deleteRental(req: Request) async throws -> Rental{
        guard let rentalId = req.parameters.get("rentalId", as: UUID.self) else{
            throw Abort(.notFound)
        }
        
        guard let rental = try await Rental.find(rentalId, on: req.db) else {
            throw Abort(.notFound)
        }
        try await rental.delete(on: req.db)
        return rental
    }
}
