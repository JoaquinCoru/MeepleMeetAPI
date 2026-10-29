import Fluent
import Vapor

final class Game: Model, Content, @unchecked Sendable {
    static let schema = "games"
    @ID(key: .id) var id: UUID?
    @Field(key: "title") var title: String
    @OptionalField(key: "description") var description: String?
    @OptionalField(key: "min_players") var minPlayers: Int?
    @OptionalField(key: "max_players") var maxPlayers: Int?
    @OptionalField(key: "duration_minutes") var durationMinutes: Int?
    @OptionalField(key: "rules_url") var rulesURL: String?
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?

    init() {}
    init(id: UUID? = nil, title: String, description: String? = nil, minPlayers: Int? = nil,
         maxPlayers: Int? = nil, durationMinutes: Int? = nil, rulesURL: String? = nil) {
        self.id = id; self.title = title; self.description = description
        self.minPlayers = minPlayers; self.maxPlayers = maxPlayers
        self.durationMinutes = durationMinutes; self.rulesURL = rulesURL
    }
}
