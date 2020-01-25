
import UIKit

class DetailViewController: UIViewController {
    //MARK:- Outlets and vaiables:
    @IBOutlet weak var OverviewView: UITextView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GenresLabel: UILabel!
    @IBOutlet weak var PopularityLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var OriginalTitleLabel: UILabel!
    @IBOutlet weak var OriginalLanguageLabel: UILabel!
    @IBOutlet weak var VoteCountsLabel: UILabel!
    @IBOutlet weak var VoteAverageLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ReleaseDateLabel: UILabel!
    private var image: UIImage? {
        didSet {
            posterView.image = image
            imageActivityIndicator.stopAnimating()
            imageActivityIndicator.isHidden = true
        }
    }
    var movieDetail : MovieCached?
    var movieProvider : MovieProvider?
    let listOfGenres  = ["28":"Action", "12":"Adventure", "16":"Animation", "35":"Comedy", "80":"Crime", "99":"Documentary", "18":"Drama", "10751":"Family", "14":"Fantasy", "36":"History", "27":"Horror", "10402":"Music", "9648":"Mystery", "10749":"Romance", "878":"Science Fiction", "10770":"TV Movie", "53":"Thriller", "10752":"War", "37":"Western"]
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        imageActivityIndicator.startAnimating()
        imageActivityIndicator.isHidden = false
        movieProvider = MovieProvider()
        if let movie = movieDetail {
            IDLabel.text = movie.id
            OverviewView.text = movie.overview
            VoteCountsLabel.text = movie.voteCount
            VoteAverageLabel.text = movie.voteAverage
            PopularityLabel.text = movie.popularity
            OriginalTitleLabel.text = "Original title: \(movie.originalTitle)"
            TitleLabel.text = movie.title
            OriginalLanguageLabel.text = movie.originalLanguage
            ReleaseDateLabel.text = movie.releaseDate
            let genresArray = movie.genreIDS.components(separatedBy: ",")
            var genresToLabel = ""
            for i in genresArray {
                if let genre = listOfGenres[i] {
                    genresToLabel += "\(genre)  "
                }
            }
            GenresLabel.text = genresToLabel
            if let unwrappedURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                movieProvider?.downloadImage(url: unwrappedURL, completion: { image in
                    self.image = image
                })
            } 
        }
    }
}
