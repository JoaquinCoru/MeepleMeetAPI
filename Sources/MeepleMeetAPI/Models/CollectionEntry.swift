import Vapor
import Fluent

final class CollectionEntry: Model, @unchecked Sendable {
    static let schema = "collection_entries"
    @ID(key: .id) var id: UUID?
    @Parent(key: "user_id") var user: User
    @Parent(key: "game_id") var game: Game
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    init() {}
    init(userID: User.IDValue, gameID: Game.IDValue) { $user.id = userID; $game.id = gameID }
}
