import Fluent
import Vapor

public class ClientLogEntry: Model, @unchecked Sendable {
    public static let schema = "client_logs"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "app_id")
    var appId: String

    @Field(key: "app_version")
    var appVersion: String

    @Field(key: "app_build")
    var appBuild: String

    @Field(key: "date")
    var date: Date

    @Field(key: "label")
    var label: String

    @Field(key: "level")
    var level: Logger.Level

    @Field(key: "message")
    var message: String

    @Field(key: "metadata")
    var metadata: String

    @Field(key: "source")
    var source: String

    @Field(key: "file")
    var file: String

    @Field(key: "function")
    var function: String

    @Field(key: "line")
    var line: Int

    @Field(key: "user")
    var user: String?

    @Field(key: "device_id")
    var deviceId: String?

    required public init() {}

    public init(
        id: UUID? = nil,
        appId: String,
        appVersion: String,
        appBuild: String,
        date: Date,
        label: String,
        level: Logger.Level,
        message: String,
        metadata: String,
        source: String,
        file: String,
        function: String,
        line: Int,
        user: String?,
        deviceId: String?
    ) {
        self.id = id
        self.appId = appId
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.date = date
        self.label = label
        self.level = level
        self.message = message
        self.metadata = metadata
        self.source = source
        self.file = file
        self.function = function
        self.line = line
        self.user = user
        self.deviceId = deviceId
    }
}

struct CreateClientLogTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ClientLogEntry.schema)
            .id()
            .field("app_id", .string, .required)
            .field("app_version", .string, .required)
            .field("app_build", .string, .required)
            .field("date", .datetime, .required)
            .field("label", .string, .required)
            .field("level", .string, .required)
            .field("message", .string, .required)
            .field("metadata", .string, .required)
            .field("source", .string, .required)
            .field("file", .string, .required)
            .field("function", .string, .required)
            .field("line", .int, .required)
            .field("user", .string)
            .field("device_id", .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ClientLogEntry.schema).delete()
    }
}
