@testable import App
import Vapor
import FluentPostgreSQL

extension Application {
    static func testable() throws -> Application {
        let ap: Application = try! app(Environment.testing)
        return ap
    }

    func sendRequest<Body>(to path: String, method: HTTPMethod, headers: HTTPHeaders = .init(), body: Body?, isLoggedInRequest: Bool = false) throws -> Response where Body: Content {
        let headers: HTTPHeaders = headers
       /* if isLoggedInRequest {
            let credentials = BasicAuthorization(username: "admin", password: "password")
            var tokenHeaders = HTTPHeaders()
            tokenHeaders.basicAuthorization = credentials
            let tokenBody: EmptyBody? = nil
            let tokenResponse = try sendRequest(to: "api/users/login", method: .POST, headers: tokenHeaders, body: tokenBody)
            let token = try tokenResponse.content.decode(Token.self).wait()
            headers.add(name: .authorization, value: "Bearer \(token.token)")
        }
*/
        let httpRequest = HTTPRequest(method: method, url: URL(string: path)!, headers: headers)
        let wrappedRequest = Request(http: httpRequest, using: self)
        if let body: Body = body {
            try wrappedRequest.content.encode(body)
        }
        let responder: Responder = try make(Responder.self)

        return try responder.respond(to: wrappedRequest).wait()
    }
}

struct EmptyBody: Content {}
