//
//  MainViewController.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/11/29.
//

import UIKit
import Charts
import SideMenu
import NendAd

class MainViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    private let rewardedVideo = NADRewardedVideo(spotID: 802555, apiKey: "ca80ed7018734d16787dbda24c9edd26c84c15b8")
    private let interstitialVideo = NADInterstitialVideo(spotID: 802557, apiKey: "b6a97b05dd088b67f68fe6f155fb3091f302b48b")
    //動画広告
    var apiKey = "36b8baae060df21dfa7cdb915082fecc31adf45a"
    var spotID = 1050200
    
    var menu: SideMenuNavigationController?
    
    let studytime = studyTimeClass()
    let language = LanguageClass()
    let date = DateModel()
    
    var elapsedDays = Int()
    var titleString = String()
    var goalString = String()
    var studyTime = Double()
    var time = Time(hour: 0, minutes: 0)
    var dayStudyTime = Double()
    var monthStudyTime = Double()
    var totalStudyTime = Double()
    var weekDayInt = Int()
    var rawData: [Double] = [0,0,0,0,0,0,0]
    var local = String()
    var cellOrder = CellOrder(pieChart: 0, Data: 1, goal: 2, BarChart: 3, until: 4, predict: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.delegate = self
        local  = language.getlocation()
        
       
        //日付が変更されたか確認
        
        if let past_day = UserDefaults.standard.object(forKey: "lastTime") {
            let past = past_day as! Date
            print(date.checkDate(now: Date(), past: past))
        }
        else{
//            初回のみこっち
            let now = Date()
            UserDefaults.standard.setValue(now, forKey: "lastTime")
        }
        setAd()
        settingTableView()
        settingSideMenu()
        getTodayGoal()
        //後何日の設定
        settingUntil()
        
        
        //勉強時間の取得
        dayStudyTime = studytime.getDay()
        monthStudyTime = studytime.getMonth()
        totalStudyTime = studytime.getTotal()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        setNavBarBackgroundColor()
        barChartDataAssign()
        dayStudyTime = studytime.getDay()
        monthStudyTime = studytime.getMonth()
        totalStudyTime = studytime.getTotal()
        if totalStudyTime >= 10000 {
            self.navigationItem.title = "Expert."
        }
        tableView.reloadData()
    }
    func setNavBarBackgroundColor(){
        setStatusBarBackgroundColor(.link)
        self.navigationController?.navigationBar.barTintColor = .link
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.white
        ]
    }

    func settingUntil(){
        let userDefalts = UserDefaults.standard
        if let until:howDays = userDefalts.codable(forKey: "until"){
            let untilArray = until
            timeRemand(date: until.date)
            titleString = untilArray.title
        }
    }
func settingSideMenu(){
    let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
    let Menu: UIViewController = storyboard.instantiateViewController(withIdentifier: "Menu")
    
        menu = SideMenuNavigationController(rootViewController:Menu)
        menu!.leftSide = true
        menu!.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu!
    }
    @IBAction func tapMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    @IBAction func sendtoRecordPage(_ sender: Any) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "record") as! RecordViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }

    func barChartDataAssign(){
        let a = studyTimeClass()
        a.getWeekStudy()
       
        print("データを割り当てます")
        print(a.week)
        for i in 0..<rawData.count{
            rawData[i] = a.week[i].studyTime
        }
        print(rawData)
        tableView.reloadData()
    }
    
    func alert(){
        var alertTextField: UITextField?
        if local == "ja"{
            let alert = UIAlertController(title: "あと何日？", message: "\n\n\n", preferredStyle: .alert)
            alert.addTextField { (textField) in
                alertTextField = textField
                textField.placeholder = "タイトル"
            }
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
            print(datePicker.bounds.size.width)
            datePicker.frame = CGRect(x: datePicker.bounds.size.width / 2.2, y: 5, width: 100, height: 150)
          
            alert.view.addSubview(datePicker)
           
            
            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.titleString = alertTextField!.text!
                self.timeRemand(date: datePicker.date)
                let untilArray = howDays(date: datePicker.date, title: self.titleString)
                UserDefaults.standard.setCodable(untilArray, forKey: "until")
                print(self.titleString)
               
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "How many days", message: "\n\n\n", preferredStyle: .alert)
            alert.addTextField { (textField) in
                alertTextField = textField
                textField.placeholder = "Title"
            }
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.frame = CGRect(x: datePicker.bounds.size.width / 2.2, y: 5, width: 100, height: 150) 
            
            alert.view.addSubview(datePicker)

            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.titleString = alertTextField!.text!
                self.timeRemand(date: datePicker.date)
                let untilArray = howDays(date: datePicker.date, title: self.titleString)
                UserDefaults.standard.setCodable(untilArray, forKey: "until")
                print(self.titleString)
               
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
            
        }
 
       
    }
    func goalAlert(){
        var alertTextField: UITextField?
        if local == "ja"{
            let alert = UIAlertController(title: "今日の目標", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                alertTextField = textField
                textField.placeholder = "目標"
            }
           
            

            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.goalString = alertTextField!.text!
                UserDefaults.standard.setValue(self.goalString, forKey: "todayGoal")
                self.tableView.reloadData()
               
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Today's Goal", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                alertTextField = textField
                textField.placeholder = "Title"
            }
          
            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.goalString = alertTextField!.text!
                UserDefaults.standard.setValue(self.goalString, forKey: "todayGoal")
                self.tableView.reloadData()
               
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
            
        }
    }
    func getTodayGoal(){
        if let a = UserDefaults.standard.object(forKey: "todayGoal"){
            goalString = a as! String
        }
    }

}


