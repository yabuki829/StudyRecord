//
//  DataViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/11.
//

import UIKit
import Charts
import Firebase

class DataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let studyTime = studyTimeClass()
    let language = LanguageClass()
    var MonthStudyData = [Monthly]()
    var MonthStudyArray = [Double]()
    var monthlyTotalStudyTime = [Double]()
    var weekdayStudyTimeData  = [weekStruct]()
    var weekdayStudyTimeArray = [Double]()
    var local = String()
    var isFinish:Bool = false{
        didSet{
            print("取得完了")
            print(MonthStudyData)
            
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        local = language.getlocation()
        settingTableView()
        getMonthlyStudyTime()
        getWeekDayStudyTime()
        getMonthlyTotalStudyTime()
      
        
    }
    


}


extension DataViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataViewCell", for: indexPath) as!DataViewCell
            cell.setCell(day: studyTime.getDay(), month: studyTime.getMonth(), total: studyTime.getTotal(), color: "link")
            return cell
        }
        else if indexPath.row == 1 {
            
            if local == "ja"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                cell.setCell(titleString: "( 曜日毎の累計勉強時間 )", data:weekdayStudyTimeArray)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                cell.setCell(titleString: "( Total Study time for each day of the week )", data: weekdayStudyTimeArray)
                return cell
            }
            
        }
        else if indexPath.row == 2{
            if local == "ja"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                cell.setMonthCell(titleString: "( 月毎の累計勉強時間 )", data: monthlyTotalStudyTime)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                cell.setMonthCell(titleString: "( Monthy Total Study Time)", data:monthlyTotalStudyTime)
                return cell
            }
            
        }
        else if indexPath.row == 3{
            if local == "ja"{
                if MonthStudyData.isEmpty {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                    cell.setMonthCell(titleString: "( 月ごとの勉強時間 )", data: [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,])
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                    cell.setMonthCell(titleString: "( 月毎の勉強時間 )", data: MonthStudyData[0].month)
                    return cell
                }
            }
            else{
                if MonthStudyData.isEmpty {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                    cell.setMonthCell(titleString: "( Monthy Study Time )", data: [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,])
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
                    cell.setMonthCell(titleString: "( Monthy Study Time )", data: MonthStudyData[0].month)
                    return cell
                }
            }
            
           
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        }
        else{
            return 200
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let BarChartCell = UINib(nibName: "BarChartCell", bundle: nil )
        tableView.register(BarChartCell, forCellReuseIdentifier: "BarChartCell")
        
        let DataViewCell = UINib(nibName: "DataViewCell", bundle: nil )
        tableView.register(DataViewCell, forCellReuseIdentifier: "DataViewCell")
        
    }
}


extension DataViewController{
    func getMonthlyStudyTime(){
        print("----------------------------")
        print("取得します")
        let database = Firestore.firestore()
        let userid   = UserDefaults.standard.object(forKey: "userid")
        MonthStudyData = []
        database.collection("Users").document(userid as! String).collection("MonthStudyTime").getDocuments { (querySnapshot, err) in
            if let err = err{
                print("エラー")
                print(err)
                return
            }
            else{
                for document in querySnapshot!.documents {
                    print("取得中")
                    let data = document.data()
                    if let date = data["year"],
                       let month = data["month"]{
                        let year:Date = (date as AnyObject).dateValue()
                        let newData = Monthly(year: year , month: month as! [Double])
                        self.MonthStudyData.append(newData)
                    }
                }
                
            }
            self.isFinish = true
        }
    }
    //曜日ごとの合計勉強時間
    func getWeekDayStudyTime(){
        weekdayStudyTimeData = studyTime.getWeekDayStudy()
        weekdayStudyTimeArray = []
        for i in 0..<7{
            weekdayStudyTimeArray.append(weekdayStudyTimeData[i].studyTime)
        }
    }
    func getMonthlyTotalStudyTime(){
        monthlyTotalStudyTime = studyTime.getMonthlyTotalStudyTime()
        
    }

}
