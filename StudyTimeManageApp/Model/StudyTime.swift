//
//  File.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/01.
//
import Foundation
import Kronos

public let hoursList = [
    0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
]
public let minutesList = [0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59
]


struct weekStruct :Codable{
    let day:String
    var studyTime:Double
}

//あと何日機能
struct  howDays:Codable {
    let date: Date
    let title: String
}

class studyTimeClass{
    let userDefaults = UserDefaults.standard
    let database = Database()
    let dateModel = DateModel()
    var week = [
        weekStruct(day: "Mon", studyTime: 0.0),
        weekStruct(day: "Tue", studyTime: 0.0),
        weekStruct(day: "Wed", studyTime: 0.0),
        weekStruct(day: "Sat", studyTime: 0.0),
        weekStruct(day: "Fri", studyTime: 0.0),
        weekStruct(day: "Thu", studyTime: 0.0),
        weekStruct(day: "Sun", studyTime: 0.0),
    ]
    //週ごとの累計勉強時間に使用している
    var weekDayStudy = [
        weekStruct(day: "Mon", studyTime: 0.0),
        weekStruct(day: "Tue", studyTime: 0.0),
        weekStruct(day: "Wed", studyTime: 0.0),
        weekStruct(day: "Sat", studyTime: 0.0),
        weekStruct(day: "Fri", studyTime: 0.0),
        weekStruct(day: "Thu", studyTime: 0.0),
        weekStruct(day: "Sun", studyTime: 0.0),
    ]
    func getWeekDay(date:Date) -> Int{
        let calendar = Calendar.current
        //取得する要素を選択する　日と曜日を選択している
        let component = (calendar as NSCalendar).components([NSCalendar.Unit.weekday], from: date)
        
        return dateModel.convert(weekInt: component.weekday!)
    }
    func getMonthDay(date:Date) -> Int{
        
        let calendar = Calendar.current
        let component = (calendar as NSCalendar).components([NSCalendar.Unit.month], from: date)
        return component.month!
    }
    func getDay() -> Double{
        if let day = UserDefaults.standard.object(forKey: "day") {
            return day as! Double
        }
        else {
            return 0.0
        }
        
    }
    func getMonth() -> Double{
        if let month = UserDefaults.standard.object(forKey: "month"){
            return month as! Double
        }
        else{
            return 0.0
        }
    }
    func getTotal() -> Double{
        if let total = UserDefaults.standard.object(forKey: "total") {
            return total as! Double
        }
        else {
            return 0.0
        }
    }

    
    func save(studyTime:Double,comment:String,category:String){
        //一日の勉強時間　 一ヶ月の勉強時間　今までの勉強時間
        print("saveします",studyTime)
        
        let day = UserDefaults.standard.object(forKey: "day") as? Double ?? 0.0
        let month:Double = UserDefaults.standard.object(forKey: "month")  as? Double ?? 0.0
        let total:Double = UserDefaults.standard.object(forKey: "total")  as? Double ?? 0.0
        getWeekStudy()
       
        
        userDefaults.setValue(studyTime + day, forKey: "day")
        userDefaults.setValue(studyTime + month , forKey: "month")
        userDefaults.setValue(studyTime + total , forKey: "total")
        
        
//        weekに勉強時間を割り当てる
        let weekday = getWeekDay(date: Date())
        week[weekday].studyTime = week[weekday].studyTime + studyTime
        
        saveWeekDay(weekday: weekday, studyTime:studyTime)
        //weekをローカルに保存
        saveWeekStudy()
        
        //月間の勉強時間を保存する
        Clock.sync(from: "ntp.nict.jp")
        let postDate = Clock.now  ?? Date()
        let monthint = getMonthDay(date: postDate)
        saveMonthlyStudyTime(studytime:studyTime, month:monthint )
        
        //今までの月毎の累計勉強時間
        saveMonthlyTotalStudyTime(studytime: studyTime, month: monthint)
        //勉強時間を保存 total month day
        database.postData(today: studyTime + day, month: studyTime + month, total: studyTime + total)
        //投稿を保存
        database.postRecord(todayStudyTime: studyTime, comment: comment, image:  getProfileImage(), category: category, postDate: postDate)
        //月毎の勉強時間を保存
        database.saveMonthlyStudyTime(postDate: postDate)
        //月曜日から日曜日までの一日ごとの勉強時間を保存
        database.saveWeekStudyTime(postDate: postDate)
        
    }
    
