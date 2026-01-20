import Testing
@testable import Server

import OpenAPIRuntime
import Hummingbird
import HummingbirdTesting

@Suite
struct GreetingTests {
    let hander: some APIProtocol = ServiceImplementation()

    static let bufferLimit = 1024

    @Test("Default Greeting")
    func defaultGreetingIsCorrect() async throws {
        let response = try await hander.getHello()
        let greeting = try await String(collecting: try response.ok.body.plainText, upTo: Self.bufferLimit)
        #expect(greeting == "hello")
    }

    @Test("Custom Greeting", arguments: [ "Alice", "Bob", "Charlie" ])
    func customGreetingIsCorrect(_ name: String) async throws {
        let response = try await hander.getHello(.init(query: .init(name: "John")))
        let greeting = try await String(collecting: try response.ok.body.plainText, upTo: Self.bufferLimit)
        #expect(greeting == "hello, John")
    }

}
