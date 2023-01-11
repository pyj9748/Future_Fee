//
//  File.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit

final class LabelTextFieldView: UIView {
    let leftLabel: Label
    let rightTextField: TextField
    init(left: Label, right: TextField) {
        leftLabel = left
        rightTextField = right
        super.init(frame: .zero)
        configure()
        addSubview()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubview() {
        [leftLabel, rightTextField].forEach {
            addSubview($0)
        }
    }

    private func addConstraint() {
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: self.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            leftLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            rightTextField.topAnchor.constraint(equalTo: self.topAnchor),
            rightTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightTextField.leftAnchor.constraint(equalTo: leftLabel.rightAnchor),
            rightTextField.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
