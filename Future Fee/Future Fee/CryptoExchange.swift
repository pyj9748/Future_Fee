//
//  CryptoExchange.swift
//  Future Fee
//
//  Created by young june Park on 2022/05/10.
//

import Foundation
import SwiftSoup

struct CryptoExchange {
    var name: String
    var makerFee: Double
    var takerFee: Double
}

func crawlBTCUSDT(completion: @escaping () -> Void) -> Double {
    let url = URL(string: "https://www.binance.com/en/futures/BTCUSDT")
    var price: Double = 1.0
    guard let myURL = url else { return -1 }

    do {
        let html = try String(contentsOf: myURL, encoding: .utf8)
        let doc: Document = try SwiftSoup.parse(html)
        let headerTitle = try doc.title()
        guard let p = Double(headerTitle[headerTitle.startIndex ... headerTitle.index(headerTitle.startIndex, offsetBy: 6)]) else { return -1 }
        price = p

    } catch let Exception.Error(_, message) {
        print("Message: \(message)")
    } catch {
        print("error")
    }

    return price
}

// https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query=ghksdbf
func crawlUSD(completion: @escaping () -> Void) -> Double {
    let url = URL(string: "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=%ED%99%98%EC%9C%A8&oquery=ghksdbf&tqi=hFVpHwprvmZssLfpRwwssssstLl-431102")
    var price: Double = 1.0
    guard let myURL = url else { return -1 }

    do {
        let html = try String(contentsOf: myURL, encoding: .utf8)
        let doc: Document = try SwiftSoup.parse(html)
        let elements: Elements = try doc.select("#ds_to_money")
        for element in elements {
            var a = try String(element.attr("value"))
            // try print(element.attr("value"))
            a = String(String(a[a.startIndex]) + String(a[a.index(a.startIndex, offsetBy: 2) ... a.index(a.startIndex, offsetBy: 7)]))
            guard let p = Double(a) else { return -1 }
            price = p
        }
    } catch let Exception.Error(_, message) {
        print("Message: \(message)")
    } catch {
        print("error")
    }

    return price
}