extension MainViewController :UITableViewDelegate,UITableViewDataSource,tableViewUpDater{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        if indexPath.row == cellOrder.until{
          
            alert()
        }
        else if indexPath.row == cellOrder.pieChart{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "piedetail") as! PieChartViewDetailController
            next.totalStudyTime = totalStudyTime
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if indexPath.row == cellOrder.BarChart{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "bardetail") as! BarChartViewDetailController
            //動画広告を入れる
            showInterstitialAd()
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if indexPath.row == cellOrder.goal{
            goalAlert()
        }
        else if indexPath.row == cellOrder.Data{
            showRewardAd()
            let next = self.storyboard?.instantiateViewController(withIdentifier: "data") as! DataViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.row == cellOrder.pieChart {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartCell", for: indexPath) as! PieChartCell
            cell.delegate = self
            cell.setCell(total: totalStudyTime, time: 10000)
            return cell
        }
        else if indexPath.row == cellOrder.Data {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataViewCell", for: indexPath) as!DataViewCell
            cell.setCell(day: dayStudyTime, month: monthStudyTime, total: totalStudyTime, color: "link")
            return cell
          
        }
        else if indexPath.row == cellOrder.goal {
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
            let goalLabel = cell.viewWithTag(1) as! UILabel
            goalLabel.text = goalString
            print()
            return cell
           
        }
        else if indexPath.row == cellOrder.BarChart{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
            cell.setCell(titleString: "Weekly Study Time", data: rawData)
            return cell
        }
        else if indexPath.row == cellOrder.until{
            let cell = tableView.dequeueReusableCell(withIdentifier: "untilDateCell", for: indexPath)
            
            if titleString.isEmpty == false{
                let countLabel = cell.viewWithTag(1) as! UILabel
                let titleLabel = cell.viewWithTag(2) as! UILabel
                let dayLeft = cell.viewWithTag(3) as! UILabel
                countLabel.text = String(elapsedDays)
               
                if local == "ja"{
                    if elapsedDays == 0 {
                        titleLabel.text = ""
                        dayLeft.text = ""
                    }
                    else if elapsedDays == 1{
                        titleLabel.text = "\(titleString) まであと１日"
                    }
                    else if elapsedDays > 1{
                     
                        titleLabel.text = "\(titleString)まで残り\(elapsedDays)日"
                    }
                    else if elapsedDays > 365{
                        titleLabel.text = "\(titleString)まで残り\(elapsedDays)日"
                        dayLeft.text = "1日\(10000 / elapsedDays)時間 "
                    }
                    else {
                        countLabel.text = "0"
                        titleLabel.text = ""
                    }
                }
                else{
                    if elapsedDays == 0 {
                        titleLabel.text = " \(titleString) within 24 hours"
                        dayLeft.text = ""
                    }
                    else if elapsedDays == 1{
                        titleLabel.text = "1 day until \(titleString)"
                    }
                    else if elapsedDays > 1{
                     
                        titleLabel.text = "\(elapsedDays) days until \(titleString)"
                    }
                    else if elapsedDays > 365{
                        titleLabel.text = "\(elapsedDays) days until \(titleString)"
                        dayLeft.text = "\(10000 / elapsedDays) hours a day"
                    }
                    else {
                        countLabel.text = "0"
                        titleLabel.text = ""
                    }
                }
                
               
            }
            return cell
        }
        else if indexPath.row == cellOrder.predict{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PredictCell", for: indexPath) as! PredictCell
            cell.setPredict(studyTime:Int(totalStudyTime))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cellOrder.pieChart{
            return 180
        }
        else if indexPath.row == cellOrder.Data{
            return 80
        }
        else if indexPath.row == cellOrder.goal{
            return UITableView.automaticDimension
        }
        else if indexPath.row == cellOrder.BarChart {
            return 200
        }
        else if indexPath.row == cellOrder.predict && indexPath.row == cellOrder.until{
            return 120
        }
        else{
            return 150
        }
    }

    //残り日数
    func timeRemand(date:Date){
    
        elapsedDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
        if elapsedDays == 0{
            UserDefaults.standard.removeObject(forKey: "until")
        }
        tableView.reloadData()
    }
    func updateTableView() {
        print("リロード")
        barChartDataAssign()
        dayStudyTime = studytime.getDay()
        monthStudyTime = studytime.getMonth()
        totalStudyTime = studytime.getTotal()
        tableView.reloadData()
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let BarChartCell = UINib(nibName: "BarChartCell", bundle: nil )
        tableView.register(BarChartCell, forCellReuseIdentifier: "BarChartCell")
        
        
        let PieChartCell = UINib(nibName: "PieChartCell", bundle: nil )
        tableView.register(PieChartCell, forCellReuseIdentifier: "PieChartCell")
        
        let DataViewCell = UINib(nibName: "DataViewCell", bundle: nil )
        tableView.register(DataViewCell, forCellReuseIdentifier: "DataViewCell")
        
        let predictCell = UINib(nibName: "PredictCell", bundle: nil )
        tableView.register(predictCell, forCellReuseIdentifier: "PredictCell")
        
    }
    func tapLike(isLike: Bool, index: Int, count: Int) {}
    func sendtoProfile(userid: String, username: String) {}
    func move() {}
    
    

}

//X軸を曜日にするために使っている。youbi


extension MainViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
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
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        if component == 0{
            time.hour = row
        }
        else if component == 1{
            time.minutes = row
        }
        
