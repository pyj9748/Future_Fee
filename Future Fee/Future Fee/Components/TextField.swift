//
//  TextFiled.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit

final class TextField: UITextField {
    let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)

    init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configure(placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(_ placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        text = ""
        textColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        textAlignment = .center
        keyboardType = .decimalPad

        let toolBar = ToolBar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        inputAccessoryView = toolBar
    }
}
