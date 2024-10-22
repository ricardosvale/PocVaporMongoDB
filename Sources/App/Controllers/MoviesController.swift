//
//  File.swift
//
//
//  Created by Ricardo Silva Vale on 30/08/24.
//

import Foundation
import Vapor
import Fluent
import FluentMongoDriver

struct MoviesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        
        // POST: /api/movies
        api.post("movies", use: create)
        
        // GET: /api/movies
        api.get("movies", use: getAll)
        
        // GET: /api/movies/:movieId
        api.get("movies", ":movieId",  use: getById)
        
        //DELETE: /api/movies/:movieId
        api.delete("movies", ":movieId", use: deleteMovie)
        
        //PUT: /api/movies/:moviesId
        api.put("movies", ":movieId", use: updateMovie)
    }
    
    @Sendable
    func updateMovie(req: Request) async throws -> Movie {
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        guard let movie = try await Movie.find(movieId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        //Aqui Decodifico meu JSON
        let updateMovie = try req.content.decode(Movie.self)
        
        movie.title = updateMovie.title
        movie.year = updateMovie.year
        try await movie.update(on: req.db)
        return movie
    }
    
    @Sendable
    func deleteMovie(req: Request) async throws -> Movie {
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        guard let movie = try await Movie.find(movieId, on: req.db) else {
            throw Abort(.notFound)
        }
        //Exclue a relação no rental_movie (pivot)
        try await movie.$rentals.detachAll(on: req.db)
        
        try await movie.delete(on: req.db)
        return movie
    }
    
    @Sendable
    func getAll(req: Request) async throws -> [Movie] {
        return try await Movie.query(on: req.db)
            .all()
    }
    
    @Sendable
    func getById(req: Request) async throws -> Movie {
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        guard let movie = try await Movie.find(movieId, on: req.db) else {
            throw Abort(.notFound, reason: "MovieId \(movieId) was not found.")
        }
        
        return movie
    }
    
    @Sendable
    func create(req: Request) async throws -> Movie {
        
        let movie = try req.content.decode(Movie.self)
        try await movie.save(on: req.db)
        return movie
    }
}
