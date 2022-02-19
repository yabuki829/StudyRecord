//
//  Formatter.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/11.
//

import Foundation
import Charts


class ChartWeekFormatter: NSObject, IAxisValueFormatter {
      func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let local = LanguageClass().getlocation()
        if local == "ja"{
            let weekArray = ["月","火","水","木","金","土","日"]
              let index = Int(value)
              return weekArray[index - 1]
        }
        else{
            let weekArray = ["Mon","Tue","Wed","Sat","Fri","Thu","Sun"]
              let index = Int(value)
              return weekArray[index - 1]
        }
      }

  }
class ChartMonthForMatter:IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let local = LanguageClass().getlocation()
        if local == "ja"{
            let monthArray = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
            let index = Int(value)
            return monthArray[index - 1]
        }
        else{
            let monthArray = ["Jan.","Feb.","Mar.","Apr.","May.","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."]
            let index = Int(value)
            return monthArray[index - 1]
        }
        
    }
    
    
}

class ValueFormatter: IValueFormatter {
        var items = [Double]()
    init(of rawData: [Double]) {
         items = rawData
    }
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let a = round(value * 10) / 10
        return String(a)
    }
}
class IntAxisValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(Int(value))
    }
}