    func deleteStudyTime(deleteTime:Double){
        //一日の勉強時間　 一ヶ月の勉強時間　今までの勉強時間
        //月毎の勉強時間は削除しない
        let day = UserDefaults.standard.object(forKey: "day") as? Double ?? 0.0
        let month:Double = UserDefaults.standard.object(forKey: "month")  as? Double ?? 0.0
        let total:Double = UserDefaults.standard.object(forKey: "total")  as? Double ?? 0.0
        
        deleteMonthlyStudyTime(studytime: deleteTime, month: getMonthDay(date: Date()))
        deleteMonthlyTotalStudyTime(studytime: deleteTime, month: getMonthDay(date: Date()))
        database.saveMonthlyStudyTime(postDate: Date())
        database.postData(today: day, month: month, total: total)
        deleteWeekDayStudyTime(weekday: getWeekDay(date: Date()), studyTime: deleteTime)
        
        if day - deleteTime >= 0.0{
            userDefaults.setValue(day - deleteTime, forKey: "day")
            userDefaults.setValue(month - deleteTime, forKey: "month")
            userDefaults.setValue(total - deleteTime, forKey: "total")
            switch getWeekDayInt() {
                case 1:
                    guard week[6].studyTime == 0  else { return }
                    week[6].studyTime = day - deleteTime
                case 2:
                    guard week[0].studyTime == 0  else { return }
                    week[0].studyTime = day - deleteTime
                case 3:
                    guard week[1].studyTime == 0  else { return }
                    week[1].studyTime = day - deleteTime
                case 4:
                    guard week[2].studyTime == 0  else { return }
                    week[2].studyTime = day - deleteTime
                case 5:
                    guard week[3].studyTime == 0  else { return }
                    week[3].studyTime = day - deleteTime
                case 6:
                    guard week[4].studyTime == 0  else { return }
                    week[4].studyTime = day - deleteTime
                case 7:
                    guard week[5].studyTime == 0  else { return }
                    week[5].studyTime = day - deleteTime
                case 8:
                    guard week[6].studyTime == 0  else { return }
                    week[6].studyTime = day - deleteTime
                default:
                    print("エラー")
                }
            userDefaults.setCodable(week, forKey: "week")
        }
        else{
           
            if month - deleteTime >= 0.0{
                userDefaults.setValue(month - deleteTime, forKey: "month")
                userDefaults.setValue(total - deleteTime, forKey: "total")
            }
            else{
                
                if total - deleteTime > 0.0 {
                    userDefaults.setValue(total - deleteTime, forKey: "total")
                }
            }
           
        }
    }
//曜日ごとの累計勉強時間ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    func saveWeekDay(weekday:Int,studyTime:Double){
        if let data:[weekStruct] = userDefaults.codable(forKey: "weekDay"){
            weekDayStudy = data
            weekDayStudy[weekday].studyTime += studyTime
            UserDefaults.standard.setCodable(weekDayStudy, forKey: "weekDay")
        }
        else{
            weekDayStudy[weekday].studyTime = studyTime
            UserDefaults.standard.setCodable(weekDayStudy, forKey: "weekDay")
        }
    }
    func getWeekDayStudy() -> [weekStruct]{
        
        if let data:[weekStruct] = userDefaults.codable(forKey: "weekDay"){
            
            print(data)
            weekDayStudy = data
            return weekDayStudy
        }
        return weekDayStudy
    }
    
    func deleteWeekDayStudyTime(weekday:Int,studyTime:Double){
        if let data:[weekStruct] = userDefaults.codable(forKey: "weekDay"){
            weekDayStudy = data
            guard weekDayStudy[weekday].studyTime - studyTime >= 0  else { return }
            print("消します")
            weekDayStudy[weekday].studyTime -= studyTime
            UserDefaults.standard.setCodable(weekDayStudy, forKey: "weekDay")
        }
    }
    
    
