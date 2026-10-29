import Fluent

struct CreateMeetupParticipant: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(MeetupParticipant.schema).id()
            .field("meetup_id", .uuid, .required, .references(Meetup.schema, .id, onDelete: .cascade))
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("created_at", .datetime).unique(on: "meetup_id", "user_id").create()
    }
    func revert(on database: any Database) async throws { try await database.schema(MeetupParticipant.schema).delete() }
}
