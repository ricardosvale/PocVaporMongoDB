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
        let api = routes.grouped("api")
        
        // POST: /rental
        //        api.post("rental", use: create)
        // POST: api/rental1
        api.post("rental1", use: create1)
        // GET: /rental
       api.get("rental1", use: getAll)
//        // GET: /rental/:rentalId
        api.get(":rentalId", use: getById)
//        // PUT: /rental/:rentalId
//        api.put(":rentalId", use: update)
//        // DELETE: /rental/:rentalId
//        api.delete(":rentalId", use: delete)
        
    }
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
           
    // GET: /rentals/:rentalId (exemplo)
      func getById(req: Request) async throws -> Rental {
          guard let rentalId = req.parameters.get("rentalId", as: UUID.self) else {
              throw Abort(.badRequest, reason: "Invalid or missing rental ID.")
          }
          
          guard let rental = try await Rental.query(on: req.db)
              .with(\.$movies)
              .filter(\.$id == rentalId)
              .first() else {
              throw Abort(.notFound, reason: "Rental not found.")
          }
          
          return rental
      }
    func getAll(req: Request) async throws -> [Rental] {
          // Consulta todos os Rentals e inclui os filmes associados
          return try await Rental.query(on: req.db)
              .with(\.$movies) // Inclui os filmes associados a cada Rental
              .all()
      }
        
        // POST: /rental
        //    func create(req: Request) async throws -> Rental {
        //           // Decodifica os dados recebidos da requisição
        //           let createRentalData = try req.content.decode(CreateRentalData.self)
        //
        //           // Cria um novo Rental
        //           let rental = Rental(name: createRentalData.name)
        //
        //           // Salva o Rental no banco de dados
        //           try await rental.save(on: req.db)
        //
        //           // Verifica se os Movie IDs são válidos e existem no banco de dados
        //           let movies = try await Movie.query(on: req.db)
        //               .filter(\.$id ~~ createRentalData.movieIds)
        //               .all()
        //
        //           // Associa os filmes ao Rental
        //           try await rental.$movies.attach(movies, on: req.db)
        //
        //           // Retorna o Rental criado
        //           return rental
        //       }
        
        
//        // GET: /rentals
//        func getAll(req: Request) async throws -> [Rental] {
//            return try await Rental.query(on: req.db).with(\.$movies).all()
//        }
//        
//        // GET: /rentals/:rentalId
//        func getById(req: Request) async throws -> Rental {
//            guard let rentalId = req.parameters.get("rentalId", as: UUID.self) else {
//                throw Abort(.badRequest, reason: "Invalid or missing rental ID.")
//            }
//            guard let rental = try await Rental.query(on: req.db).with(\.$movies).filter(\.$id == rentalId).first() else {
//                throw Abort(.notFound, reason: "Rental not found.")
//            }
//            return rental
//        }
//        
//        // PUT: /rentals/:rentalId
//        func update(req: Request) async throws -> Rental {
//            guard let rentalId = req.parameters.get("rentalId", as: UUID.self) else {
//                throw Abort(.badRequest, reason: "Invalid or missing rental ID.")
//            }
//            guard let rental = try await Rental.find(rentalId, on: req.db) else {
//                throw Abort(.notFound, reason: "Rental not found.")
//            }
//            
//            let updateData = try req.content.decode(Rental.self)
//            rental.name = updateData.name
//            
//            try await rental.update(on: req.db)
//            return rental
//        }
        
        // DELETE: /rentals/:rentalId
//        func delete(req: Request) async throws -> HTTPStatus {
//            guard let rentalId = req.parameters.get("rentalId", as: UUID.self) else {
//                throw Abort(.badRequest, reason: "Invalid or missing rental ID.")
//            }
//            guard let rental = try await Rental.find(rentalId, on: req.db) else {
//                throw Abort(.notFound, reason: "Rental not found.")
//            }
//            
//            try await rental.delete(on: req.db)
//            return .noContent
//        }
//    }
}
