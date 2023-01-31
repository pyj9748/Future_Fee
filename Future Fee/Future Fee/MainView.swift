//
//  MainView.swift
//  Future Fee
//
//  Created by young june Park on 2023/01/08.
//
import SnapKit
import UIKit

final class MainView: UIView {
    let exchangeToolBar = ToolBar()
    let exchangePicker = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    let methodToolBar = ToolBar()
    let methodPicker = {
        let pickerView = UIPickerView()
        return pickerView
    }()

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
        makeConstraint()
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

    private func makeConstraint() {
        exchangeView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        makerLabel.snp.makeConstraints { make in
            make.top.equalTo(exchangeView.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        takerLabel.snp.makeConstraints { make in
            make.top.equalTo(exchangeView.snp.bottom).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        usdtExchangeRateView.snp.makeConstraints { make in
            make.top.equalTo(makerLabel.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        longButton.snp.makeConstraints { make in
            make.top.equalTo(usdtExchangeRateView.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(self.snp.centerX).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        shortButton.snp.makeConstraints { make in
            make.top.equalTo(usdtExchangeRateView.snp.bottom).offset(5)
            make.left.equalTo(self.snp.centerX).offset(10)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        inputStackView.snp.makeConstraints { make in
            make.top.equalTo(longButton.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(inputStackView.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        outputStackView.snp.makeConstraints { make in
            make.top.equalTo(calculateButton.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(5)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-5)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
}
