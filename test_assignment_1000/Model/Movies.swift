import Foundation

// MARK: - Movies
struct Movies: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Decodable {
    let id: Int?
    let voteCount: Int?
    let voteAverage: Double?
    let title, releaseDate: String?
    let originalLanguage: String?
    let originalTitle: String?
    let genreIDS: [Int?]
    let overview, posterPath: String?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case title
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case overview
        case posterPath = "poster_path"
        case popularity
    }
}
