//
//  Date.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/07.
//

import Foundation



//日付が変わったかどうかを管理する

//Date型でやる方がいい？かも

class DateModel{
    let userDefalts = UserDefaults.standard
    var  result = [String]()
    weak var delegate: tableViewUpDater?
    
    func checkDate(now:Date,past:Date)  -> [String] {
            result = []
            let isSameDay   = judgeDay(now: now, past: past)
            let isSameMonth = judgeMonth(now: now, past: past)
            let isSameYear  = judgeYear(now: now, past: past)
            
            judgeWeek(now: now, past: past)
            print("チェックします")
            print(convertDateToString(date: now, format: "yyyy年MM月dd日"))
            print(convertDateToString(date: past, format: "yyyy年MM月dd日"))
            if isSameDay{
                return result
            }
            else{
                if isSameYear {
                    
                    if isSameMonth {
                       
                        return result
                        
                    }
                    else{
                        return result
                    }
                }
                else{
                    if isSameMonth {
                        //年が違う　月が同じ　-> 週が違う
                       
                        return result
                    }
                    else{
                        //年が違う　月が同じ　-> わからない
                        return result
                    }
                }
               
            }
    }
    func judgeDay(now:Date,past:Date) -> Bool{
        if past.isSameDay(as:now){
            
            print("日が同じ")
            result.append("日が同じ")
            return true
        }
        else{
            UserDefaults.standard.setValue(now, forKey: "lastTime")
            //同じ日でない
            print("1日の勉強時間を削除しました")
            result.append("日が違う")
            
            userDefalts.removeObject(forKey: "day")
            return false
        }
    }

    func judgeMonth(now:Date,past:Date) -> Bool{
        if past.isInSameMonth(as: now){
            //月が同じ
            result.append("月が同じ")
            return true
        }
        else{
            //月が違う
            print("1ヶ月の勉強時間を削除しました")
            result.append("月が違う")
            userDefalts.removeObject(forKey: "month")
            
            return false
        }
    }
    func judgeYear(now:Date,past:Date) -> Bool{
      
        if past.isInSameYear(as:  now){
            result.append("年が同じ")
            return true
        }
        else{
           
            result.append("年が違う")
            return false
        }
        
    }

    
    func judgeWeek(now:Date,past:Date){
        //Todo リファクタリングする
       
       
        //nowとpastの時間を合わせてる
        //now:  2月11日20時10分 -> 2月11日00時00分
        //past: 2月10日22時30分 -> 2月10日00時00分
        let a = convertStringToDate2(dateString: convertDateToString(date:now, format: "yyyy年MM月dd日"))
        let b = convertStringToDate2(dateString: convertDateToString(date: past, format: "yyyy年MM月dd日"))
        
        //最後の月曜日から何日離れているか取得する
        let nowMonDistance = getWeekDay(date: a)
        let pastMonDistance = getWeekDay(date:b)
        print("Now: ",nowMonDistance,"日離れている")
        print("Past: ",pastMonDistance,"日離れている")
        
        //何周目の月曜日か
        //現在のdateと過去のdateに月曜日までの距離を引いて　曜日を月曜日に合わせる
        
        let modifiedNowDate = Calendar.current.date(byAdding: .day, value:  -nowMonDistance, to: a)!
        let modifiedPastDate = Calendar.current.date(byAdding: .day, value: -pastMonDistance, to: b)!
        print("Now: ",modifiedNowDate,convertDateToString(date: modifiedNowDate, format: "yyyy年MM月dd日HH時mm分"))
        print("Past: ",modifiedPastDate,convertDateToString(date: modifiedPastDate, format: "yyyy年MM月dd日HH時mm分"))
        
        
        //7日以上離れていたら週が変わっている
        let dayInterval = (Calendar.current.dateComponents([.day], from: modifiedPastDate ,to: modifiedNowDate)).day
        
        if dayInterval! >= 7 || dayInterval! <= -7{
            print("1週間の勉強時間を削除しました")
            result.append("週が違う")
            studyTimeClass().deleteWeekData()
            delegate?.updateTableView()
        }
        else{
            print("週が同じ")
            result.append("週が同じ")
            delegate?.updateTableView()
        }
    }
    
    func convertDateToString(date:Date,format:String) -> String{
//        yyyy年MM月dd日
//        yyyy年MM月dd日HH時mm分
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = .current
        let str = dateFormatter.string(from: date)
        return str
    }
  
    //投稿の時間表示に使用している & テスト用
    func convertStringToDate1(dateString:String) -> Date{
        
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        return formatter.date(from: dateString)!
    }
    
    
    func convertStringToDate2(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy年MM月dd日"
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = .current

        let date = dateFormatter.date(from: dateString)
        return date!
    }
    func getWeekDay(date:Date) -> Int{
        let calendar = Calendar.current
        let component = (calendar as NSCalendar).components([   NSCalendar.Unit.weekday], from: date)
        return convert(weekInt: component.weekday!)
    }
    
    func convert(weekInt:Int) -> Int{
//        月曜日までの距離を返す
        switch weekInt {
        case 1:
            return 6 //日
        case 2:
            return 0 //月
        case 3:
            return 1 //火
        case 4:
            return 2 //水
        case 5:
            return 3 //木
        case 6:
            return 4 //金
        case 7:
            return 5 //土
        case 8:
            return 6 //日
        default:
            print("エラー")
            return 0
        }
    }
}


