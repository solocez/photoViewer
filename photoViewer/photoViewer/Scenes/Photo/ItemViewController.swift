//
//  ItemViewController.swift

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

//
final class ItemViewController: BaseMVVMViewController<ItemViewModel> {
    
    static let background = Settings().backgroundColor
    static let padding: CGFloat = 20.0
    
    // MARK: Outlets
    private let contentPanel = UIView(frame: .zero)
    
    private let authorLbl = UILabel(frame: .zero)
    private let cameraLbl = UILabel(frame: .zero)
    private let posterImageView = UIImageView(frame: .zero)

    // MARK: Object lifecycle
    
    // MARK: Setup
    
    //
    override func setupUI() {
        view.backgroundColor = ItemViewController.background
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = UIColor.gray
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        setupContentPanel()
        setupAuthor()
        setupCamera()
        setupImage()
    }
    
    //
    override func setupBindings() {
        authorLbl.text = viewModel.output.item.author
        cameraLbl.text = viewModel.output.item.camera
        if let posterURL = URL(string: viewModel.output.item.full_picture) {
            posterImageView.af_setImage(withURL: posterURL, placeholderImage: R.image.posterPlaceholder())
        }
    }
}

//
extension ItemViewController {
    
    //
    private func setupAuthor() {
        contentPanel.addSubview(authorLbl)
        authorLbl.numberOfLines = 0
        authorLbl.font = UIFont.boldSystemFont(ofSize: 25.0)
        authorLbl.textColor = UIColor.white
        authorLbl.textAlignment = .center
        authorLbl.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    //
    private func setupCamera() {
        contentPanel.addSubview(cameraLbl)
        cameraLbl.numberOfLines = 0
        cameraLbl.font = UIFont.boldSystemFont(ofSize: 25.0)
        cameraLbl.textColor = UIColor.white
        cameraLbl.textAlignment = .center
        cameraLbl.snp.makeConstraints { (make) in
            make.top.equalTo(authorLbl.snp.bottom).inset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    //
    private func setupImage() {
        contentPanel.addSubview(posterImageView)
        posterImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(cameraLbl.snp.bottom).inset(0 - 10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //
    private func setupContentPanel() {
        contentPanel.backgroundColor = ItemViewController.background
        view.addSubview(contentPanel)
        contentPanel.snp.makeConstraints { (make) in
            make.trailing.bottom.top.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

