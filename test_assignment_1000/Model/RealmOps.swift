import Foundation
import RealmSwift
//MARK:- Realm DB operations
class RealmOps {
    //MARK:- Saving to DB
    func saveData(movies:[Movie]) {
        do {
            let realm = try! Realm()
            try realm.write {
                //let result = realm.objects(MovieCached.self)
                // realm.delete(result)
                let moviesRealm = moviesConverter(movies: movies)
                for i in moviesRealm {
                    realm.add(i)
                }
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    
    //MARK:- reading from DB classes
    func readData() -> [MovieCached] {
        var movies: [MovieCached] = []
        do {
            let realm = try Realm()
            let result = realm.objects(MovieCached.self)
            for movie in result {
                let movieModel = movie
                movies.append(movieModel)
            }
        } catch {
            print("Error while reading data from Realm: \(error)")
        }
        return movies
    }
    
    //MARK:- Delete cache
    func flushCache () {
        do {
            let realm = try! Realm()
            try realm.write {
                let result = realm.objects(MovieCached.self)
                realm.delete(result)
            }
        } catch {
            print("Error while flushing cache: \(error)")
        }
    }
    
    //MARK:- Convertign network data to cached data
    
    func moviesConverter (movies: [Movie]) -> [MovieCached] {
        var moviesRealm: [MovieCached] = []
        for movie in movies {
            let movieRealm = MovieCached()
            movieRealm.id = "\(movie.id ?? 0)"
            movieRealm.voteCount = "\(movie.voteCount ?? 0)"
            movieRealm.voteAverage = "\(movie.voteAverage ?? 0.0)"
            movieRealm.title = "\(movie.title ?? "")"
            movieRealm.releaseDate = "\(movie.releaseDate ?? "")"
            movieRealm.originalLanguage = "\(movie.originalLanguage ?? "")"
            movieRealm.originalTitle = "\(movie.originalTitle ?? "")"
            movieRealm.posterPath = "\(movie.posterPath ?? "")"
            movieRealm.overview = "\(movie.overview ?? "")"
            movieRealm.popularity = "\(movie.popularity ?? 0.0)"
            var bufferArray : [Int] = []
            for i in movie.genreIDS {
                if let unwrapperdGenreID = i {
                    bufferArray.append(unwrapperdGenreID)
                }
            }
            for i in bufferArray {
                movieRealm.genreIDS += "\(i),"
            }
            moviesRealm.append(movieRealm)
        }
        return moviesRealm
    }
    
}
