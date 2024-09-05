//
//  File.swift
//  
//
//  Created by Ricardo Silva Vale on 05/09/24.
//

import Fluent
import FluentMongoDriver

struct CreateMovie: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("movies")
            .id() // Cria uma coluna de ID única
            .field("title", .string, .required) // Campo obrigatório para o título do filme
            .field("year", .int, .required) // Campo obrigatório para o ano do filme
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("movies").delete()
    }
}
