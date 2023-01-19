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
        var exchangeRate = PublishSubject<CryptoExchange>()
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
        fetchExchangeRate()
    }

    private func bindInput() {
        
    }
    

    private func bindOutput() {
        output.exchange.bind { cryptoExchange in
            print(cryptoExchange)
        }.disposed(by: disposeBag)
        
        output.trade.bind { trade in
            print(trade)
        }.disposed(by: disposeBag)
        
        output.orderMethod.bind { orderMethod in
            print(orderMethod)
        }.disposed(by: disposeBag)
        
        output.leverage.bind { leverage in
            print(leverage)
        }.disposed(by: disposeBag)
        
        output.openPrice.bind { openPrice in
            print(openPrice)
        }.disposed(by: disposeBag)
        
        output.closePrice.bind { closePrice in
            print(closePrice)
        }.disposed(by: disposeBag)
        
        output.volume.bind { volume in
            print(volume)
        }.disposed(by: disposeBag)
        
    }
    
    private func fetchExchangeRate() {
        print(crawlUSD {})
    }
}
