//
//  CommnentCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/18.
//

import UIKit
import FirebaseFirestore

class CommnentCell: UITableViewCell {

    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    var postID = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
        commentView.layer.borderWidth = 1.0
        commentView.layer.borderColor =  UIColor.lightGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setCell(username:String,comment:String, date:Date, image:String){
        
        userNameLabel.text = username
        commentView.text = comment
        dateLabel.text = Date().secondAgo(createdAt: date)
        profileImage.image = UIImage(named: image)
    }
    func convertDateToString(date:Date) -> String{
        let locale = Locale.current
        let localeId = locale.identifier
        print(localeId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        // 変換
        let str = dateFormatter.string(from: date)

        // 結果表示

        return str
    }

    func convertDateToStringShort(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .autoupdatingCurrent
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        // 変換
        let str = dateFormatter.string(from: date)
        // 結果表示
        return str
    }
}
