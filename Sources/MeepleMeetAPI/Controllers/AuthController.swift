import Fluent
import JWT
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("api", "v1", "auth")
        auth.post("register", use: register)
        let login = auth.grouped(User.authenticator(), User.guardMiddleware())
        login.post("login", use: self.login)
    }

    func register(req: Request) async throws -> HTTPStatus {
        let input = try req.content.decode(RegisterRequest.self)
        let name = input.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = input.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let password = input.password

        guard !name.isEmpty, email.contains("@"), password.count >= 8 else {
            throw Abort(.badRequest, reason: "Nombre, email válido y contraseña de al menos 8 caracteres son obligatorios.")
        }

        if try await User.query(on: req.db).filter(\.$email == email).first() != nil {
            throw Abort(.conflict, reason: "Ya existe una cuenta con ese email.")
        }

        let user = User(name: name, email: email, passwordHash: try Bcrypt.hash(password))
        try await user.save(on: req.db)
        return .created
    }

    func login(req: Request) async throws -> LoginResponse {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let payload = MeepleMeetTokenPayload(
            subject: SubjectClaim(value: userID.uuidString),
            expiration: ExpirationClaim(value: Date().addingTimeInterval(60 * 60 * 24)),
            issuer: IssuerClaim(value: "MeepleMeetAPI")
        )
        let token = try await req.jwt.sign(payload)
        return LoginResponse(token: token, user: PublicUserResponse(id: userID, name: user.name, email: user.email))
    }
}

private struct RegisterRequest: Content {
    let name: String
    let email: String
    let password: String
}

struct LoginResponse: Content {
    let token: String
    let user: PublicUserResponse
}

struct PublicUserResponse: Content {
    let id: UUID
    let name: String
    let email: String
}

struct MeepleMeetTokenPayload: JWTPayload {
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var issuer: IssuerClaim

    func verify(using algorithm: some JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
        guard issuer.value == "MeepleMeetAPI" else {
            throw JWTError.invalidHeaderField(reason: "El issuer no corresponde con este servicio.")
        }
    }
}
