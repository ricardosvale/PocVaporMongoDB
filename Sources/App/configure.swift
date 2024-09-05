import Fluent
import FluentMongoDriver
import Vapor


// Configura a sua aplicação
@available(iOS 13.0.0, *)
public func configure(_ app: Application) async throws {
    // Atualize a string de conexão com a senha codificada
   
    try app.databases.use(.mongo(connectionString: "mongodb+srv://ricardost3:ricardo123@clusterpoc.ha3do.mongodb.net/pocvapordb?retryWrites=true&w=majority&appName=ClusterPOC"), as: .mongo)
    // Registrar os Controllers
    try app.register(collection: RentalController())
    try app.register(collection: MoviesController())
    
    // Registra a migração
       app.migrations.add(CreateMovie())
       
       // Roda as migrações
       try app.autoMigrate().wait()
    
    
    // Registre as rotas
    try routes(app)
}



