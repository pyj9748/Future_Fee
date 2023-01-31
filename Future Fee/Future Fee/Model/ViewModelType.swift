//
//  ViewModelType.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/31.
//
import RxSwift
import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
}
