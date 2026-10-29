import Vapor

func routes(_ app: Application) throws {
    app.get("health") { _ in HealthResponse(status: "ok", service: "MeepleMeetAPI") }
    try app.register(collection: GamesController())
}

struct HealthResponse: Content {
    let status: String
    let service: String
}
