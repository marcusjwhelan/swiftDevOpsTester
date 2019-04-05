import Vapor
import Fluent
import Crypto

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let usersRouter: Router = router.grouped("users")
        usersRouter.get("/", use: list)
        usersRouter.get(User.parameter, use: show)
        usersRouter.post("/", use: create)
        usersRouter.patch(User.parameter, use: update)
        usersRouter.delete(User.parameter, use: remove)
    }
    private func hash(_ req: Request, _ user: User) throws -> String {
        let hasher: BCryptDigest = try req.make(BCryptDigest.self)
        guard let hashedPass: String = try? hasher.hash(user.password) else {
            throw Abort(.internalServerError, reason: "Unable to hash password")
        }
        return hashedPass
    }
    /*
        returns array list of users by request url/users
    */
    // func list(_ req: Request) throws -> Future<[User]> {
    func list(_ req: Request) throws -> String {
        return "hello"
    }
    /*
        returns the User based on the sent Id
    */
    func show(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    /*
        creates a user given content {username: "", password: ""}
        hashes the password
        returns the created user
    */
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self)
            .flatMap(to: User.self) { (user: User) in
                let hashedPass: String = try self.hash(req, user)
                user.password = hashedPass
                return user.save(on: req)
            }
    }
    /*
        Update the sent id user given incoming content
        hash new password
        finally return new updated user
    */
    func update(_ req: Request) throws -> Future<User> {
        return flatMap(to: User.self, try req.parameters.next(User.self), try req.content.decode(User.self)) { (user: User, updatedUser: User) in
            let hashedPass: String = try self.hash(req, updatedUser)
            user.password = hashedPass
            user.username = updatedUser.username
            return user.save(on: req)
        }
    }
    /*
        Remove user depending on Id
    */
    func remove(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { (user: User) in
                return user.delete(on: req).transform(to: HTTPStatus.noContent)
            }
    }
}