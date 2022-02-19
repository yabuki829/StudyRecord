//
//  File.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/01.
//


//userDefaltsに保存する内容はここに書いてる
// profile や　勉強時間など
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
    var weekDayStudy = [
        weekStruct(day: "Mon", studyTime: 0.0),
        weekStruct(day: "Tue", studyTime: 0.0),
        weekStruct(day: "Wed", studyTime: 0.0),
        weekStruct(day: "Sat", studyTime: 0.0),
        weekStruct(day: "Fri", studyTime: 0.0),
        weekStruct(day: "Thu", studyTime: 0.0),
        weekStruct(day: "Sun", studyTime: 0.0),
    ]
    
    func save(studyTime:Double,comment:String,category:String){
        //一日の勉強時間　 一ヶ月の勉強時間　今までの勉強時間
        print("saveします")
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
        print("ここだよ-------------------------")
    
        print(Date())
        let postDate = Clock.now  ?? Date()
        print(postDate)
        saveMonthlyStudyTime(studytime: month, month: getMonthDay(date: postDate))
        //今までの月毎の累計勉強時間
        saveMonthlyTotalStudyTime(studytime: studyTime, month: getMonthDay(date: postDate))
        //データベースに保存
        database.postData(today: studyTime + day, month: studyTime + month, total: studyTime + total)
        database.postRecord(todayStudyTime: studyTime, comment: comment, image:  getProfileImage(), category: category, postDate: postDate)
        database.saveMonthlyStudyTime(postDate: postDate)
        database.saveWeekStudyTime(postDate: postDate)
    }
    
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
    
    func getMonthlyStudyTime() -> Monthly{
        if let data:Monthly = userDefaults.codable(forKey: "monthly"){
            return data
        }
        
        return Monthly(year: Date() ,month: [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,])
    }
    func saveMonthlyStudyTime(studytime:Double,month:Int){
        var monthlyData = getMonthlyStudyTime()
        
        monthlyData.month[month - 1] = studytime
        userDefaults.setCodable(monthlyData, forKey: "monthly")
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

    
    //間違えて入力した勉強時間を削除する
    func deleteStudyTime(deleteTime:Double){
        //一日の勉強時間　 一ヶ月の勉強時間　今までの勉強時間
        let day = UserDefaults.standard.object(forKey: "day") as? Double ?? 0.0
        let month:Double = UserDefaults.standard.object(forKey: "month")  as? Double ?? 0.0
        let total:Double = UserDefaults.standard.object(forKey: "total")  as? Double ?? 0.0
        database.postData(today: day, month: month, total: total)
        if day - deleteTime >= 0.0{
        
            userDefaults.setValue(day - deleteTime, forKey: "day")
            userDefaults.setValue(month - deleteTime, forKey: "month")
            userDefaults.setValue(total - deleteTime, forKey: "total")
            print(getWeekDayInt())
            switch getWeekDayInt() {
            case 1:
                week[6].studyTime = day - deleteTime
            case 2:
                week[0].studyTime = day - deleteTime
            case 3:
                week[1].studyTime = day - deleteTime
            case 4:
                week[2].studyTime = day - deleteTime
            case 5:
                week[3].studyTime = day - deleteTime
            case 6:
                week[4].studyTime = day - deleteTime
            case 7:
                week[5].studyTime = day - deleteTime
            case 8:
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
}




