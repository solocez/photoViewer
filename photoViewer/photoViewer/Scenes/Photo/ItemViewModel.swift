//
//  ItemViewModel.swift

import RxSwift
import RxCocoa

//
final class ItemViewModel: BaseMVVMViewModel {
    
    var input: Input!
    var output: Output!
    
    // MARK: - Inputs
    struct Input {
        
    }
    
    // MARK: - Outputs
    struct Output {
        let item: PhotoDetails
    }
    
    //
    public init(item: PhotoDetails) {
        super.init()
        
        input = Input()
        output = Output(item: item)
    }
}

