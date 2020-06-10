import Leaf
import Vapor
import Fluent
import FluentSQLite

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure the rest of your application here
    
    //Register Leaf which is in Resources/Views
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    //Configuring database
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    try services.register(FluentSQLiteProvider())
    
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)database.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    //Migration
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Restaurant.self, database: DatabaseIdentifier<Restaurant.Database>.sqlite)
    migrationConfig.add(model: Order.self, database: DatabaseIdentifier<Order.Database>.sqlite)
    services.register(migrationConfig)
    
    //Open Laptop ports
//    let serverPortsConfig = NIOServerConfig.default(hostname: "192.168.1.128")
//    services.register(serverPortsConfig)
}
