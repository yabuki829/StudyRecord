//
//  Extension.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/03.
//

import Foundation
import UIKit

extension Encodable {

    var json: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

extension Decodable {

    static func decode(json data: Data?) -> Self? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Self.self, from: data)
    }
}

extension UserDefaults {

    /// - Warning:
    // setCodable ではなく set という関数名にすると、String をセットしたいときに Codable と衝突して Codable 扱いとなってしまうため注意。
    func setCodable(_ value: Codable?, forKey key: String) {
        guard let json: Any = value?.json else { return } // 2020.02.23 追記参照
        self.set(json, forKey: key)
        synchronize()
    }

    func codable<T: Codable>(forKey key: String) -> T? {
        let data = self.data(forKey: key)
        let object = T.decode(json: data)
        return object
    }
}

extension Date {
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
            calendar.isDate(self, equalTo: date, toGranularity: component)
        }

    func isInSameYear(as date: Date) -> Bool{
        isEqual(to: date, toGranularity: .year)
    }
    func isInSameMonth(as date: Date) -> Bool {
        isEqual(to: date, toGranularity: .month)
    }

    func isSameDay(as date: Date) -> Bool {
           Calendar.current.isDate(self, inSameDayAs: date)
    }
    
}
extension Calendar {

    //MARK: - Week operations

    func startOfWeek(for date:Date) -> Date {
        let comps = self.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        return self.date(from: comps)!
    }
}


extension Date {
    
    func secondAgo(createdAt:Date) -> String  {
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute, .second], from: createdAt, to: Date())
        let languageClass = LanguageClass()
        let local = languageClass.getlocation()
        func dateText1() -> String {
           
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            // カレンダー設定（グレゴリオ暦固定）
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            // 変換
            let str = dateFormatter.string(from: createdAt)
              
              return str
          }
        func dateText2() -> String {
           
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            // カレンダー設定（グレゴリオ暦固定）
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            // 変換
            let str = dateFormatter.string(from: createdAt)
              
              return str
          }
        
        if let year = components.year, year > 0 {
            return dateText1()
        }
        if let month = components.month, month > 0 {
            return dateText2()
        }
       
        if let day = components.day, day > 0 {
            if local == "ja"{
                return "\(day)日前"
            }
            else{
                if day == 1{
                    return "\(day) day ago"
                }
                
                return "\(day)days ago"
            }
        }
        if let hour = components.hour,hour > 0 {
          
            if local == "ja"{
                return "\(hour)時間前"
            }
            else{
                if hour == 1{
                    return "\(hour) hour ago"
                }
                
                return "\(hour)hours ago"
            }
           
        }
        if let minute = components.minute, minute > 0 {
          
            if local == "ja"{
                return "\(minute)分前"
            }
            else{
                if minute == 1{
                    return "\(minute) minute ago"
                }
                
                return "\(minute) minutes ago"
            }
           
        }
        if let second = components.second, second > 0 {
//            return " \(second) seconds ago"
          
            if local == "ja"{
                return "\(second)秒前"
            }
            else{
                if second == 1{
                    return "\(second) second ago"
                }
                
                return "\(second) seconds ago"
            }
           
        }
//        return Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
//        return "right now"
        if local == "ja"{
            return "たった今"
        }
        return "right now"
    }
}



extension UIViewController {
    private final class StatusBarView: UIView { }

    func setStatusBarBackgroundColor(_ color: UIColor?) {
        for subView in self.view.subviews where subView is StatusBarView {
            subView.removeFromSuperview()
        }
        guard let color = color else {
            return
        }
        let statusBarView = StatusBarView()
        statusBarView.backgroundColor = color
        self.view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}



extension UITextField {
    func setUnderLine(color:UIColor) {
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        // 枠線の色
        underline.backgroundColor = color
        addSubview(underline)
        bringSubviewToFront(underline)
    }
}

extension UITextView {
    func setTopLine(color:UIColor) {
       
        let topline = UIView()
        // heightにはアンダーラインの高さを入れる
        topline.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0.5)
        // 枠線の色
        topline.backgroundColor = color
        addSubview(topline)
        bringSubviewToFront(topline)
    }
}


