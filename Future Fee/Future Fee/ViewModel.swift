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
import SwiftSoup

final class ViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    let cryptoExchange = Exchange.allCases
    let method = Method.allCases
    var input = Input()
    var output = Output()

    struct Input {
        var exchangeRate = BehaviorRelay<Double>(value: 1200.0)
        var exchange = BehaviorRelay<Exchange?>(value: nil)
        var trade = BehaviorRelay<Trade>(value: .Long)
        var orderMethod = BehaviorRelay<Method?>(value: nil)
        var leverage = BehaviorRelay<Double>(value: 0.0)
        var openPrice = BehaviorRelay<Double>(value: 0.0)
        var closePrice = BehaviorRelay<Double>(value: 0.0)
        var volume = BehaviorRelay<Double>(value: 0.0)
        var showAlert = BehaviorRelay<InputError?>(value: nil)

        var tapInfo = PublishRelay<Void>()
        var tapReset = PublishRelay<Void>()
        var tapCalculate = PublishRelay<Void>()
    }

    struct Output {
        var deposit = BehaviorRelay<Double>(value: 0.0)
        var fee = BehaviorRelay<Double>(value: 0.0)
        var usdtProfit = BehaviorRelay<Double>(value: 0.0)
        var wonProfit = BehaviorRelay<Double>(value: 0.0)
        var roe = BehaviorRelay<Double>(value: 0.0)
    }

    init() {
        bindInput()
        bindOutput()
        crawlExchangeRate()
    }

    private func bindInput() {
        input.tapCalculate.bind { [weak self] _ in
            guard let _ = self?.input.exchange.value else {
                self?.input.showAlert.accept(.exchangeError)
                return
            }
            guard let _ = self?.input.orderMethod.value else {
                self?.input.showAlert.accept(.orderMethodError)
                return
            }
            guard let leverage = self?.input.leverage.value,
                  leverage >= 1.0 && leverage <= 100.0 else {
                self?.input.showAlert.accept(.leverageError)
                return
            }
            guard self?.input.openPrice.value != 0,
                  self?.input.closePrice.value != 0,
                  self?.input.volume.value != 0 else {
                self?.input.showAlert.accept(.zeroError)
                return
            }
            self?.calculateResult()

        }.disposed(by: disposeBag)
    }

    private func bindOutput() {}

    private func calculateResult() {
        let open: Double = input.openPrice.value * input.volume.value
        let close: Double = input.closePrice.value * input.volume.value
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
        switch input.orderMethod.value {
        case .maker:
            feePercent = input.exchange.value?.cryptoExchange.makerFee ?? 0.0
        case .taker:
            feePercent = input.exchange.value?.cryptoExchange.takerFee ?? 0.0
        case .none:
            return
        }
        fee = ((open * feePercent) / 100) + ((close * feePercent) / 100)
        output.fee.accept(fee)
    }

    private func calculateProfit(_ open: Double, _ close: Double) {
        var profit: Double = 0.0
        switch input.trade.value {
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
        let wonProfit: Double = profit * input.exchangeRate.value
        output.wonProfit.accept(wonProfit)
    }

    private func calculateROE(_ open: Double, _ profit: Double) {
        let roe: Double = (profit / open) * 100
        output.roe.accept(roe)
    }

    private func crawlExchangeRate() {
        DispatchQueue.global().async { [weak self] in
            let url = URL(string: "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=%ED%99%98%EC%9C%A8&oquery=ghksdbf&tqi=hFVpHwprvmZssLfpRwwssssstLl-431102")
            var price: Double = 1.0
            guard let myURL = url else {
                return
            }
            do {
                let html = try String(contentsOf: myURL, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html)
                let elements: Elements = try doc.select("#ds_to_money")
                for element in elements {
                    var a = try String(element.attr("value"))
                    a = String(String(a[a.startIndex]) + String(a[a.index(a.startIndex, offsetBy: 2) ... a.index(a.startIndex, offsetBy: 7)]))
                    guard let p = Double(a) else {
                        return
                    }
                    price = p
                }
                DispatchQueue.main.async {
                    self?.input.exchangeRate.accept(price)
                }
            } catch let Exception.Error(_, message) {
                print("Message: \(message)")
            } catch {
                print("error")
            }
        }
    }
}
