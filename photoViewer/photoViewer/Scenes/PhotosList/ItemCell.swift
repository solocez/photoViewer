//
//  ItemCell.swift

import UIKit

final class ItemCell: UICollectionViewCell {
    
    public static let kItemCellID = "ItemCellID"
    
    private var indicatorView: UIActivityIndicatorView!
    var itemImage: UIImageView!
    
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
        setup(item: nil)
    }
    
    //
    public func setup(item: Photo?) {
        if nil == item {
            itemImage.isHidden = true
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
            itemImage.isHidden = false
        }
    }
    
    //
    private func setupPosterImage() {
        itemImage = UIImageView(image: nil)
        addSubview(itemImage)
        itemImage.snp.makeConstraints { (make) in
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
