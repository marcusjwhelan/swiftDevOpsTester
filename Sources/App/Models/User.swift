import Vapor
import Foundation
import FluentPostgreSQL

final class User: Content {
    var id: Int?
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension User: PostgreSQLModel {}
extension User: Parameter {}
extension User: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { (builder) in
            try addProperties(to: builder)
            builder.unique(on: \.username)
        }
    }
}
