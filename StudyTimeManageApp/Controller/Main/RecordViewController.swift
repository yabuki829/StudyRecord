//
//  RecordViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/13.
//

import UIKit
import GoogleMobileAds
class RecordViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var textView: PlaceTextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let StudyTime = studyTimeClass()
    let language = LanguageClass()
    var pickerView: UIPickerView = UIPickerView()
    var categryPickerView = UIPickerView()
    var studyTime = Double()
    var hours = 0
    var minutes = 0
    var local = String()
    var category = String()
    //ca-app-pub-9515239279115600/9215702391
    var categoeyJapanese = ["スキルアップ","受験勉強","資格取得","趣 味",]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAd()
        setStatusBarBackgroundColor(.link)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textField.isUserInteractionEnabled = true
        categoryTextField.isUserInteractionEnabled = true
        textView.placeHolder = "Memo"
        settingTextField()
        settingCategoryTextField()
        local = language.getlocation()
    }
    @IBAction func backHome(_ sender: Any) {
        //前の画面に戻る
        navigationController?.popViewController(animated: true)
       
    }

    @IBAction func record(_ sender: Any) {
        
        print(studyTime)
        if studyTime == 0.0 {
            return
        }
        else{
            StudyTime.save(studyTime: studyTime,comment: textView.text, category: category)
            navigationController?.popViewController(animated: true)
        }
       
        
    }
    func setAd(){
        let unitID = "ca-app-pub-9515239279115600/9215702391"
        let testAd = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = unitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    func settingTextField(){
        pickerView.delegate = self
        pickerView.dataSource = self
//        pickerView.showsSelectionIndicator = true
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        textField.inputView = pickerView
        textField.inputView?.frame.size.height = view.frame.height / 3
        textField.inputAccessoryView = toolbar
    }
  
    func settingCategoryTextField(){
        categryPickerView.delegate = self
        categryPickerView.dataSource = self
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        categoryTextField.inputView = categryPickerView
        categoryTextField.inputView?.frame.size.height = view.frame.height / 3
        categoryTextField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        textField.endEditing(true)
        check()
    }
    @objc func done2() {
        categoryTextField.endEditing(true)
        categoryTextField.text = category
    }
    
}


extension RecordViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.pickerView{
            return 2
        }
        else{
            return 1
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categryPickerView{
            return categoeyJapanese.count
        }
        else{
            if component == 0 {
                return hoursList.count
            }
            else if component == 1{
                return minutesList.count
            }
            else{
                return 0
            }
        }
        
       
    }
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        if pickerView == categryPickerView{
            if local == "ja"{
                return categoeyJapanese[row]
            }
            else{
                return categoeyJapanese[row]
            }
        }else{
            if component == 0 {
                return String(hoursList[row])
            }
            else if component == 1{
                return String(minutesList[row])
            }
            else{
                return ""
            }
        }
       
    }
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == categryPickerView{
            if local == "ja"{
                categoryTextField.text = categoeyJapanese[row]
                category = categoeyJapanese[row]
            }
            else{
                categoryTextField.text = categoeyJapanese[row]
                category = categoeyJapanese[row]
            }
        }
        else{
            if component == 0{
                hours = row
            }
            else if component == 1{
                minutes = row
            }
            let numFloor = ceil(Double(minutesList[minutes]) / 60 * 1000)/1000
            studyTime = Double(hoursList[hours]) + numFloor
            
            check()
            
            
        }
       
       
    }
    func check(){
        if local == "ja"{
            if hours == 0 {
                if minutes == 0{
                    textField.text = ""
                }
                else{
                    textField.text = "\(minutes)分"
                }
              
            }
            else{
                if minutes == 0{
                    textField.text = "\(hours)時間"
                }
                else{
                    textField.text = "\(hours)時間\(minutes)分"
                }
               
            }
        }
        else{
            if hours == 0 {
                if minutes == 0{
                    textField.text = ""
                }
                else{
                    textField.text = "\(minutes) M"
                }
              
            }
            else{
                if minutes == 0{
                    textField.text = "\(hours) H"
                }
                else{
                    textField.text = "\(hours) H \(minutes) M"
                }
               
            }
        }
       
    }
    
}





class PlaceTextView: UITextView {

   var placeHolder: String = "" {
       willSet {
           self.placeHolderLabel.text = newValue
           self.placeHolderLabel.sizeToFit()
       }
   }

   private lazy var placeHolderLabel: UILabel = {
       let label = UILabel()
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 0
       label.font = self.font
       label.textColor = .darkGray
       label.backgroundColor = .clear
       label.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(label)
       return label
   }()

   override func awakeFromNib() {
       super.awakeFromNib()

       NotificationCenter.default.addObserver(self,
                                              selector: #selector(textDidChanged),
                                              name: UITextView.textDidChangeNotification,
                                              object: nil)

       NSLayoutConstraint.activate([
           placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
           placeHolderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 7),
           placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
           placeHolderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
       ])

   }

   @objc private func textDidChanged() {
       let shouldHidden = self.placeHolder.isEmpty || !self.text.isEmpty
       self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
   }

}


