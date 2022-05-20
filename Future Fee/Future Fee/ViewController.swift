//
//  ViewController.swift
//  Future Fee
//
//  Created by young june Park on 2022/05/01.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UITextFieldDelegate{
    
    
    // 거래소
    let exchangePicker = UIPickerView()

    // 거래소 배열
    let cryptoExchange :[CryptoExchange] = [CryptoExchange(name: "Binance Regular User", makerFee: 0.02, takerFee: 0.04),CryptoExchange(name: "Binance VIP 1", makerFee: 0.016, takerFee: 0.04),CryptoExchange(name: "Binance VIP 2", makerFee: 0.014, takerFee: 0.035),CryptoExchange(name: "Binance VIP 3", makerFee: 0.012, takerFee: 0.032), CryptoExchange(name: "Bitget Non-Refferal", makerFee: 0.02, takerFee: 0.06), CryptoExchange(name: "Bitget Refferal", makerFee: 0.02, takerFee: 0.04),CryptoExchange(name: "Bybit Non-VIP", makerFee: 0.01, takerFee: 0.06),CryptoExchange(name: "Bybit VIP 1", makerFee: 0.006, takerFee: 0.05),CryptoExchange(name: "Bybit VIP 2", makerFee: 0.004, takerFee: 0.045),CryptoExchange(name: "Bybit VIP 3", makerFee: 0.002, takerFee: 0.0425),CryptoExchange(name: "FTX Tier 1", makerFee: 0.02, takerFee: 0.07),CryptoExchange(name: "FTX Tier 2", makerFee: 0.015, takerFee: 0.06),CryptoExchange(name: "FTX Tier 3", makerFee: 0.01, takerFee: 0.055)]
    
    // Long or Short
    
    enum Trade {
        case Long
        case Short
    }
    var trade :Trade = Trade.Long
    
    // 지정가 / 시장가
    let methodPicker = UIPickerView()
    let method :[String] = ["지정가" , "시장가"]
    
    
    // 계산 요소
    // BTCUSTD
    var _BTCUSDT :Double = 0
    // USD
    var _USD :Double = 0
    // leverage
    var leverage : Double =  0
    // openPrice
    var openPrice : Double = 0
    // closePrice
    var closePrice : Double = 0
    // volume
    var volume : Double = 0
    
    //Calculate alert
    let calculateAlert = UIAlertController(title: "입력 오류", message: "0인 입력이 있거나 숫자가 아닌 입력이 있습니다", preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )

    //Info alert
    let infoAlert = UIAlertController(title: "Info", message: """
    이 어플은 선물거래 초보자를 위한 이익과 수수료 계산을 지원합니다.
    펀딩비를 제외하므로 본인의 수수료 정책과 맞는지 잘 확인하시고
    참고만 해주시기 바랍니다. 감사합니다.
    """
        , preferredStyle: UIAlertController.Style.alert)
   
    //leverage value alert
    let leverageValueAlert = UIAlertController(title: "입력 오류", message: "레버리지는 1부터 100사이의 정수 값입니다.", preferredStyle: UIAlertController.Style.alert)
   
    // 거래소 선택
    let exchangeAlert = UIAlertController(title: "입력 오류", message: "거래소를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
    // 주문 방식 선택
    let methodAlert = UIAlertController(title: "입력 오류", message: "주문방식을 선택해주세요", preferredStyle: UIAlertController.Style.alert)

   
    
    @IBOutlet weak var exchangeTF: UITextField!
    @IBOutlet weak var lblMaker: UILabel!
    @IBOutlet weak var lblTaker: UILabel!
    @IBOutlet weak var methodTF: UITextField!
    
    
    @IBOutlet weak var lblUSD: UILabel!
    
    // 다 더블형
    
    
    @IBOutlet weak var leverageTF: UITextField!
    @IBOutlet weak var openPriceTF: UITextField!
    @IBOutlet weak var closePriceTF: UITextField!
    @IBOutlet weak var volumeTF: UITextField!
    
    
    // Long Short btn
    @IBOutlet weak var longBT: UIButton!
    @IBOutlet weak var shortBT: UIButton!
    
    @IBOutlet weak var lblMargin: UILabel!
    @IBOutlet weak var lblROE: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblUSDTProfit: UILabel!
    @IBOutlet weak var lblWonProfit: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPickerView()
        updateRealPrice()
        if exchangeTF.text == "거래소를 선택하세요"{
            exchangeTF.textColor = UIColor.darkGray
        }
        if methodTF.text == "주문방식을 선택하세요" {
            methodTF.textColor = UIColor.darkGray
        }
        
        setTF()
        setPlaceholder()
        calculateAlert.addAction(okAction)
        infoAlert.addAction(okAction)
        leverageValueAlert.addAction(okAction)
        methodAlert.addAction(okAction)
        exchangeAlert.addAction(okAction)
        
        longBT.backgroundColor = UIColor.green
        longBT.setTitleColor(UIColor.black, for: .normal)
        
        shortBT.backgroundColor = UIColor.black
        shortBT.setTitleColor(UIColor.red, for: .normal)

        self.trade = Trade.Long
        
    }
    func setTF() {
        
        leverageTF.text = ""
        openPriceTF.text = ""
        closePriceTF.text = ""
        volumeTF.text = ""
        
    }
    func setPlaceholder() {
        leverageTF.attributedPlaceholder = NSAttributedString(string: "EX) 10", attributes: [.foregroundColor: UIColor.darkGray])
        openPriceTF.attributedPlaceholder = NSAttributedString(string: "EX) \(_BTCUSDT)", attributes: [.foregroundColor: UIColor.darkGray])
        closePriceTF.attributedPlaceholder = NSAttributedString(string: "EX) \(_BTCUSDT + 1000.0)", attributes: [.foregroundColor: UIColor.darkGray])
        volumeTF.attributedPlaceholder = NSAttributedString(string: "EX) 1.0", attributes: [.foregroundColor: UIColor.darkGray])
        
    }
    func updateRealPrice(){
        self._BTCUSDT = crawlBTCUSDT(completion: {})
        self._USD = crawlUSD(completion: {
            print( self.lblUSD.text ?? "USD")
        })
        self.lblUSD.text = String(self._USD)
    }
    
    @IBAction func tapLongBT(_ sender: UIButton) {
        longBT.backgroundColor = UIColor.green
        longBT.setTitleColor(UIColor.white, for: .normal)
        
        shortBT.backgroundColor = UIColor.black
        shortBT.setTitleColor(UIColor.red, for: .normal)

        self.trade = Trade.Long
    }
    @IBAction func tapShortBT(_ sender: UIButton) {
        longBT.backgroundColor = UIColor.black
        longBT.setTitleColor(UIColor.green, for: .normal)
        
        shortBT.backgroundColor = UIColor.red
        shortBT.setTitleColor(UIColor.white, for: .highlighted)

        self.trade = Trade.Short
    }
    
    
    
    
    @IBAction func tapInfoBT(_ sender: UIButton) {
        
        present(infoAlert, animated: true, completion: nil)
        
    }
    @IBAction func tapResteBT(_ sender: UIButton) {
        setTF()
        lblMargin.text = "0"
        lblUSDTProfit.text = "0"
        lblWonProfit.text = "0"
        lblFee.text = "0"
        lblROE.text = "0"
        
    }
    @IBAction func tapCalculateBT(_ sender: UIButton) {
        
      
        var l :Double = 0
        var o :Double = 0
        var c :Double = 0
        var v :Double = 0
       
       
       
        
        // 주문 방식
        if methodTF.textColor == UIColor.darkGray {
            present(methodAlert, animated: true, completion: nil)
            return
        }
        if methodTF.text == "주문방식을 선택하세요" {
            present(methodAlert, animated: true, completion: nil)
            return
        }
        // 거래소 선택
//        if exchangeTF.text == "거래소를 선택하세요" {
//            present(exchangeAlert, animated: true, completion: nil)
//            return
//        }
        if exchangeTF.textColor == UIColor.darkGray {
            present(exchangeAlert, animated: true, completion: nil)
            return
        }
       
        if let _l = Double(leverageTF.text!){
            l = _l
        } else {
            present(calculateAlert, animated: true, completion: nil)
            return
        }
        if let _o = Double(openPriceTF.text!){
            o = _o
        } else {
            present(calculateAlert, animated: true, completion: nil)
            return
        }
        if let _c = Double(closePriceTF.text!){
            c = _c
        } else {
            present(calculateAlert, animated: true, completion: nil)
            return
        }
        if let _v = Double(volumeTF.text!){
            v = _v
        } else {
            present(calculateAlert, animated: true, completion: nil)
            return
        }
        
      
      
        if l == 0 || o == 0 || c == 0 || v == 0 {
            
            present(calculateAlert, animated: true, completion: nil)
            //return
        }
        // leverage
        if l < 1.0 || l > 100.0 || l - Double(Int(l)) != 0  {
            present(leverageValueAlert, animated: true, completion: nil)
           // return
        }
        
        // Margin
        
        var margin :Double = 0.0
        margin = (o / l) * v
        lblMargin.text = String(format: "%.2f", margin)
        print(margin)
        // open
        let open :Double = o * v
        print("open : " , open)
        
        
        
        // close
        let close :Double = c * v
        print("close : ", close)
        
        // fee
         var fee :Double = 0.0
         if methodTF.text! == "시장가" {
             if let feePercent = Double(lblTaker.text!){
                 fee = ((open * feePercent) / 100) + ((close * feePercent) / 100)
                
                 lblFee.text = String(format: "%.2f", fee)
             }
             
             
         }
        
         else {
             if let feePercent = Double(lblMaker.text!){
                 fee = ((open * feePercent) / 100) + ((close * feePercent) / 100)
                 
                 lblFee.text =  String(format: "%.2f", fee)
             }
           
         }
        // profit
        if self.trade == Trade.Long {
            let profit :Double = (close - open) - fee
            lblUSDTProfit.text = String(format: "%.2f", profit)
            lblWonProfit.text = String(format: "%.2f", profit * _USD)
           
            // ROE
            lblROE.text = String(format: "%.2f", (profit / margin ) * 100)
            
           
        }
        else {
            let profit :Double = (open - close) - fee
            lblUSDTProfit.text = String(format: "%.2f", profit)
            lblWonProfit.text = String(format: "%.2f", profit * _USD)
            // ROE
            lblROE.text = String(format: "%.2f", (profit / margin ) * 100)
        }
        // ROE
        
       
        
        
       
      
        return
    }
 
    
    
   
   
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }


    func configPickerView() {
        exchangePicker.delegate = self
        exchangePicker.dataSource = self
        exchangeTF.inputView = exchangePicker
        configExchangeToolbar()
        
        methodPicker.delegate = self
        methodPicker.dataSource = self
        methodTF.inputView = methodPicker
        configMethodToolbar()
        
    }
    
    func configExchangeToolbar(){
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        
        exchangeTF.inputAccessoryView = toolBar

        
    }
    func configMethodToolbar(){
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneBT2 = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker2))
        
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelBT2 = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker2))
        
        toolBar.setItems([cancelBT2,flexibleSpace2,doneBT2], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        
        methodTF.inputAccessoryView = toolBar

        
    }
    
    @objc func donePicker() {
        let row = self.exchangePicker.selectedRow(inComponent: 0)
        self.exchangePicker.selectRow(row, inComponent: 0, animated: false)
        self.exchangeTF.text = self.cryptoExchange[row].name
        self.lblMaker.text = String(self.cryptoExchange[row].makerFee)
        self.lblTaker.text = String(self.cryptoExchange[row].takerFee)
        self.exchangeTF.resignFirstResponder()
        self.exchangeTF.textColor = UIColor.white
    }
    
    
    @objc func cancelPicker() {
        self.exchangeTF.text = nil
        self.exchangeTF.resignFirstResponder()
        
    }
    @objc func donePicker2() {
        let row = self.methodPicker.selectedRow(inComponent: 0)
        self.methodPicker.selectRow(row, inComponent: 0, animated: false)
        self.methodTF.text = self.method[row]
        
        self.methodTF.resignFirstResponder()
        self.methodTF.textColor = UIColor.white
    }
    
    
    @objc func cancelPicker2() {
        self.methodTF.text = nil
        self.methodTF.resignFirstResponder()
        
    }
  
    
    
    
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
   
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == exchangePicker{
            return cryptoExchange.count
        }
        else {
            return method.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == exchangePicker{
            return cryptoExchange[row].name
        }
        else {
            return method[row]
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        if pickerView == exchangePicker{
            self.exchangeTF.text = self.cryptoExchange[row].name
            self.lblMaker.text = String(self.cryptoExchange[row].makerFee)
            self.lblTaker.text = String(self.cryptoExchange[row].takerFee)
        }
        else {
            self.methodTF.text = self.method[row]
        }
    }
    
}




