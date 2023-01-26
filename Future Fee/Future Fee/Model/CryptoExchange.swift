//
//  CryptoExchange.swift
//  Future Fee
//
//  Created by young june Park on 2022/05/10.
//

import Foundation

struct CryptoExchange {
    var name: String
    var makerFee: Double
    var takerFee: Double

    var makerFeeString: String {
        return String(makerFee)
    }

    var takerFeeString: String {
        return String(takerFee)
    }
}
