import Fluent
import Vapor

struct GamesController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let games = routes.grouped("api", "v1", "games")
        games.get(use: index)
        games.get(":gameID", use: show)
    }

    func index(req: Request) async throws -> [Game] {
        let query = req.query[String.self, at: "q"]
        var games = Game.query(on: req.db)
        if let query, !query.isEmpty {
            games = games.filter(\.$title ~~ "%\(query)%")
        }
        return try await games.sort(\.$title).all()
    }

    func show(req: Request) async throws -> Game {
        guard let game = try await Game.find(req.parameters.get("gameID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return game
    }
}
