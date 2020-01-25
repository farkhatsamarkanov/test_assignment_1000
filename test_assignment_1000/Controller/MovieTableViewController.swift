import UIKit

class MovieTableViewController: UITableViewController {
    //MARK:- Variables
    var page = 1
    var fetchingMore = false
    var movies :[MovieCached] = []
    var movieProvider : MovieProvider?
    // Realm database for caching
    let realmOps = RealmOps()
    let listOfGenres  = ["28":"Action", "12":"Adventure", "16":"Animation", "35":"Comedy", "80":"Crime", "99":"Documentary", "18":"Drama", "10751":"Family", "14":"Fantasy", "36":"History", "27":"Horror", "10402":"Music", "9648":"Mystery", "10749":"Romance", "878":"Science Fiction", "10770":"TV Movie", "53":"Thriller", "10752":"War", "37":"Western"]
    var refreshIsAllowed = true
    //MARK:- Pull to refresh implementation
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    @objc private func refresh (sender: UIRefreshControl)  {
        if refreshIsAllowed {
            print("refreshing")
            movieProvider?.generateRefreshedMovies(givenPage: page)
            refreshIsAllowed = false
        }
        sender.endRefreshing()
    }
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = GradientView(frame: self.view.bounds)
        tableView.backgroundView = gradientView
        movieProvider = MovieProvider()
         // observers for new data (Added second observer for preventing database conflicts)
        NotificationCenter.default.addObserver(self, selector: #selector(received(notif:)), name: Constants.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRefresh(notif:)), name: Constants.notificationRefresh, object: nil)
        // looking for cached data
        movies = realmOps.readData()
        if !movies.isEmpty {
            page = movies.count/20
        } else {
            movieProvider?.generateMovies(givenPage: page)
        }
        tableView.refreshControl = myRefreshControl
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCellIdentifier", for: indexPath) as! MoviesCell
        let movie = movies[indexPath.row]
        if let unwrappedURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
            movieProvider?.downloadImage(url: unwrappedURL, completion: { image in
                cell.posterView.image = image
            })
        }
        cell.TitleLabel.text = movie.title
        cell.ReleaseDateLabel.text = movie.releaseDate
        cell.RatingLabel.text = movie.voteAverage
        let genresArray = movie.genreIDS.components(separatedBy: ",")
        var genresToLabel = ""
        for i in genresArray {
            if let genre = listOfGenres[i] {
                genresToLabel += "\(genre)  "
            }
        }
        cell.GenresLabel.text = genresToLabel
        cell.backgroundCardView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.backgroundCardView.layer.cornerRadius = 8.0
        cell.backgroundCardView.layer.masksToBounds = true
        cell.shadowView.backgroundColor = UIColor.clear
        return cell
    }
    
    //MARK:-Table view delegate metods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    //MARK:- Pagination implementation
    
    //begin fetching new elements when at the bottom of tableView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if contentHeight != 0.0 {
            if offsetY > contentHeight - scrollView.frame.height {
                if !fetchingMore {
                    beginBatchFetch()
                    print("batch fetch")
                }
            }
        }
    }
    
    func beginBatchFetch () {
        fetchingMore = true
        page += 1
        movieProvider?.generateMovies(givenPage: page)
    }
    
    //MARK:- Observing for new data
    
    @objc func received(notif: Notification) {
        fetchingMore = false
        movies = realmOps.readData()
        tableView.reloadData()
    }
    
    @objc func receivedRefresh(notif: Notification) {
        fetchingMore = false
        movies = realmOps.readData()
        refreshIsAllowed = true
        tableView.reloadData()
    }
    
    //MARK:- Sending data to detail view
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetail" else {return}
        if let movieDetail = segue.destination as? DetailViewController {
            if let cell = sender as? MoviesCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let movie = movies[indexPath.row]
                    movieDetail.movieDetail = movie
                }
            }
        }
    }
}
