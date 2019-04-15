//
//  PhotosListViewModel.swift

import RxSwift
import RxCocoa
import RxSwiftExt

extension PhotosListViewModel: AppManagersConsumer { }
final class PhotosListViewModel: BaseMVVMViewModel {
    
    var input: Input!
    var output: Output!
    
    // MARK: - Inputs
    struct Input {
        let fetchItems: AnyObserver<[Int]/*indexes of an item*/>
        let itemSelected: AnyObserver<Int/*index*/>
    }
    
    // MARK: - Outputs
    struct Output {
        var itemsTotal: Int
        var reloadData: Driver<[Int]/*indexes of items*/>
        var didSelectItem: Driver<PhotoDetails>
    }
    

    //
    func itemBy(index: Int) -> Photo? {
        if index >= storage.count {
            return nil
        }
        return storage[index]
    }

    private let fetchItemsSbj = PublishSubject<[Int]>()
    private let itemSelectedSbj = PublishSubject<Int>()
    private var lastFetchedPage: Int = 0
    
    // Should be REALM or CoreData
    private var storage: [Photo] = []
    
    public override init() {
        super.init()
        
        input = Input(fetchItems: fetchItemsSbj.asObserver()
            , itemSelected: itemSelectedSbj.asObserver())
        
        output = Output(itemsTotal: 0
            , reloadData: setupFetchItems()
            , didSelectItem: setupItemSelected())
    }
}

// Private
extension PhotosListViewModel {
    //
    private func setupItemSelected() -> Driver<PhotoDetails> {
        return itemSelectedSbj.asObservable().flatMap({ [unowned self] (index) -> Driver<PhotoDetails> in
            let item = self.storage[index]
            return self.appManagers.rest.imageDetails(id: item.id).asDriver(onErrorJustReturn: PhotoDetails.fake)
        }).asDriver(onErrorJustReturn: PhotoDetails.fake)
    }
    
    //
    private func setupFetchItems() -> Driver<[Int]> {
        let fetchRequired = fetchItemsSbj
            .asObservable()
            .filter({ (indexes) -> Bool in
                // Check if new Fetch oparation is required
                if indexes.isEmpty { return true }
                
                let requiredIdx = indexes.first { (idx) -> Bool in
                    idx >= self.storage.count
                }
                
                if requiredIdx == nil {
                    return false
                }
                return true
            })
        
        let fetchFromWebResultObs = fetchRequired.flatMap { [unowned self] _ -> Observable<Event<Photos>> in
            // Fetch new portion of Items
            return self.appManagers.rest.images(page: self.lastFetchedPage)
                .asObservable()
                .materialize()
            }.share()
        
        let fetchOK = fetchFromWebResultObs.elements().map { (photos) -> [Int] in
            Log.debug("RECEIVED \(photos.pictures.count) OF PICTURES FOR PAGE \(self.lastFetchedPage) TOTAL PAGE COUNT - \(photos.pageCount)")
            
            self.lastFetchedPage += 1
            self.output.itemsTotal = photos.pageCount * Settings().itemsPerPage
            self.storage.append(contentsOf: photos.pictures)
            
            let startIdx = self.storage.count - photos.pictures.count
            let endIdx = startIdx + photos.pictures.count
            return (startIdx..<endIdx).map { $0 }
        }
        
        let fetchFailed = fetchFromWebResultObs.errors().map { _ -> [Int] in
            fatalError("NOT IMPLEMENTED. NON COMMERCIAL USE")
        }
        
        return Observable.of(fetchOK, fetchFailed).merge().asDriver(onErrorJustReturn: [])
    }
}


