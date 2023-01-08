//
//  Label.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit.UILabel

final class Label: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        configure(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ text: String){
        self.text = text
        self.textColor = .white
    }
}
