//
//  ToolBar.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/11.
//

import UIKit.UIToolbar

final class ToolBar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        barStyle = UIBarStyle.default
        barTintColor = .black
        isTranslucent = true
        tintColor = UIColor.white
        sizeToFit()
        isUserInteractionEnabled = true
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems([flexibleSpace, doneButton], animated: false)
    }
    
}
