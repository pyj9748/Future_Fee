//
//  Exchange.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/17.
//

import Foundation

enum Exchange: String, CaseIterable {
    case binanceRegularUser = "Binance Regular User"
    case binanceVIP1 = "Binance VIP 1"
    case binanceVIP2 = "Binance VIP 2"
    case binanceVIP3 = "Binance VIP 3"
    case bitget = "Bitget"
    case bybitNonVIP = "Bybit Non-VIP"
    case bybitVIP1 = "Bybit VIP 1"
    case bybitVIP2 = "Bybit VIP 2"
    case bybitVIP3 = "Bybit VIP 3"

    var cryptoExchange: CryptoExchange {
        switch self {
        case .binanceRegularUser:
            return CryptoExchange(name: "Binance Regular User", makerFee: 0.02, takerFee: 0.04)
        case .binanceVIP1:
            return CryptoExchange(name: "Binance VIP 1", makerFee: 0.016, takerFee: 0.04)
        case .binanceVIP2:
            return CryptoExchange(name: "Binance VIP 2", makerFee: 0.014, takerFee: 0.035)
        case .binanceVIP3:
            return CryptoExchange(name: "Binance VIP 3", makerFee: 0.012, takerFee: 0.032)
        case .bitget:
            return CryptoExchange(name: "Bitget", makerFee: 0.02, takerFee: 0.04)
        case .bybitNonVIP:
            return CryptoExchange(name: "Bybit Non-VIP", makerFee: 0.01, takerFee: 0.06)
        case .bybitVIP1:
            return CryptoExchange(name: "Bybit VIP 1", makerFee: 0.006, takerFee: 0.05)
        case .bybitVIP2:
            return CryptoExchange(name: "Bybit VIP 2", makerFee: 0.004, takerFee: 0.045)
        case .bybitVIP3:
            return CryptoExchange(name: "Bybit VIP 3", makerFee: 0.002, takerFee: 0.0425)
        }
    }
}
