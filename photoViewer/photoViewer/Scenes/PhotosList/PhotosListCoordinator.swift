//
//  PhotosListCoordinator.swift

import UIKit
import RxSwift

enum PhotosListCoordinatorResult {
}

//
class PhotosListCoordinator: BaseMVVMCoordinator<PhotosListCoordinatorResult> {
    
    private let window: UIWindow
    
    //
    init(window: UIWindow) {
        self.window = window
    }
    
    //
    override func start() -> Observable<CoordinationResult> {
        let viewController = PhotosListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let viewModel = PhotosListViewModel()
        viewController.viewModel = viewModel

        viewModel.output.didSelectItem
            .asObservable()
            .subscribe(onNext: { [unowned self] (itemDetails) in
                self.showItemDetails(itemDetails, nc: navigationController)
            }).disposed(by: bag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable<CoordinationResult>.empty()
    }

    
    private func showItemDetails(_ itemDetails: PhotoDetails, nc: UINavigationController) {
        let itemCoordinator = ItemCoordinator(item: itemDetails, navigationViewController: nc)
        coordinate(to: itemCoordinator).subscribe(onNext: { (_) in
            //
        }, onError: { (err) in
            Log.error(err)
        }).disposed(by: bag)
    }
}


