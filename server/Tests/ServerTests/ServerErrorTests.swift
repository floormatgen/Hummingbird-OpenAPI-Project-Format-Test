import Testing
@testable import Server

import OpenAPIRuntime
import Hummingbird
import HummingbirdTesting

@Suite
struct ServerErrorTests {
    let app: AppType

    init() async throws {
        self.app = try await buildApplication()
    }

    @Test("Missing key returns bad request")
    func missingKeyReturnsBadRequest() async throws {
        try await app.test(.router) { client in 
            let response = try await client.execute(
                uri: "/reverse", method: .post, 
                body: .init(string: "{ }")
            )
            #expect(response.status == .badRequest)
        }
    }

}