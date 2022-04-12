//
//  RecordiewCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/03/26.
//

import UIKit
import IQKeyboardManagerSwift

class RecordViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var StudyTimeStackView: UIStackView!

    @IBOutlet weak var studyTimeTextField: CustomTextField!
    @IBOutlet weak var categoryTextField: CustomTextField!
    
    @IBOutlet weak var textView: PlaceTextView!
    
    var pickerView: UIPickerView = UIPickerView()
    var categryPickerView = UIPickerView()
    var viewWidth = CGFloat()
    var viewHeight = CGFloat()
    var studyTime = Double()
    var category  = String()
    var memo      = String()
    var hours = 0
    var minutes = 0
    
    var categoeyJapanese = ["選択してください","スキルアップ","受験勉強","資格取得","趣味","読書"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        studyTimeTextField.delegate = self
        categoryTextField.delegate = self
        
        studyTimeTextField.setUnderLine(color: .lightGray)
        categoryTextField.setUnderLine(color: .lightGray)
        
        textView.setTopLine(color: .darkGray)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        textView.sizeToFit()
        
        studyTimeTextField.isUserInteractionEnabled = true
        categoryTextField.isUserInteractionEnabled = true
        textView.placeHolder = "Memo"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == studyTimeTextField{
            
        }
        else if textField == categoryTextField{
            category = categoryTextField.text!
        }
       
    }
    func setting(toolbarWidth:CGFloat,toolbarHeight:CGFloat){
        viewWidth = toolbarWidth
        viewHeight = toolbarHeight
        settingTextField()
    }
    private func settingTextField(){
        IQKeyboardManager.shared.enable = true
        pickerView.delegate = self
        pickerView.dataSource = self
        categryPickerView.delegate = self
        categryPickerView.dataSource = self
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width:viewWidth , height: 30))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        studyTimeTextField.inputView = pickerView
        studyTimeTextField.inputView?.frame.size.height = CGFloat(viewHeight / 3)
        studyTimeTextField.inputAccessoryView = toolbar
        
        

        
        // 決定バーの生成
        let toolbarCategory = UIToolbar(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 30))
        let spacelItemCategory = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItemCategory = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCategory))
        toolbarCategory.setItems([spacelItemCategory, doneItemCategory], animated: true)
        // インプットビュー設定
        categoryTextField.inputView = categryPickerView
        categoryTextField.inputView?.frame.size.height = viewHeight / 3
        categoryTextField.inputAccessoryView = toolbarCategory
        
    }
    private func check(){
            if hours == 0 {
                if minutes == 0{
                    studyTimeTextField.text = ""
                }
                else{
                    studyTimeTextField.text = "\(minutes)分"
                }
              
            }
            else{
                if minutes == 0{
                    studyTimeTextField.text = "\(hours)時間"
                }
                else{
                    studyTimeTextField.text = "\(hours)時間\(minutes)分"
                }
               
            }

    }
    @objc func done() {
        print("閉じます")
        studyTimeTextField.endEditing(true)
        check()
    }
    @objc func doneCategory() {
        print("閉じます")
        
        categoryTextField.endEditing(true)
    }
    
}


extension RecordViewCell:UIPickerViewDelegate,UIPickerViewDataSource{
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.pickerView{
            return 2
        }
        else{
            return 1
        }
       
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    internal func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        if pickerView == categryPickerView{
       
                return categoeyJapanese[row]
            
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
    internal func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == categryPickerView{
            if row == 0{
                categoryTextField.text = ""
                category = ""
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
        placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
        placeHolderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        placeHolderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 15),
        placeHolderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
//           placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
//           placeHolderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
       ])

   }

   @objc private func textDidChanged() {
       let shouldHidden = self.placeHolder.isEmpty || !self.text.isEmpty
       self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
   }

}


