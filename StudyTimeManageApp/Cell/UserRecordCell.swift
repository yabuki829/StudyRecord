//
//  UserRecordCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/14.
//

import UIKit

class UserRecordCell: UITableViewCell {

    weak var delegate: tableViewUpDater?
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var memoLabel: CustomLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    
    var userID = String()
    var postID = String()
    var userName = String()
    
    var goodCount = Int()
    var isGood = false
    var index = Int()
    let database = Database()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        stackView.layer.borderColor = UIColor.systemGray3.cgColor
        stackView.layer.cornerRadius = 2
        stackView.layer.borderWidth = 1
        memoLabel.layer.borderColor = UIColor.systemGray3.cgColor
        memoLabel.layer.cornerRadius = 2
        memoLabel.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setHomeCell(userid:String,username:String,studyTime: Double,comment:String,date:Date,postid:String,image:String){
        
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
        postID = postid
        userID = userid
        userName = username
        profileImage.image = UIImage(named: image)
        userNameButton.setTitle(username, for: .normal)
        goodButton.isHidden = true
        commentButton.isHidden = true
        
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
        if comment.isEmpty == true {
            memoLabel.isHidden = true
        }
        else{
            memoLabel.isHidden = false
            memoLabel.text = comment
        }
            
        
        dateLabel.text = Date().secondAgo(createdAt: date)
    }
    //date型を 2021/12/21 や　12/21/2021 などに変える
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
                goodButton.setImage(UIImage(systemName:"hand.thumbsup.fill" ), for: .normal)

        }
        }
    }
    
    @IBAction func sendToUserPage(_ sender: Any) {
        //userProfileページに遷移する
        delegate?.sendtoProfile(userid: userID, username:userName )
    }
    @IBAction func tapGood(_ sender: Any) {
        print("タップ")
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

protocol tableViewUpDater: class {
    func updateTableView()
    func sendtoProfile(userid:String,username:String)
    func move()
    func tapLike(isLike:Bool,index:Int,count:Int)
}

