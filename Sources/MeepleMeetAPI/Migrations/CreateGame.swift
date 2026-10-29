import Fluent

struct CreateGame: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Game.schema).id()
            .field("title", .string, .required).field("description", .string)
            .field("min_players", .int).field("max_players", .int)
            .field("duration_minutes", .int).field("rules_url", .string)
            .field("created_at", .datetime).field("updated_at", .datetime).create()
    }
    func revert(on database: any Database) async throws { try await database.schema(Game.schema).delete() }
}
