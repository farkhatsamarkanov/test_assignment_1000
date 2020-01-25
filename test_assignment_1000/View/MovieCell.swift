import UIKit
//MARK:- Custom cell
class MoviesCell: UITableViewCell {
  
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var ReleaseDateLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GenresLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundCardView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Activity indicator for image downloading
        imageActivityIndicator.startAnimating()
        imageActivityIndicator.isHidden = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

