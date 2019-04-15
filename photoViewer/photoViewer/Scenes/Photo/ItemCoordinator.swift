//
//  ItemCoordinator.swift

import UIKit
import RxSwift

//
enum ItemCoordinatorResult {
}

//
final class ItemCoordinator: BaseMVVMCoordinator<ItemCoordinatorResult> {
    
    private let navigationViewController: UINavigationController
    
    private let item: PhotoDetails
    
    init(item: PhotoDetails, navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        self.item = item
    }
    
    //
    override func start() -> Observable<CoordinationResult> {
        let viewController = ItemViewController()
        
        let viewModel = ItemViewModel(item: item)
        viewController.viewModel = viewModel
        
        navigationViewController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
}

