import Fluent
import Vapor

final class Meetup: Model, Content, @unchecked Sendable {
    static let schema = "meetups"
    @ID(key: .id) var id: UUID?
    @Field(key: "title") var title: String
    @OptionalField(key: "description") var description: String?
    @Field(key: "starts_at") var startsAt: Date
    @Field(key: "location") var location: String
    @Field(key: "capacity") var capacity: Int
    @Parent(key: "host_id") var host: User
    @Parent(key: "game_id") var game: Game
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?
    init() {}
}
