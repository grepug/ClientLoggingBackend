import Fluent
import Vapor

extension DatabaseID {
    public static var logging: Self {
        .init(string: "logging")
    }
}

public func configureLoggingDatabase(
    app: Application,
    dbFactory factory: DatabaseConfigurationFactory,
    extractBodyData: @escaping @Sendable (Request) -> Data? = { $0.bodyData }
) throws {
    app.databases.use(factory, as: .logging)
    app.migrations.add(CreateClientLogTable())

    try app.routes.register(collection: ClientLoggingController(extractBodyData: extractBodyData))
}
