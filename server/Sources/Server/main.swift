import OpenAPIRuntime
import OpenAPIHummingbird
import Hummingbird
import Logging

typealias AppType = Application<RouterResponder<BasicRequestContext>>

func buildApplication() async throws -> AppType {
    // Create your router.
    let router = Router()

    // Create an instance of your handler type that conforms the generated protocol
    // defining your service API.
    let api = ServiceImplementation()

    router.add(middleware: LogRequestsMiddleware(.debug))
    router.add(middleware: ServerErrorHandlerMiddleware(logLevel: .debug))

    // Call the generated function on your implementation to add its request
    // handlers to the app.
    try api.registerHandlers(on: router)

    // Logging
    var logger = Logger(label: "server")
    logger.logLevel = .debug

    let config = ApplicationConfiguration(address: .hostname("0.0.0.0"))

    // Create the application and run as you would normally.
    return AppType(router: router, configuration: config, logger: logger)
}

func main() async throws {
    let app = try await buildApplication()
    try await app.runService()
}

try await main()