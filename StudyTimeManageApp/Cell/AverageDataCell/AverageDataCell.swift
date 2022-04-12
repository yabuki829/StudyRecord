//
//  AverageDataCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/04/12.
//

import UIKit

class AverageDataCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dailyStackView: UIStackView!
    @IBOutlet weak var monthlyStackView: UIStackView!
    @IBOutlet weak var dailyAverageLabel: UILabel!
    @IBOutlet weak var monthlyAverageLabel: UILabel!
    let studyTime = studyTimeClass()
    var elapsedDays = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackView.layer.borderColor = UIColor.systemGray3.cgColor
        dailyStackView.layer.borderColor = UIColor.systemGray3.cgColor
        monthlyStackView.layer.borderColor = UIColor.systemGray3.cgColor
        stackView.layer.borderWidth = 1
        dailyStackView.layer.borderWidth = 1
        monthlyStackView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setCell(total:Double,month:Double){
        setDailyAverage(total: total)
        setMonthlyAverage(total: total, month: month)
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
    func setDailyAverage(total:Double){
        if let a = UserDefaults.standard.object(forKey: "initialdate"){
            elapsedDays = studyTime.getHowManyDays(date:a as! Date) + 1
            print("elapsedDay",elapsedDays)
        }
        
        let a = divideIntoDecimalsAndIntegers(num:total / Double(elapsedDays))
        let intHour = Int(a.integer)
        let intMinutes = Int(a.decimal * 60)
        
        if intHour == 0{
            dailyAverageLabel.text = "\(intMinutes) 分"
        }
        else{
            if intMinutes == 0 {
                dailyAverageLabel.text = "\(intHour) 時間"
            }
            else{
                dailyAverageLabel.text = "\(intHour) 時間 \(intMinutes) 分"
            }
        }
    }
    func setMonthlyAverage(total:Double,month:Double){
        if let a = UserDefaults.standard.object(forKey: "initialdate"){
            elapsedDays = studyTime.getHowManyDays(date:a as! Date) + 1
        }
        if elapsedDays >= 30{
            let a = divideIntoDecimalsAndIntegers(num:total / Double(elapsedDays / 30))
            let intHour = Int(a.integer)
            let intMinutes = Int(a.decimal * 60)
            if intHour == 0{
                monthlyAverageLabel.text = "\(intMinutes) 分"
            }
            else{
                if intMinutes == 0 {
                    monthlyAverageLabel.text = "\(intHour) 時間"
                }
                else{
                    monthlyAverageLabel.text = "\(intHour) 時間 \(intMinutes) 分"
                }
            }
        }
        else{
            let a = divideIntoDecimalsAndIntegers(num:month)
            let intHour = Int(a.integer)
            let intMinutes = Int(a.decimal * 60)
            
            if intHour == 0{
                monthlyAverageLabel.text = "\(intMinutes) 分"
            }
            else{
                if intMinutes == 0 {
                    monthlyAverageLabel.text = "\(intHour) 時間"
                }
                else{
                    monthlyAverageLabel.text = "\(intHour) 時間 \(intMinutes) 分"
                }
            }
        }
       
    }
}
