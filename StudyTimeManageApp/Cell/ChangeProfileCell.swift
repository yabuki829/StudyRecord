//
//  ChangeProfileTableViewCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/03/28.
//

import UIKit


protocol moveSelectImageViewProtcol{
    func move(name:String,goal:String,image:String)
}

class ChangeProfileCell: UITableViewCell ,UITextViewDelegate{
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: PlaceTextView!
    var imageString = String()
    var delegate : moveSelectImageViewProtcol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setting()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setting(){
        
//        textView.delegate = self
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        textView.sizeToFit()
        textField.placeholder = "名前を入力してください"
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        profileImage.addGestureRecognizer(tap)
        
        
    }
    func setCell(image:String,username:String,goal:String){
        imageString = image
        profileImage.image = UIImage(named: imageString)
        textField.text = username
        textView.text = goal
    }
    @objc internal func tapGesture(sender: UITapGestureRecognizer){
        let nameandgoal = [textField.text, textView.text]
        
        //改善案模索中-
        UserDefaults.standard.setValue(nameandgoal, forKey: "A")
        delegate?.move(name: textField.text!, goal: textView.text, image: imageString)
        
    }
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.text.isEmpty {
            self.textView.placeHolder = "目標を入力してください"
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                           replacementText text: String) -> Bool {
           if text == "\n" {
               textView.resignFirstResponder() //キーボードを閉じる
               return false
           }
           return true
       }
}

