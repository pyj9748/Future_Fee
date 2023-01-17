//
//  ViewModel.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/11.
//

import Foundation
import RxCocoa
import RxSwift

final class ViewModel {
    var disposeBag = DisposeBag()
    struct Input {
        var tapInfo = PublishRelay<Void>()
        var tapReset = PublishRelay<Void>()
        var tapLongShort = PublishRelay<Void>()
        var editExchange = PublishRelay<Void>()
        var editOrderMethod = PublishRelay<Void>()
        var editLeverage = PublishRelay<Void>()
        var editOpenPrice = PublishRelay<Void>()
        var editClosePrice = PublishRelay<Void>()
        var editVolume = PublishRelay<Void>()
    }

    struct Output {
        var showInfo = PublishRelay<Void>()
//        var reset
//        var
    }

    var input = Input()
    var output = Output()

    init() {
        bindInput()
        bindOutput()
    }

    private func bindInput() {
    
    }

    private func bindOutput() {
       
    }
}
