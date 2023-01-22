//
//  ViewModel.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/11.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

final class ViewModel {
    var disposeBag = DisposeBag()

    let cryptoExchange = Exchange.allCases
    let method = Method.allCases
    var input = Input()
    var output = Output()

    struct Input {
        var tapInfo = PublishRelay<Void>()
        var tapReset = PublishRelay<Void>()
        var tapCalculate = PublishRelay<Void>()
    }

    struct Output {
        // var exchangeRate = BehaviorSubject<Double>(value: <#CryptoExchange#>)
        var exchange = BehaviorRelay<Exchange?>(value: nil)
        var trade = BehaviorRelay<Trade>(value: .Long)
        var orderMethod = BehaviorRelay<Method?>(value: nil)
        var leverage = BehaviorRelay<Double>(value: 0.0)
        var openPrice = BehaviorRelay<Double>(value: 0.0)
        var closePrice = BehaviorRelay<Double>(value: 0.0)
        var volume = BehaviorRelay<Double>(value: 0.0)
        var showAlert = BehaviorRelay<InputError?>(value: nil)
        // var result = BehaviorRelay<InputError?>(value: nil)
    }

    init() {
        bindInput()
        bindOutput()
        fetchExchangeRate()
    }

    private func bindInput() {
        input.tapCalculate.bind { [weak self] _ in
            guard let _ = self?.output.exchange.value else {
                self?.output.showAlert.accept(.exchangeError)
                return
            }
            guard let _ = self?.output.orderMethod.value else {
                self?.output.showAlert.accept(.orderMethodError)
                return
            }
            guard let leverage = self?.output.leverage.value,
                  leverage >= 1.0 && leverage <= 100.0 else {
                self?.output.showAlert.accept(.leverageError)
                return
            }
            guard self?.output.openPrice.value != 0,
                  self?.output.closePrice.value != 0,
                  self?.output.volume.value != 0 else {
                self?.output.showAlert.accept(.zeroError)
                return
            }

        }.disposed(by: disposeBag)
    }

    private func bindOutput() {}

    private func fetchExchangeRate() {
        print(crawlUSD {})
    }
}
