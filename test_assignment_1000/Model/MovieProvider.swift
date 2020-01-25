import Foundation
import UIKit

class MovieProvider {
    let realmOps = RealmOps()
    let networkDataFetcher = NetworkDataFetcher()
    // Temporary storage variables
    var webResponse: [Movie] = []
    // API Key
    let apiKey = "c6fdb650c16287264a1f7dc6df982f84"
    var imageCache = NSCache<NSString, UIImage>()
    private func sendNotification() {
        NotificationCenter.default.post(name: Constants.notificationName, object: nil, userInfo: nil)
    }
    private func sendRefreshNotification() {
        NotificationCenter.default.post(name: Constants.notificationRefresh, object: nil, userInfo: nil)
    }
    
    func urlBuilder (apiKey : String, page : Int) -> String {
        let result = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)&page=\(page)"
        return result
    }
    //MARK:- iamge download function
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let `self` = self else {
                        return
                }
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
    //MARK:- Generating list of movies
    func generateMovies (givenPage : Int) {
        self.networkDataFetcher.fetchData(urlString: urlBuilder(apiKey: self.apiKey, page: givenPage)) { (webResponse) in
            self.webResponse = webResponse.results
            DispatchQueue.main.async {
                self.realmOps.saveData(movies: self.webResponse)
                self.sendNotification()
            }
        }
    }
    let dispatchGroup = DispatchGroup()
    func generateRefreshedMovies (givenPage: Int) {
        realmOps.flushCache()
        self.webResponse = []
        for i in 1...givenPage {
            dispatchGroup.enter()
            self.networkDataFetcher.fetchData(urlString: urlBuilder(apiKey: self.apiKey, page: i)) { (webResponse) in
                print(self.urlBuilder(apiKey: self.apiKey, page: i))
                self.webResponse.append(contentsOf: webResponse.results)
                self.dispatchGroup.leave()
            }
            
        }
        dispatchGroup.notify(queue: .main) {
            self.realmOps.saveData(movies: self.webResponse)
            self.sendRefreshNotification()
        }
    }
    
}
