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

    let cryptoExchange = Exchange.allCases
    let method = Method.allCases

    struct Input {
        var tapInfo = PublishRelay<Void>()
        var tapReset = PublishRelay<Void>()
    }

    struct Output {
        var exchange = PublishSubject<CryptoExchange>()
        var trade = PublishSubject<Trade>()
        var orderMethod = PublishSubject<Method>()
        var leverage = PublishSubject<Double>()
        var openPrice = PublishSubject<Double>()
        var closePrice = PublishSubject<Double>()
        var volume = PublishSubject<Double>()
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
