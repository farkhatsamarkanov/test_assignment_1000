import Foundation
//MARK:- Networking class
class NetworkDataFetcher {
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    print("Error at sending http request")
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
        }.resume()
    }
    func fetchData(urlString: String, response: @escaping (Movies) -> Void) {
        request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let recievedData = try JSONDecoder().decode(Movies.self, from: data)
                    response(recievedData)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
            }
        }
    }
}


