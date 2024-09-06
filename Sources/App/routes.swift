import Vapor


func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
        
    }
    app.get("movies") { req async -> String in
        "movies"
    }
    app.get("rental") { req async -> String in
            "rental"
    }
}
