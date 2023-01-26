//
//  CrawlError.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/25.
//

import Foundation

enum CrawlError: Error {
    case BadURL
    case ParseError
    case CrawlError
    var description : String {
        switch self {
        case .BadURL:
            return "잘못된 URL입니다."
        case .ParseError:
            return "파싱 에러."
        case .CrawlError:
            return "잘못된 값을 크롤링 했습니다."
        }
        
    }
}
