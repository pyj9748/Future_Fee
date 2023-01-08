//
//  Button.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit.UIButton

final class Button: UIButton {
    private var bgColor: UIColor
    
    init(backgroundColor: UIColor, text: String) {
        bgColor = backgroundColor
        super.init(frame: .zero)
        self.backgroundColor = .black
        configure(backgroundColor: backgroundColor, text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(backgroundColor: UIColor, text: String) {
        setTitle(text, for: .normal)
        setTitleColor(.black, for: .normal)
        layer.borderWidth = 2
        layer.borderColor = backgroundColor.cgColor
        clipsToBounds = true
    }
    
    func selected() {
        backgroundColor = bgColor
    }
    
    func deselected() {
        backgroundColor = .black
    }
    
}
