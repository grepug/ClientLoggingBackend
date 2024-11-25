import Fluent
import Vapor

extension Request {
    public var bodyData: Data? {
        guard let buffer = self.body.data else {
            return nil
        }

        return .init(buffer: buffer)
    }
}

public struct ClientLoggingController: RouteCollection, Sendable {
    var extractBodyData: @Sendable (Request) -> Data?

    public init(extractBodyData: @escaping @Sendable (Request) -> Data? = { $0.bodyData }) {
        self.extractBodyData = extractBodyData
    }

    public func boot(routes: any RoutesBuilder) throws {
        let clientLoggingRoutes = routes.grouped("client-log")

        clientLoggingRoutes.post(use: logClient)
    }

    @Sendable
    func logClient(_ req: Request) async throws -> String {
        guard let data = extractBodyData(req), let logItem = try? JSONDecoder().decode(ClientLogItemDto.self, from: data) else {
            throw Abort(.badRequest)
        }

        let logs = logItem.logItems.map { logItem in
            ClientLogEntry(
                appId: logItem.appId,
                appVersion: logItem.appVersion,
                appBuild: logItem.appBuild,
                date: logItem.date,
                label: logItem.label,
                level: logItem.level,
                message: logItem.message,
                metadata: logItem.metadata,
                source: logItem.source,
                file: logItem.file,
                function: logItem.function,
                line: Int(logItem.line),
                user: logItem.user,
                deviceId: logItem.deviceId
            )
        }

        try await logs.create(on: req.db)

        return "Logged"
    }
}

struct ClientLogItemDto: Content {
    let logItems: [LogItem]
}

public struct LogItem: Sendable, Content {
    let appId: String
    let appVersion: String
    let appBuild: String
    let date: Date
    let label: String
    let level: Logger.Level
    let message: String
    let metadata: String
    let source: String
    let file: String
    let function: String
    let line: UInt
    let user: String?
    let deviceId: String?
}
