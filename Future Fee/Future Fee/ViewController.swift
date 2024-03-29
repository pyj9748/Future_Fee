//
//  ViewController.swift
//  Future Fee
//
//  Created by young june Park on 2022/05/01.
//

import RxCocoa
import RxSwift
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {
    private let mainView = MainView()
    var viewModel: ViewModel = ViewModel()
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = mainView
        configureNavigationBar()
        configurePickerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindViewModel()
        mainView.longButton.selected()
        mainView.shortButton.deselected()
        viewModel.input.trade.accept(.Long)
    }

    private func bind() {
        mainView.infoBarButtonItem.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.input.tapInfo.accept(())
            }.disposed(by: disposeBag)

        mainView.resetBarButtonItem.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.input.tapReset.accept(())
            }.disposed(by: disposeBag)

        mainView.longButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mainView.longButton.selected()
                self?.mainView.shortButton.deselected()
                self?.viewModel.input.trade.accept(.Long)
            }.disposed(by: disposeBag)

        mainView.shortButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mainView.longButton.deselected()
                self?.mainView.shortButton.selected()
                self?.viewModel.input.trade.accept(.Short)
            }.disposed(by: disposeBag)
        mainView.leverageView.rightTextField.rx.text
            .bind { [weak self] text in
                if let leverage = Double(text ?? "") {
                    self?.viewModel.input.leverage.accept(leverage)
                }
            }.disposed(by: disposeBag)
        mainView.openPriceView.rightTextField.rx.text
            .bind { [weak self] text in
                if let openPrice = Double(text ?? "") {
                    self?.viewModel.input.openPrice.accept(openPrice)
                }
            }.disposed(by: disposeBag)
        mainView.closePriceView.rightTextField.rx.text
            .bind { [weak self] text in
                if let closePrice = Double(text ?? "") {
                    self?.viewModel.input.closePrice.accept(closePrice)
                }
            }.disposed(by: disposeBag)
        mainView.volumeView.rightTextField.rx.text
            .bind { [weak self] text in
                if let volume = Double(text ?? "") {
                    self?.viewModel.input.volume.accept(volume)
                }
            }.disposed(by: disposeBag)

        mainView.exchangeView.rightTextField.doneButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let row = self?.mainView.exchangePicker.selectedRow(inComponent: 0),
                      let exchange = self?.viewModel.cryptoExchange[row] else {
                    return
                }
                self?.mainView.exchangeView.rightTextField.text = exchange.cryptoExchange.name
                self?.mainView.makerLabel.text = exchange.cryptoExchange.makerFeeString
                self?.mainView.takerLabel.text = exchange.cryptoExchange.takerFeeString
                self?.viewModel.input.exchange.accept(exchange)
                self?.mainView.exchangeView.rightTextField.resignFirstResponder()
            }.disposed(by: disposeBag)

        mainView.orderMethodView.rightTextField.doneButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let row = self?.mainView.methodPicker.selectedRow(inComponent: 0),
                      let method = self?.viewModel.method[row] else {
                    return
                }
                self?.mainView.orderMethodView.rightTextField.text = method.rawValue
                self?.viewModel.input.orderMethod.accept(method)
                self?.mainView.orderMethodView.rightTextField.resignFirstResponder()
            }.disposed(by: disposeBag)

        mainView.calculateButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.input.tapCalculate.accept(())
            }.disposed(by: disposeBag)

        mainView.leverageView.rightTextField.doneButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mainView.leverageView.rightTextField.resignFirstResponder()
            }.disposed(by: disposeBag)

        mainView.openPriceView.rightTextField.doneButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mainView.openPriceView.rightTextField.resignFirstResponder()
            }.disposed(by: disposeBag)

        mainView.closePriceView.rightTextField.doneButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mainView.closePriceView.rightTextField.resignFirstResponder()
            }.disposed(by: disposeBag)

        mainView.volumeView.rightTextField.doneButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mainView.volumeView.rightTextField.resignFirstResponder()
            }.disposed(by: disposeBag)

