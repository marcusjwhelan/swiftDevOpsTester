import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let directoryConfig = DirectoryConfig.detect() // access to this directory?
    services.register(directoryConfig)

    // configure postgres
    let db: PostgreSQLDatabase
    if env.isRelease {
        let port: String? = Environment.get("PORT")
        let hostName: String? = Environment.get("HOST")
        let username: String? = Environment.get("USERNAME")
        let password: String? = Environment.get("PASSWORD")
        let database: String? = Environment.get("DB")
        let portValue = Int(port!)!

        let d = PostgreSQLDatabaseConfig(
                hostname: hostName!,
                port: portValue,
                username: username!,
                database: database!,
                password: password!,
                transport: .cleartext
        )
        db = PostgreSQLDatabase(config: d)
    } else {
        let d = PostgreSQLDatabaseConfig(
                hostname: "127.0.0.1",
                port: 5432,
                username: "postgres",
                database: "devopstester",
                password: "marcus",
                transport: .cleartext
        )
        db = PostgreSQLDatabase(config: d)
    }

    services.register(db)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)
}