        let numFloor = ceil(Double(minutesList[time.minutes]) / 60 * 1000)/1000
        studyTime = Double(hoursList[time.hour]) + numFloor
    }


}

extension MainViewController:NADViewDelegate, NADInterstitialVideoDelegate, NADRewardedVideoDelegate{
    func nadRewardVideoAd(_ nadRewardedVideoAd: NADRewardedVideo!, didReward reward: NADReward!) {
        print("呼ばれました")
    }
    func nadInterstitialVideoAdDidReceiveAd(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        //動画広告
        print("受信完了")
    }
    
    
    //エラー
    func nadInterstitialVideoAd(_ nadInterstitialVideoAd: NADInterstitialVideo!, didFailToLoadWithError error: Error!) {
        //動画広告
        print("エラーです")
    }
    
    //表示がされない
    func nadInterstitialVideoAdDidFailed(toPlay nadInterstitialVideoAd: NADInterstitialVideo!) {
        //動画広告
        print("表示がされない")
    }
    func showInterstitialAd(){
        if self.interstitialVideo.isReady {
            self.interstitialVideo.showAd(from: self)
        }
    }
    func showRewardAd(){
        if self.rewardedVideo.isReady {
            self.rewardedVideo.showAd(from: self)
        }
    }
    func setAd(){
        self.rewardedVideo.userId = "user id"
        self.rewardedVideo.delegate = self
        self.rewardedVideo.loadAd()
        
        self.interstitialVideo.userId = "user id"
        self.interstitialVideo.isMuteStartPlaying = false
        self.interstitialVideo.delegate = self
        self.interstitialVideo.addFallbackFullboard(withSpotID: 485504, apiKey: "30fda4b3386e793a14b27bedb4dcd29f03d638e5")
        self.interstitialVideo.loadAd()
    }
    
}
