import Fluent

struct SeedSampleGames: AsyncMigration {
    private struct SampleGame: Sendable {
        let title: String
        let description: String
        let minPlayers: Int
        let maxPlayers: Int
        let durationMinutes: Int
        let rulesURL: String
        let imageURL: String
    }

    private let games = [
        SampleGame(
            title: "Catán",
            description: "Coloniza la isla, reúne recursos y comercia para construir pueblos, ciudades y caminos.",
            minPlayers: 3, maxPlayers: 4, durationMinutes: 90,
            rulesURL: "https://www.devir.es/wp-content/uploads/2014/04/Catan_reglamento_Devir-ES.pdf",
            imageURL: "https://www.catan.com/sites/default/files/2025-04/3DBox_CATAN_BaseGame_NE.png"
        ),
        SampleGame(
            title: "Wingspan",
            description: "Atrae aves a tus hábitats y combina sus habilidades para conseguir la mayor puntuación.",
            minPlayers: 1, maxPlayers: 5, durationMinutes: 55,
            rulesURL: "https://stonemaiergames.com/games/wingspan/rules/",
            imageURL: "https://store.stonemaiergames.com/cdn/shop/products/3d-wingspan_1200x1200.png?v=1569132201"
        ),
        SampleGame(
            title: "Azul",
            description: "Selecciona azulejos de colores y crea un mosaico en tu tablero intentando optimizar la puntuación.",
            minPlayers: 2, maxPlayers: 4, durationMinutes: 40,
            rulesURL: "https://cdn.svc.asmodee.net/production-asmodeees/uploads/2023/06/Reglas_Azul.pdf",
            imageURL: "https://cdn.svc.asmodee.net/production-asmodeees/uploads/image-converter/2023/06/NMG60010ES_1-1.webp"
        ),
        SampleGame(
            title: "Ark Nova",
            description: "Diseña y desarrolla un zoo moderno, alberga animales y apoya proyectos de conservación.",
            minPlayers: 1, maxPlayers: 4, durationMinutes: 120,
            rulesURL: "https://tienda.malditogames.com/487-ark-nova.html",
            imageURL: "https://devirinvestments.s3.eu-west-1.amazonaws.com/img/catalog/product/8436578815265-1200-face3d.jpg"
        ),
        SampleGame(
            title: "Dixit",
            description: "Interpreta ilustraciones oníricas con pistas sugerentes y trata de que algunos, pero no todos, te entiendan.",
            minPlayers: 3, maxPlayers: 8, durationMinutes: 30,
            rulesURL: "https://cdn.svc.asmodee.net/production-asmodeees/uploads/2023/06/LIBDIX01ML2_Reglamento_ES.pdf",
            imageURL: "https://cdn.svc.asmodee.net/production-asmodeees/uploads/image-converter/2023/06/libdix01ml2_01.webp"
        ),
        SampleGame(
            title: "La Tripulación: En busca del noveno planeta",
            description: "Juego cooperativo de bazas y misiones en el que la tripulación debe coordinarse con comunicación limitada.",
            minPlayers: 2, maxPlayers: 5, durationMinutes: 20,
            rulesURL: "https://devirinvestments.s3.eu-west-1.amazonaws.com/media/8436589620605-Rules-ES-1.pdf",
            imageURL: "https://store.thamesandkosmos.com/cdn/shop/products/TheCrew_3DBox.jpg?v=1667421243"
        )
    ]

    // Incluye el nombre previo de The Crew para limpiar una siembra anterior.
    private let previousTitles = ["The Crew: The Quest for Planet Nine"]

    func prepare(on database: any Database) async throws {
        // Esta migración se ejecuta una vez en desarrollo. Limpiamos únicamente
        // los títulos administrados por la semilla y los recreamos con sus datos actuales.
        for title in games.map(\.title) + previousTitles {
            try await Game.query(on: database)
                .filter(\.$title == title)
                .delete()
        }

        for sample in games {
            try await Game(
                title: sample.title,
                description: sample.description,
                minPlayers: sample.minPlayers,
                maxPlayers: sample.maxPlayers,
                durationMinutes: sample.durationMinutes,
                rulesURL: sample.rulesURL,
                image: sample.imageURL
            ).save(on: database)
        }
    }

    func revert(on database: any Database) async throws {
        for title in games.map(\.title) + previousTitles {
            try await Game.query(on: database)
                .filter(\.$title == title)
                .delete()
        }
    }
}
