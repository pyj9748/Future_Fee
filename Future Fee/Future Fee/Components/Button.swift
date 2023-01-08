//
//  Button.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit.UIButton

final class Button: UIButton {
    init(backgroundColor: UIColor, text: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        configure(text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(_ text: String) {
        setTitle(text, for: .normal)
    }
}
