import Fluent

struct CreateCollectionEntry: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(CollectionEntry.schema).id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("game_id", .uuid, .required, .references(Game.schema, .id, onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "user_id", "game_id").create()
    }
    func revert(on database: any Database) async throws { try await database.schema(CollectionEntry.schema).delete() }
}
