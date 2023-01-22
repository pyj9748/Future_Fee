//
//  InputError.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/20.
//

import Foundation

enum InputError: Error {
    case exchangeError
    case orderMethodError
    case zeroError
    case leverageError
    
    var description : String {
        switch self {
        case .exchangeError:
            return "거래소를 선택해주세요"
        case .orderMethodError:
            return "주문방식을 선택해주세요"
        case .zeroError:
            return "입력하지 않은 항목이 있거나, 0인 입력이 있습니다."
        case .leverageError:
            return "레버리지는 1부터 100사이의 정수 값입니다."
        }
        
    }
}
