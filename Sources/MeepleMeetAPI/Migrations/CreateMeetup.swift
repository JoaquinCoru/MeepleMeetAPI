import Fluent

struct CreateMeetup: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Meetup.schema).id()
            .field("title", .string, .required).field("description", .string)
            .field("starts_at", .datetime, .required).field("location", .string, .required)
            .field("capacity", .int, .required)
            .field("host_id", .uuid, .required, .references(User.schema, .id, onDelete: .restrict))
            .field("game_id", .uuid, .required, .references(Game.schema, .id, onDelete: .restrict))
            .field("created_at", .datetime).field("updated_at", .datetime).field("deleted_at", .datetime).create()
    }
    func revert(on database: any Database) async throws { try await database.schema(Meetup.schema).delete() }
}