//--------------------------------------------------------------------------------
    func getMonthlyStudyTime() -> Monthly{
        if let data:Monthly = userDefaults.codable(forKey: "monthly"){
            return data
        }
        else{
            return Monthly(year: Date() ,month: [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,])
        }
    }
    func saveMonthlyStudyTime(studytime:Double,month:Int){
        var monthlyData = getMonthlyStudyTime()
        
        monthlyData.month[month - 1] =  monthlyData.month[month - 1] + studytime
        print("保存しました",month,studytime,monthlyData.month[month - 1])
        userDefaults.setCodable(monthlyData, forKey: "monthly")
    }
  
    func deleteMonthlyStudyTime(studytime:Double,month:Int){
        var a = getMonthlyStudyTime()
        
        a.month[month - 1] -= studytime
        userDefaults.setCodable(a, forKey: "monthly")
        
    }
//--------------------------------------------------------------------------------

    func deleteMonthlyTotalStudyTime(studytime:Double,month:Int) {
        var a = getMonthlyTotalStudyTime()
        a[month - 1] -= studytime
        userDefaults.setValue(a, forKey: "totalMonthly")
    }
    func getMonthlyTotalStudyTime() -> [Double]{
        if let a = userDefaults.array(forKey: "totalMonthly"){
            return  a as! [Double]
        }
        return [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,]
    }
    func saveMonthlyTotalStudyTime(studytime:Double,month:Int){
        var a  = getMonthlyTotalStudyTime()
        a[month - 1] += studytime
        userDefaults.setValue(a, forKey: "totalMonthly")
      
        
    }
    //円グラフの目標勉強時間
    func seveGoalTime(time:Int){
        userDefaults.setValue(time, forKey: "goalTime")
    }
    func getGoalTime() -> Int {
        if  let goalTime = UserDefaults.standard.object(forKey:"goalTime"){
            return goalTime as! Int
        }
        return 10000
    }
    func saveWeekStudy(){
        UserDefaults.standard.setCodable(week, forKey: "week")
    }
    
    func getWeekStudy(){
        if  let a: [weekStruct]? = UserDefaults.standard.codable(forKey:"week"){
            week = a!
        }
    }
    func getWeekDayInt() -> Int{
        let date = Date()
        
        let calendar = Calendar.current
        //取得する要素を選択する　日と曜日を選択している
        let component = (calendar as NSCalendar).components([ NSCalendar.Unit.weekday], from: date)
        
        let weekDayInt = component.weekday!
        
        return weekDayInt
    }
    
    func getGoal() -> String{
        if let goal = userDefaults.object(forKey: "goal"){
            return goal as! String
        }
        else{
            return "goal"
        }
        
    }
    
    func getUserName() -> String{
        var username = String()
        if let name = userDefaults.object(forKey: "username"){
            username = name as! String
        }
        else{
            username = "No Name"
        }
        return username
    }
    func getProfileImage() -> String{
        var image = String()
        if let profileImage = userDefaults.object(forKey: "image"){
            image = profileImage as! String
        }
        else{
            image = "かえる"
        }
        return image
    }
    func saveProfile(username:String,goal:String,image:String){
        userDefaults.setValue(username, forKey: "username")
        userDefaults.setValue(goal, forKey: "goal")
        userDefaults.setValue(image, forKey: "image")
        
        database.postGoal(goal: goal, username: username, image: image)
        
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
    func deleteWeekData(){
        userDefaults.removeObject(forKey: "week")
    }
    func deleteDayData(){
        userDefaults.removeObject(forKey: "day")
    }
    func deleteMonthData(){
        userDefaults.removeObject(forKey: "month")
    }
    func deleteTotalData(){
        userDefaults.removeObject(forKey: "total")
    }
    
    func getBlockUser() -> [blockUser]{
        if let a :[blockUser] = userDefaults.codable(forKey: "blockuser")  {
            return a
        }
        return [blockUser]()
    }
    
    func getHowManyDays(date:Date) -> Int{
        let currentDate = Date()
        var elapsedDays = Calendar.current.dateComponents([.day], from:date , to: currentDate).day!
        print(elapsedDays,"日経過しています")
        if elapsedDays == 0{
            elapsedDays = 1
        }
        return elapsedDays
    }
}




