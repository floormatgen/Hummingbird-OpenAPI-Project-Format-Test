import OpenAPIRuntime
import Hummingbird

struct ServiceImplementation: APIProtocol {

    func getHello(
        _ input: Operations.GetHello.Input
    ) async throws -> Operations.GetHello.Output {
        if let name = input.query.name {
            let greeting = "hello, \(name)"
            return .ok(.init(body: .plainText(.init(greeting))))
        } else {
            let greeting = "hello"
            return .ok(.init(body: .plainText(.init(greeting))))
        }
    }

    func postReverse(
        _ input: Operations.PostReverse.Input
    ) async throws -> Operations.PostReverse.Output {
        switch input.body {
        case .json(let input):
            return .ok(.init(body: .json(.init(
                original: input.original, reversed: String(input.original.reversed())
            ))))
        }
    }
    
}