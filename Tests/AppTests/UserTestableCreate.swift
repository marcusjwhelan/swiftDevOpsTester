@testable import App
import Crypto
import Vapor
import FluentPostgreSQL

extension User {
    static func create(username: String, password: String, on conn: PostgreSQLConnection) throws -> User {
        let user: User = User(username: username, password: password)
        return try user.save(on: conn).wait()
    }
}