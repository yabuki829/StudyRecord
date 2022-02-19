//
//  TextfieldViewCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/18.
//

import UIKit

class TextfieldViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    let databaseModel = Database()
    let language = LanguageClass()
    var postID = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let local = language.getlocation()
        if local ==  "ja"{
            textField.placeholder = "コメント"
        }
        else{
            textField.placeholder = "Comment"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(postid:String){
        postID = postid
    }
    @IBAction func send(_ sender: Any) {
        
        if textField.text?.isEmpty == true{
            return
        }
        else{
            databaseModel.postComment(comment: textField.text!, postID: postID)
            textField.text = "" 
        }
    }
    
}
