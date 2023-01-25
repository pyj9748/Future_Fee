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
        
        var deposit = BehaviorRelay<Double>(value: 0.0)
        var fee = BehaviorRelay<Double>(value: 0.0)
        var usdtProfit = BehaviorRelay<Double>(value: 0.0)
        var wonProfit = BehaviorRelay<Double>(value: 0.0)
        var roeView = BehaviorRelay<Double>(value: 0.0)
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
        calculateDeposit()
        calculateFee()
        calculateUSDTProfit()
        calculateWonProfit()
        calculateROE()
    }
    //        // Margin
    //
    //        var margin: Double = 0.0
    //        margin = (o / l) * v
    //        lblMargin.text = String(format: "%.2f", margin)
    //        print(margin)
    //        // open
    //        let open: Double = o * v
    //        print("open : ", open)
    //
    //        // close
    //        let close: Double = c * v
    //        print("close : ", close)
    //
    //        // fee
    //        var fee: Double = 0.0
    //        if methodTF.text! == "시장가" {
    //            if let feePercent = Double(lblTaker.text!) {
    //                fee = ((open * feePercent) / 100) + ((close * feePercent) / 100)
    //
    //                lblFee.text = String(format: "%.2f", fee)
    //            }
    //        } else {
    //            if let feePercent = Double(lblMaker.text!) {
    //                fee = ((open * feePercent) / 100) + ((close * feePercent) / 100)
    //
    //                lblFee.text = String(format: "%.2f", fee)
    //            }
    //        }
    //        // profit
    //        if trade == Trade.Long {
    //            let profit: Double = (close - open) - fee
    //            lblUSDTProfit.text = String(format: "%.2f", profit)
    //            lblWonProfit.text = String(format: "%.2f", profit * _USD)
    //
    //            // ROE
    //            lblROE.text = String(format: "%.2f", (profit / margin) * 100)
    //        } else {
    //            let profit: Double = (open - close) - fee
    //            lblUSDTProfit.text = String(format: "%.2f", profit)
    //            lblWonProfit.text = String(format: "%.2f", profit * _USD)
    //            // ROE
    //            lblROE.text = String(format: "%.2f", (profit / margin) * 100)
    //        }
    private func calculateDeposit() {
        var deposit: Double = output.openPrice.value * output.volume.value
        output.deposit.accept(deposit)
    }
    
    private func calculateFee() {
        var fee: Double = 0.0
        var feePercent: Double = 0.0
        var open: Double = output.openPrice.value * output.volume.value
        var close: Double = output.closePrice.value * output.volume.value
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
    
    private func calculateUSDTProfit() {
        
    }
    
    private func calculateWonProfit() {
        
    }
    
    private func calculateROE() {
        
    }
    
    private func fetchExchangeRate() {
        print(crawlUSD {})
    }
}
