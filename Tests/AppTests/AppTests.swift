@testable import App
import XCTest
import Dispatch
import FluentPostgreSQL
import Vapor

final class AppTests: XCTestCase {
    var uri: String = "/users"
    var username: String = "Tester"
    var password: String = "admin"
    var application: Application!
    var conn: PostgreSQLConnection!
    /*
        Set up application as testable environment
        for every test
    */
    override func setUp() {
        super.setUp()

        let ap = try! Application.testable()
        self.application = ap
        let con: PostgreSQLConnection = try! self.application.newConnection(to: .psql).wait()
        self.conn = con
    }
    /*
        Tear down application for every test
    */
    override func tearDown() {
        super.tearDown()
        self.conn.close()
        self.application = nil
    }
    // .delete "/users/:id" tests -> UserController.delete
    func RemoveUserTest() throws {
        let user: User = try User.create(username: self.username, password: self.password, on: conn)
        let body: EmptyBody? = nil
        let _ = try self.application.sendRequest(to: "\(self.uri)/\(user.id!)", method: .DELETE, body: body)
        let response: Response = try self.application.sendRequest(to: "\(self.uri)", method: .GET, body: body)
        let receivedStatus: [User] = try response.content.decode([User].self).wait()

        XCTAssertEqual(receivedStatus.count, 0)
    }

    /*
        Test Users controller integrateion with Postgres
    */
    func CreateListUserTest() throws {
        // .post "/users" tests -> UserController.create
        let user: User = User(username: self.username, password: self.password)
        let createUserResponse: Response = try application.sendRequest(to: self.uri, method: .POST, body: user)
        let createdUser: User = try createUserResponse.content.decode(User.self).wait()

        XCTAssertEqual(createdUser.username, self.username)
        XCTAssertEqual(createdUser.username, user.username)
        XCTAssertNotNil(createdUser.password)
        XCTAssertNotNil(createdUser.id)

        // .get "/users/:id" tests -> UserController.show
        let getBody: EmptyBody? = nil
        print(createdUser.id!)
        let getUserResponse: Response = try self.application.sendRequest(to: "\(self.uri)/\(createdUser.id!)", method: .GET, body: getBody)
        let receivedUser: User = try getUserResponse.content.decode(User.self).wait()

        XCTAssertEqual(receivedUser.username, user.username)
        XCTAssertNotNil(receivedUser.password)
        XCTAssertNotNil(receivedUser.id)

        let _ = try self.application.sendRequest(to: "\(self.uri)/\(receivedUser.id!)", method: .DELETE, body: getBody)
    }
    // .get "/users" tests -> UserController.list
    func ListUsersTest() throws {
        let user: User = try User.create(username: self.username, password: self.password, on: self.conn)
        let listBody: EmptyBody? = nil
        let getUsersResopnse: Response = try self.application.sendRequest(to: self.uri, method: .GET, body: listBody)
        let usersList: [User] = try getUsersResopnse.content.decode([User].self).wait()
        let lastUser: User = usersList.last!

        XCTAssertEqual(lastUser.username, user.username)
        XCTAssertNotNil(lastUser.password)
        XCTAssertNotNil(lastUser.id)
        XCTAssertEqual(usersList.count, 1)

        let _ = try self.application.sendRequest(to: "\(self.uri)/\(lastUser.id!)", method: .DELETE, body: listBody)
    }
    // .patch "/users/:id" tests -> UserController.update
    func UpdateUserTest() throws {
        let listBody: EmptyBody? = nil
        let user: User = try User.create(username: "vapor", password: "123", on: self.conn)
        let patchBody: [String: String] = ["username": self.username, "password": self.password]
        let updateResponse: Response = try self.application.sendRequest(to: "\(self.uri)/\(user.id!)", method: .PATCH, body: patchBody)
        let updatedUser: User = try updateResponse.content.decode(User.self).wait()

        XCTAssertNotEqual(user.username, self.username)
        XCTAssertEqual(updatedUser.id, user.id)
        XCTAssertNotNil(updatedUser.password)

        let _ = try self.application.sendRequest(to: "\(self.uri)/\(updatedUser.id!)", method: .DELETE, body: listBody)
    }

    static let allTests = [
        ("RemoveUserTest", RemoveUserTest),
        ("CreateListUserTest", CreateListUserTest),
        ("ListUsersTest", ListUsersTest),
        ("UpdateUserTest", UpdateUserTest)
    ]
}
