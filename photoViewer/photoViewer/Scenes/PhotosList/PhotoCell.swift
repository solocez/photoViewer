//
//  PhotoCell.swift

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    public static let kMovieCellID = "MovieCellID"
    
    private var indicatorView: UIActivityIndicatorView!
    var posterImage: UIImageView!
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        setupPosterImage()
        setupActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup(movie: nil)
    }
    
    //
    public func setup(movie: Photo?) {
        if nil == movie {
            posterImage.isHidden = true
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
            posterImage.isHidden = false
        }
    }
    
    //
    private func setupPosterImage() {
        posterImage = UIImageView(image: nil)
        addSubview(posterImage)
        posterImage.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    //
    private func setupActivityIndicator() {
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        indicatorView.hidesWhenStopped = true
        addSubview(indicatorView)
    }
}