//        mainView.volumeView.rightTextField.rx.controlEvent(.editingDidBegin)
//            .subscribe(on: MainScheduler.instance)
//            .bind { [weak self] _ in
//                UIView.animate(
//                    withDuration: 0.3
//                    , animations: {
//                        self?.view.transform = CGAffineTransform(translationX: 0, y: -50)
//                    }
//                )
//            }.disposed(by: disposeBag)
//        mainView.volumeView.rightTextField.rx.controlEvent(.editingDidEnd)
//            .subscribe(on: MainScheduler.instance)
//            .bind { [weak self] _ in
//                self?.view.transform = .identity
//            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.input.exchangeRate
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] exchangeRate in
                self?.mainView.usdtExchangeRateView.rightLabel.text = String(format: "%.1f", exchangeRate)
            }
            .disposed(by: disposeBag)
        viewModel.input.tapInfo
            .bind { [weak self] _ in
                self?.showInfo()
            }
            .disposed(by: disposeBag)
        viewModel.input.tapReset
            .bind { [weak self] _ in
                self?.reset()
                self?.viewModel.input.leverage.accept(0)
                self?.viewModel.input.openPrice.accept(0)
                self?.viewModel.input.closePrice.accept(0)
                self?.viewModel.input.volume.accept(0)
            }
            .disposed(by: disposeBag)

        viewModel.input.showAlert
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] error in
                self?.showAlert(error)
            }
            .disposed(by: disposeBag)

        viewModel.output.fee
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] fee in
                self?.mainView.feeView.rightLabel.text = String(format: "%.2f", fee)
            }
            .disposed(by: disposeBag)

        viewModel.output.deposit
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] deposit in
                self?.mainView.depositView.rightLabel.text = String(format: "%.2f", deposit)
            }
            .disposed(by: disposeBag)

        viewModel.output.usdtProfit
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] usdtProfit in
                self?.mainView.usdtProfitView.rightLabel.text = String(format: "%.2f", usdtProfit)
            }
            .disposed(by: disposeBag)

        viewModel.output.wonProfit
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] wonProfit in
                self?.mainView.wonProfitView.rightLabel.text = String(format: "%.2f", wonProfit)
            }
            .disposed(by: disposeBag)

        viewModel.output.roe
            .subscribe(on: MainScheduler.instance)
            .bind { [weak self] roe in
                self?.mainView.roeView.rightLabel.text = String(format: "%.2f", roe)
            }
            .disposed(by: disposeBag)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "선물거래 연습 계산기"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        addBarButtonItems()
    }

    private func addBarButtonItems() {
        let infoBarButton = UIBarButtonItem(customView: mainView.infoBarButtonItem)
        infoBarButton.customView?.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem = infoBarButton
        let resetBarButton = UIBarButtonItem(customView: mainView.resetBarButtonItem)
        resetBarButton.customView?.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = resetBarButton
    }

    private func showInfo() {
        let infoAlert = UIAlertController(
            title: "Info",
            message: """
            이 어플은 선물거래 초보자를 위한 이익과 수수료 계산을 지원합니다.
            펀딩비를 제외하므로 본인의 수수료 정책과 맞는지 잘 확인하시고
            참고만 해주시기 바랍니다. 감사합니다.
            """,
            preferredStyle: UIAlertController.Style.alert
        )
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        infoAlert.addAction(okAction)

        present(infoAlert, animated: true, completion: nil)
    }

    private func reset() {
        mainView.exchangeView.rightTextField.text = ""
        mainView.orderMethodView.rightTextField.text = ""
        mainView.leverageView.rightTextField.text = ""
        mainView.openPriceView.rightTextField.text = ""
        mainView.closePriceView.rightTextField.text = ""
        mainView.volumeView.rightTextField.text = ""
        mainView.depositView.rightLabel.text = "0"
        mainView.feeView.rightLabel.text = "0"
        mainView.usdtProfitView.rightLabel.text = "0"
        mainView.wonProfitView.rightLabel.text = "0"
        mainView.roeView.rightLabel.text = "0"
    }

    private func showAlert(_ error: InputError?) {
        guard let error else { return }
        let alert = UIAlertController(title: "입력 오류", message: error.description, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func configurePickerView() {
        mainView.exchangePicker.delegate = self
        mainView.exchangePicker.dataSource = self
        mainView.exchangeView.rightTextField.inputView = mainView.exchangePicker
        mainView.methodPicker.delegate = self
        mainView.methodPicker.dataSource = self
        mainView.orderMethodView.rightTextField.inputView = mainView.methodPicker
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case mainView.exchangePicker:
            return viewModel.cryptoExchange.count
        case mainView.methodPicker:
            return viewModel.method.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mainView.exchangePicker {
            return viewModel.cryptoExchange[row].cryptoExchange.name
        } else {
            return viewModel.method[row].rawValue
        }
    }
}
