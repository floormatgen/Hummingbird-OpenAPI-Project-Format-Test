import Testing
@testable import Server

import OpenAPIRuntime

@Suite
struct ReverseTests {
    let impl: ServiceImplementation

    init() async throws {
        self.impl = .init()
    }

    @Test("Reverse works correctly", arguments: [ "foo", "bar", "baz", "a", "12345" ])
    func reverseWorksCorrectly(_ testString: String) async throws {
        let response = try await impl.postReverse(.init(body: .json(.init(original: testString))))
        let responseData = try response.ok.body.json
        let reversed = responseData.reversed
        let original = responseData.original
        #expect(original == testString)
        #expect(reversed == String(testString.reversed()))
    }

}