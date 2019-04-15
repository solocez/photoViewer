//
//  PhotosListViewController.swift

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import AlamofireImage

//
final class PhotosListViewController: BaseMVVMViewController<PhotosListViewModel>
        , UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    private var collectionView: UICollectionView!
    private var indicatorView: UIActivityIndicatorView!
    
    // MARK: Object lifecycle
    
    // MARK: Setup
    
    //
    override func setupUI() {
        title = "Photos"
        view.backgroundColor = Settings().backgroundColor
        setupItemsCollection()
        setupActivityIndicator()
        startActivity()
    }
    
    //
    override func setupBindings() {
        viewModel.output.reloadData
            .asObservable()
            .take(1)
            .subscribe(onNext: { [unowned self] (_) in
                self.stopActivity()
            }).disposed(by: bag)
        
        viewModel.output.reloadData.drive(onNext: { [unowned self] indexesToReload in
            let tmp = indexesToReload.map { IndexPath(row: $0, section: 0) }
            let toReloadIndexes = self.cellsToReload(intersecting: tmp)
            guard !toReloadIndexes.isEmpty else { return }
            self.collectionView.reloadItems(at: toReloadIndexes)
        }).disposed(by: bag)
        
        viewModel.input.fetchItems.onNext([])
    }
    
    //
    private func setupItemsCollection() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width / 2 - 10 , height: height / 3 - 10)
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Settings().backgroundColor
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.kItemCellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5.0)
        }
        
        collectionView.rx.itemSelected.subscribe(onNext: { [unowned self] (ip) in
            Log.debug("ITEM \(ip.row) SELECTED")
            self.viewModel.input.itemSelected.onNext(ip.row)
        }).disposed(by: bag)
    }
    
    //
    private func setupActivityIndicator() {
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.center = view.center
        view.addSubview(indicatorView)
    }
    
    //
    private func startActivity() {
        collectionView.isHidden = true
        indicatorView.startAnimating()
    }
    
    //
    private func stopActivity() {
        indicatorView.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    //
    private func cellsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let ipVisibleCells = collectionView.indexPathsForVisibleItems
        let result = Array(Set(ipVisibleCells).intersection(indexPaths))
        return result
    }
}

// UICollectionViewDataSource
extension PhotosListViewController {
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.itemsTotal
    }

    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.kItemCellID, for: indexPath) as! ItemCell
        let item = viewModel.itemBy(index: indexPath.row)
        cell.setup(item: item)
        if nil != item {
            if let posterURL = item!.posterURL() {
                cell.itemImage.af_setImage(withURL: posterURL, placeholderImage: R.image.posterPlaceholder())
            }
        }

        return cell
    }
}

// UICollectionViewDataSourcePrefetching
extension PhotosListViewController {
    //
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map { $0.row }
        viewModel.input.fetchItems.onNext(indexes)
    }

    //
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {

    }
}
