//
//  MainView.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//

import UIKit

final class MainView: UIView {
    let infoBarButtonItem = {
        let button = UIButton()
        button.setTitle("  Info  ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        return button
    }()

    let resetBarButtonItem = {
        let button = UIButton()
        button.setTitle("  Reset  ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        return button
    }()

    let exchangeView = LabelTextFieldView(
        left: Label(text: "거래소"),
        right: TextField(placeholder: "거래소를 선택하세요")
    )
    let makerLabel = Label(text: "지정가:   0")
    let takerLabel = Label(text: "시장가:   0")

    let usdtExchangeRateView = LabelLabelView(
        left: Label(text: "현재 환율(USDT)"),
        right: Label(text: "1200.0")
    )

    let longButton = Button(backgroundColor: .themeGreen, text: "LONG")
    let shortButton = Button(backgroundColor: .themeRed, text: "SHORT")

    let orderMethodView = LabelTextFieldView(
        left: Label(text: "주문 방식"),
        right: TextField(placeholder: "주문 방식을 선택하세요")
    )
    let leverageView = LabelTextFieldView(
        left: Label(text: "레버리지 배수(X)"),
        right: TextField(placeholder: "EX) 10")
    )
    let openPriceView = LabelTextFieldView(
        left: Label(text: "오픈 가격(USDT)"),
        right: TextField(placeholder: "EX) 16929.7")
    )
    let closePriceView = LabelTextFieldView(
        left: Label(text: "마감 가격(USDT)"),
        right: TextField(placeholder: "EX) 17929.7")
    )
    let volumeView = LabelTextFieldView(
        left: Label(text: "오픈 수량(BTC)"),
        right: TextField(placeholder: "EX) 1.0")
    )

    let calculateButton = Button(backgroundColor: .systemGray3, text: "계산")

    let depositView = LabelLabelView(
        left: Label(text: "창위 보증금(USDT)"),
        right: Label(text: "0")
    )
    let feeView = LabelLabelView(
        left: Label(text: "수수료(USDT)"),
        right: Label(text: "0")
    )
    let usdtProfitView = LabelLabelView(
        left: Label(text: "이익(USDT)"),
        right: Label(text: "0")
    )
    let wonProfitView = LabelLabelView(
        left: Label(text: "이익(원화)"),
        right: Label(text: "0")
    )
    let roeView = LabelLabelView(
        left: Label(text: "ROE(%)"),
        right: Label(text: "0")
    )
    let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    let outputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubview()
        addConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {}

    private func addSubview() {
        [orderMethodView, leverageView, openPriceView, closePriceView, volumeView].forEach {
            inputStackView.addArrangedSubview($0)
        }
        [depositView, feeView, usdtProfitView, wonProfitView, roeView].forEach {
            outputStackView.addArrangedSubview($0)
        }

        [exchangeView, makerLabel, takerLabel, usdtExchangeRateView, longButton, shortButton, inputStackView, calculateButton, outputStackView].forEach {
            addSubview($0)
        }
    }

    private func addConstraint() {
        NSLayoutConstraint.activate([
            exchangeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            exchangeView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            exchangeView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -5),
            exchangeView.heightAnchor.constraint(equalToConstant: 40),
            makerLabel.topAnchor.constraint(equalTo: exchangeView.bottomAnchor, constant: 5),
            makerLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            makerLabel.heightAnchor.constraint(equalToConstant: 40),
            takerLabel.topAnchor.constraint(equalTo: exchangeView.bottomAnchor, constant: 5),
            takerLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            takerLabel.heightAnchor.constraint(equalToConstant: 40),
            usdtExchangeRateView.topAnchor.constraint(equalTo: makerLabel.bottomAnchor, constant: 5),
            usdtExchangeRateView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            usdtExchangeRateView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            usdtExchangeRateView.heightAnchor.constraint(equalToConstant: 40),
            longButton.topAnchor.constraint(equalTo: usdtExchangeRateView.bottomAnchor, constant: 5),
            longButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            longButton.heightAnchor.constraint(equalToConstant: 40),
            longButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            shortButton.topAnchor.constraint(equalTo: usdtExchangeRateView.bottomAnchor, constant: 5),
            shortButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -5),
            shortButton.heightAnchor.constraint(equalToConstant: 40),
            shortButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            inputStackView.topAnchor.constraint(equalTo: longButton.bottomAnchor, constant: 5),
            inputStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            inputStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -5),
            inputStackView.heightAnchor.constraint(equalToConstant: 250),
            calculateButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 5),
            calculateButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            calculateButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -5),
            calculateButton.heightAnchor.constraint(equalToConstant: 40),
            outputStackView.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 5),
            outputStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            outputStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            outputStackView.heightAnchor.constraint(equalToConstant: 250),

        ])
    }
}
