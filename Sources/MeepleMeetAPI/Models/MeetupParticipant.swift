import Vapor
import Fluent

final class MeetupParticipant: Model, @unchecked Sendable {
    static let schema = "meetup_participants"
    @ID(key: .id) var id: UUID?
    @Parent(key: "meetup_id") var meetup: Meetup
    @Parent(key: "user_id") var user: User
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    init() {}
    init(meetupID: Meetup.IDValue, userID: User.IDValue) { $meetup.id = meetupID; $user.id = userID }
}
