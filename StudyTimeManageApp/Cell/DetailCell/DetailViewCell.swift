//
//  DetailViewCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/16.
//

import UIKit

class DetailViewCell: UITableViewCell {

    weak var delegate: tableViewUpDater?
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var memoLabel: CustomLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var userID = String()
    var postID = String()
    var userName = String()
    
    var goodCount = Int()
    var isGood = false
    var index = Int()
    let database = Database()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.layer.borderColor = UIColor.systemGray3.cgColor
        stackView.layer.cornerRadius = 2
        stackView.layer.borderWidth = 1
        memoLabel.layer.borderColor = UIColor.systemGray3.cgColor
        memoLabel.layer.cornerRadius = 2
        memoLabel.layer.borderWidth = 1
        memoLabel.numberOfLines = 0
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDetailCell(userid:String,username:String,studyTime: Double,comment:String,date:Date,postid:String,isgood:Bool,count:Int,image:String,commentCount:Int,category:String){
        print("ここだよーーーーーーーーーーーーーーーーーー")
        print(isgood)
        isGood = isgood
        print("-------------------------------")
        goodCount = count
        postID = postid
        userID = userid
        userName = username
        Check(isgood: isgood)
        profileImage.image = UIImage(named: image)
        userNameButton.setTitle(username, for: .normal)
        
        categoryLabel.text = category
        
        if commentCount > 0{
            commentButton.setImage( UIImage(systemName: "message.fill"), for: .normal)
            commentButton.setTitle(String(commentCount), for: .normal)
        }
        let a = divideIntoDecimalsAndIntegers(num: studyTime)
        let intHour = Int(a.integer)
        let intMinutes = Int(a.decimal * 60)
        
        if intHour == 0{
            studyTimeLabel.text = "\(intMinutes)  m"
        }
        else{
            if intMinutes == 0 {
                studyTimeLabel.text = "\(intHour) h"
            }
            else{
                studyTimeLabel.text = "\(intHour) h \(intMinutes) m"
            }
        }
        
        if comment.isEmpty{
            memoLabel.isHidden = true
        }
        else{
            memoLabel.text = comment
        }
      
        dateLabel.text = convertDateToString(date: date)
    }
    func convertDateToString(date:Date) -> String{
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
    func divideIntoDecimalsAndIntegers(num:Double) -> divide{
//        少数部分と整数部分で分割する
        // 49.5  - > 49, 0.8
        let integer = floor(num)
        let decimal = num - integer
        //小数点第3位 四捨五入
        let numFloor = round(decimal*1000)/1000
        let divideNumber = divide(integer: integer, decimal: numFloor)
        return divideNumber
        
    }
    func Check(isgood:Bool){
        if isgood {
            goodButton.setTitle(String(goodCount), for: .normal)
            goodButton.setImage(UIImage(systemName:"hand.thumbsup.fill" ), for: .normal)
        }
        else{
            if goodCount == 0 {
                goodButton.setTitle("", for: .normal)
                goodButton.setImage(UIImage(systemName:"hand.thumbsup" ), for: .normal)
            }
            else{
                goodButton.setTitle(String(goodCount), for: .normal)
                goodButton.setImage(UIImage(systemName:"hand.thumbsup" ), for: .normal)

        }
        }
    }
    
    @IBAction func sendToUserPage(_ sender: Any) {
        //userProfileページに遷移する
        delegate?.sendtoProfile(userid: userID, username:userName )
    }
    @IBAction func tapGood(_ sender: Any) {
        if isGood == false{
            isGood = true
            if isGood {
                print("a")
                database.tapGood(postID: postID)
                    goodCount += 1
                    goodButton.setTitle(String(goodCount), for: .normal)
                    goodButton.setImage(UIImage(systemName:"hand.thumbsup.fill" ), for: .normal)
                    delegate?.tapLike(isLike: true, index: index,count:goodCount)
                
            }
            else{
                goodCount -= 1
                print("b")
                if goodCount == 0 {
                    goodButton.setTitle("", for: .normal)
                    goodButton.setImage(UIImage(systemName:"hand.thumbsup" ), for: .normal)
                }
                else{
                    print("c")
                    goodButton.setTitle(String(goodCount), for: .normal)
                    goodButton.setImage(UIImage(systemName:"hand.thumbsup.fill" ), for: .normal)

                }
            }
        }
        else{
            goodButton.setTitle(String(goodCount), for: .normal)
            goodButton.setImage(UIImage(systemName:"hand.thumbsup.fill" ), for: .normal)
        }
        
    }
}
