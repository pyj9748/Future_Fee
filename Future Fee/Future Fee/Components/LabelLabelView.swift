//
//  LabelLabelView.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit

final class LabelLabelView: UIView {
    let leftLabel: Label
    let rightLabel: Label
    init(left: Label, right: Label) {
        leftLabel = left
        rightLabel = right
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
        [leftLabel, rightLabel].forEach {
            addSubview($0)
        }
    }

    private func addConstraint() {
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: self.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            leftLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            rightLabel.topAnchor.constraint(equalTo: self.topAnchor),
            rightLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            //rightLabel.leftAnchor.constraint(equalTo: leftLabel.rightAnchor),
            rightLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
