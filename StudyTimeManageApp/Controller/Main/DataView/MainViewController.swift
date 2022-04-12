//
//  MainViewController.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/11/29.
//

import UIKit
import Charts
import SideMenu
import GoogleMobileAds
import FirebaseAuth

class MainViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    private var interstitial: GADInterstitialAd?
    var menu: SideMenuNavigationController?

    let studytime = studyTimeClass()
    let language = LanguageClass()
    let date = DateModel()
    let user = UserModel()
    
    
//    あと何日の残り日数
    var elapsedDays = Int()
    var titleString = String()
    
    var goalString = String()
    var selectStudyTime = Double()
    var time = Time(hour: 0, minutes: 0)
    var rawData: [Double] = [0,0,0,0,0,0,0]
    var cellOrder = CellOrder(pieChart: 0, Data: 1, goal: 2, BarChart: 3, until: 4, predict: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
       
        print(Auth.auth().currentUser!.isAnonymous)
       
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
        setAD()
        settingTableView()
        settingSideMenu()
        //後何日の設定
        settingUntil()


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        setNavBarBackgroundColor()
        barChartDataAssign()
        if studytime.getTotal() >= 10000 {
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
            getHowManyDays(date: until.date)
            titleString = until.title
        }
    }
    func settingSideMenu(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let Menu: UIViewController = storyboard.instantiateViewController(withIdentifier: "Menu")
        menu = SideMenuNavigationController(rootViewController:Menu)
        menu!.leftSide = true
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
        
        for i in 0..<rawData.count{
            rawData[i] = a.week[i].studyTime
        }
        print(rawData)
        tableView.reloadData()
    }
    
    func alert(){
        //-TODO Alert内のdatepickerのUIを　https://qiita.com/ryosuke_tamura/items/6a672ab50b7d8237798a　のようにする
        var alertTextField: UITextField?
        
        if language.getlocation() == "ja"{
            let alert = UIAlertController(title: "あと何日？", message: "\n\n\n", preferredStyle: .alert)
            let howdays = user.getHowMany()
            alert.addTextField { (textField) in
                alertTextField = textField
                alertTextField?.text = howdays.title
                textField.placeholder = "タイトル"
            }
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
         
//            datePicker.setDate(howdays.date, animated: false)
            print(datePicker.bounds.size.width)
            datePicker.date = howdays.date
           
            datePicker.frame = CGRect(x:datePicker.bounds.size.width / 2.2 , y: 5, width:110 , height:  150)
          
            alert.view.addSubview(datePicker)
           
            
            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.titleString = alertTextField!.text!
                self.getHowManyDays(date: datePicker.date)
                let untilArray = howDays(date: datePicker.date, title: self.titleString)
                UserDefaults.standard.setCodable(untilArray, forKey: "until")
                self.tableView.reloadData()
               
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
                alertTextField?.text = self.goalString
                textField.placeholder = "Title"
            }
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
            datePicker.calendar = .current
            
            alert.view.addSubview(datePicker)

            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.titleString = alertTextField!.text!
                self.getHowManyDays(date: datePicker.date)
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
        if language.getlocation() == "ja"{
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
    

}


extension MainViewController :UITableViewDelegate,UITableViewDataSource,tableViewUpDater{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        if indexPath.row == cellOrder.until{
            alert()
        }
        else if indexPath.row == cellOrder.pieChart{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "piedetail") as! PieChartViewDetailController
            next.totalStudyTime = studytime.getTotal()
            
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if indexPath.row == cellOrder.BarChart{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "barChart") as! BarChartViewController
            
            //動画広告を入れる
            if interstitial != nil {
                interstitial!.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
            print("遷移しました")
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if indexPath.row == cellOrder.goal{
            goalAlert()
        }
        
        else if indexPath.row == cellOrder.Data{
            //動画広告を入れる
            if interstitial != nil {
                interstitial!.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
            
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
            cell.setCell(total: studytime.getTotal(), time: studytime.getGoalTime())
            return cell
        }
        else if indexPath.row == cellOrder.Data {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataViewCell", for: indexPath) as!DataViewCell
            cell.setCell(day: studytime.getDay(), month: studytime.getMonth(), total: studytime.getTotal(), color: "link")
            return cell
          
        }
        else if indexPath.row == cellOrder.goal {
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
            let goalLabel = cell.viewWithTag(1) as! UILabel
            goalLabel.text = user.getTodayGoal()

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
               
                if language.getlocation() == "ja"{
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
            cell.setPredict(studyTime:Int(studytime.getTotal()))
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
            return  80
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

    func getHowManyDays(date:Date){
        elapsedDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
        tableView.reloadData()
        if elapsedDays == 0{
            UserDefaults.standard.removeObject(forKey: "until")
        }
      
    }
    func updateTableView() {
        barChartDataAssign()
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






extension MainViewController :GADFullScreenContentDelegate{
    func setAD(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-9515239279115600/1839473935",
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                              return
                            }
                            interstitial = ad
                            interstitial?.fullScreenContentDelegate = self
                          }
        )
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("AAAAAAAAAAAAaAd did fail to present full screen content.")
      }

      /// Tells the delegate that the ad presented full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("BBBBBBBBBBBBBBAd did present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("CCCCCCCCCCCCCCAd did dismiss full screen content.")
      }
}
