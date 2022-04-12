//
//  PredictCell.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/05.
//

import UIKit

class PredictCell: UITableViewCell {

    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var predictCountLabel: UILabel!
    var elapsedDays = Int()
    let language = LanguageClass()
    let study    = studyTimeClass()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setPredict(studyTime:Int){
        var initialDate = Date()
        if let a = UserDefaults.standard.object(forKey: "initialdate"){
            initialDate = a as! Date
            //最初にアカウントを作成して何日経過したのかを確認する
            elapsedDays = study.getHowManyDays(date:initialDate)
        }
        else{
            elapsedDays = 1
        }
        //　平均 = 総勉強時間　/ アプリを初回起動した日から今日までの経過日数
        
        if studyTime == 0 {
        
            predictCountLabel.text = String(study.getGoalTime())
            predictLabel.text = String("約\(study.getGoalTime())日で達成")
            predictLabel.textAlignment = .center
        }
        else{
            print("総勉強時間",studyTime ,"経過日数:",elapsedDays)
            var average = Double(studyTime / elapsedDays)
            if average < 1{
                average = 1
            }
            //  (10000 - 総勉強時間) / 平均勉強時間　= 10000時間達成するまでかかる日数
            let predictTime = Double(study.getGoalTime() - studyTime) / average
            predictCountLabel.text = "\(Int(predictTime))"
            let local = language.getlocation()
            
            if local == "ja"{
                if predictTime == 0{
                    predictLabel.text = "\(study.getGoalTime())時間達成 !!"
                }
                else{
                    predictLabel.text = "約 \(Int(predictTime))日で達成できます"
                }
               
            }
            else{
                if predictTime == 0{
                    predictLabel.text = "Achieved \(study.getGoalTime()) hours"
                }
                else{
                    predictLabel.text =   "Can be achieved in \(Int(predictTime)) days "
                  
                }
                
               
            }
        }
       
    }
    
   
}
