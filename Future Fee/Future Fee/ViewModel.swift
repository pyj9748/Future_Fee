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
        var exchangeRate = BehaviorRelay<Double>(value: 1200.0)
        var exchange = BehaviorRelay<Exchange?>(value: nil)
        var trade = BehaviorRelay<Trade>(value: .Long)
        var orderMethod = BehaviorRelay<Method?>(value: nil)
        var leverage = BehaviorRelay<Double>(value: 0.0)
        var openPrice = BehaviorRelay<Double>(value: 0.0)
        var closePrice = BehaviorRelay<Double>(value: 0.0)
        var volume = BehaviorRelay<Double>(value: 0.0)
        var showAlert = BehaviorRelay<InputError?>(value: nil)

        var deposit = BehaviorRelay<Double>(value: 0.0)
        var fee = BehaviorRelay<Double>(value: 0.0)
        var usdtProfit = BehaviorRelay<Double>(value: 0.0)
        var wonProfit = BehaviorRelay<Double>(value: 0.0)
        var roe = BehaviorRelay<Double>(value: 0.0)
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
            self?.calculateResult()

        }.disposed(by: disposeBag)
    }

    private func bindOutput() {}

    private func calculateResult() {
        let open: Double = output.openPrice.value * output.volume.value
        let close: Double = output.closePrice.value * output.volume.value
        calculateDeposit(open)
        calculateFee(open, close)
        calculateProfit(open, close)
    }

    private func calculateDeposit(_ open: Double) {
        let deposit: Double = open
        output.deposit.accept(deposit)
    }

    private func calculateFee(_ open: Double, _ close: Double) {
        var fee: Double = 0.0
        var feePercent: Double = 0.0
        switch output.orderMethod.value {
        case .maker:
            feePercent = output.exchange.value?.cryptoExchange.makerFee ?? 0.0
        case .taker:
            feePercent = output.exchange.value?.cryptoExchange.takerFee ?? 0.0
        case .none:
            return
        }
        fee = ((open * feePercent) / 100) + ((close * feePercent) / 100)
        output.fee.accept(fee)
    }

    private func calculateProfit(_ open: Double, _ close: Double) {
        var profit: Double = 0.0
        switch output.trade.value {
        case .Long:
            profit = (close - open) - output.fee.value
        case .Short:
            profit = (open - close) - output.fee.value
        }
        calculateUSDTProfit(profit)
        calculateWonProfit(profit)
        calculateROE(open, profit)
    }

    private func calculateUSDTProfit(_ profit: Double) {
        output.usdtProfit.accept(profit)
    }

    private func calculateWonProfit(_ profit: Double) {
        let wonProfit: Double = profit * output.exchangeRate.value
        output.wonProfit.accept(wonProfit)
    }

    private func calculateROE(_ open: Double, _ profit: Double) {
        let roe: Double = (profit / open) * 100
        output.roe.accept(roe)
    }

    private func fetchExchangeRate() {
        print(crawlUSD {})
    }
}
