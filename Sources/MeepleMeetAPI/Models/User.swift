import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "email") var email: String
    @Field(key: "password_hash") var passwordHash: String
    @OptionalField(key: "bio") var bio: String?
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?

    init() {}
    init(id: UUID? = nil, name: String, email: String, passwordHash: String, bio: String? = nil) {
        self.id = id; self.name = name; self.email = email; self.passwordHash = passwordHash; self.bio = bio
    }
}
