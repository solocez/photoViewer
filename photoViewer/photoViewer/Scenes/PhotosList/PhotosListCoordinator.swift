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

//        viewModel.output.didSelectMovie
//            .asObservable()
//            .subscribe(onNext: { [unowned self] (movie) in
//                self.showMovieDetails(movie, nc: navigationController)
//            }).disposed(by: bag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable<CoordinationResult>.empty()
    }
    
//    private func showMovieDetails(_ movie: Movie, nc: UINavigationController) {
//        let movieCoordinator = MovieCoordinator(movie: movie, navigationViewController: nc)
//        coordinate(to: movieCoordinator).subscribe(onNext: { (_) in
//            //
//        }, onError: { (err) in
//            Log.error(err)
//        }).disposed(by: bag)
//    }
}


