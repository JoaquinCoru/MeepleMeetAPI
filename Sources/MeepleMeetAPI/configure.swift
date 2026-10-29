import Fluent
import FluentSQLiteDriver
import Vapor

func configure(_ app: Application) async throws {
    let databasePath = Environment.get("DATABASE_PATH") ?? app.directory.workingDirectory + "meeplemeet.sqlite"
    app.databases.use(.sqlite(.file(databasePath)), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateGame())
    // Los datos de demostración solo se cargan en el entorno local de desarrollo.
    if app.environment == .development {
        app.migrations.add(SeedSampleGames())
    }
    app.migrations.add(CreateCollectionEntry())
    app.migrations.add(CreateMeetup())
    app.migrations.add(CreateMeetupParticipant())

    try routes(app)
    try await app.autoMigrate()
}
