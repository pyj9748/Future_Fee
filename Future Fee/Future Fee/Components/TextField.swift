//
//  TextFiled.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit.UITextField

final class TextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        configure(placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(_ placeholder: String) {
        self.placeholder = placeholder
        textColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        textAlignment = .center
    }
}
