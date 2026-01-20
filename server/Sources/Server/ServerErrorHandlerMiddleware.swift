import Foundation
import OpenAPIRuntime
import Hummingbird
import Logging

struct ServerErrorHandlerMiddleware<Context: RequestContext>: RouterMiddleware {
    let logLevel: Logger.Level

    init(logLevel: Logger.Level = .debug) {
        self.logLevel = logLevel
    }
    
    func handle(
        _ input: Request, context: Context, 
        next: @concurrent (Request, Context) async throws -> Response
    ) async throws -> Response {
        do {
            return try await next(input, context)
        } catch let serverError as ServerError {
            let underlying = serverError.underlyingError

            var response = try context.responseEncoder.encode(Components.Schemas.BasicError(
                operationID: serverError.operationID, 
                reason: underlying.localizedDescription
            ), from: input, context: context)

            switch underlying {
                case is DecodingError:
                    response.status = .badRequest
                default:
                    response.status = .internalServerError
            }

            return response
        } catch {
            throw error
        }
    }

}
