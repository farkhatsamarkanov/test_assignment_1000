import Foundation
import RealmSwift
//MARK:- Realm DB classes
class MovieCached : Object {
    @objc dynamic var id = ""
    @objc dynamic var voteCount = ""
    @objc dynamic var voteAverage = ""
    @objc dynamic var title = ""
    @objc dynamic var releaseDate = ""
    @objc dynamic var originalLanguage  = ""
    @objc dynamic var originalTitle = ""
    @objc dynamic var genreIDS = ""
    @objc dynamic var overview = ""
    @objc dynamic var posterPath = ""
    @objc dynamic var popularity = ""
}
