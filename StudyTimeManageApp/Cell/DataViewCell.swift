//
//  DataViewCell.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/04.
//

import UIKit

class DataViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayTitleLabel: UILabel!
    
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var monthTitleLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    
    var dayStudyTime = Double()
    var monthStudyTime = Double()
    var totalStudyTime = Double()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackView.layer.borderColor = UIColor.systemGray3.cgColor
        todayLabel.layer.borderColor = UIColor.systemGray3.cgColor
        MonthLabel.layer.borderColor = UIColor.systemGray3.cgColor
        totalLabel.layer.borderColor = UIColor.systemGray3.cgColor
        stackView.layer.borderWidth = 1
        todayLabel.layer.borderWidth = 1
        MonthLabel.layer.borderWidth = 1
        totalLabel.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setCell(day:Double,month:Double,total:Double,color:String){
        
        let local  = LanguageClass().getlocation()
        let a = divideIntoDecimalsAndIntegers(num: day)
        let intHour = Int(a.integer)
        let intMinutes = Int(a.decimal * 60)
        if color == "red"{
            todayTitleLabel.backgroundColor = .systemRed
            monthTitleLabel.backgroundColor = .systemRed
            totalTitleLabel.backgroundColor = .systemRed
        }
        
        if local == "ja"{
            if intHour == 0{
                todayLabel.text = "\(intMinutes) 分"
            }
            else{
                if intMinutes == 0 {
                    todayLabel.text = "\(intHour) 時間"
                }
                else{
                    todayLabel.text = "\(intHour) 時間 \(intMinutes) 分"
                }
            }
            MonthLabel.text = "\(Int(month)) 時間"
            totalLabel.text = "\(Int(total)) 時間"
        }
        else{
            if intHour == 0{
                todayLabel.text = "\(intMinutes)  m"
            }
            else{
                if intMinutes == 0 {
                    todayLabel.text = "\(intHour) h"
                }
                else{
                    todayLabel.text = "\(intHour) h \(intMinutes) m"
                }
            }
            MonthLabel.text = "\(Int(month)) h"
            totalLabel.text = "\(Int(total)) h"
        }
       
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
}
