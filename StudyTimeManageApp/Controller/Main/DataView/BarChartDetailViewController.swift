//
//  BarChartViewDetailController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/31.
//

import UIKit
import Charts
import FirebaseFirestore

class BarChartDetailViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    let date = DateModel()
    let studyTime = studyTimeClass()
    let languageClass = LanguageClass()
    var rawData:[Double] = [0,0,0,0,0,0,0]
    var aDay = String()
    var zDay = String()
    var weekDataArray = [studyWeekData]()
    var path = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
        backButton.isHidden = true
        setNavBarBackgroundColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
         
            
            if path == 0{
                nextButton.isHidden = false
            }
            else if path == weekDataArray.count{
                backButton.isHidden = false
            }
            else{
                nextButton.isHidden = false
                backButton.isHidden = false
            }
            animationType(type: 0)
          
        }
    }

//    左
    @IBAction func back(_ sender: Any) {
        //一週間前のデータを表示する
       
        path += 1
        print("path",path,weekDataArray.count - 1)
        animationType(type: 1)
        setData()


        if path >= 0 {
            print("nextbuttonを見えるようにします")
            nextButton.isHidden = false
            if path == weekDataArray.count - 1{
                backButton.isHidden = true
               
            }
        }
        
      
        
    }
    
    @IBAction func front(_ sender: Any) {
        //一週間後のデータを表示する
        path -= 1
        animationType(type: 2)
        setData()
        if path < weekDataArray.count - 1 {
            backButton.isHidden = false
            if path == 0 {
                nextButton.isHidden = true
            }
        }
       
       
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
    func convertDateToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
            
        dateFormatter.timeStyle = .none
        
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        // 変換
        let str = dateFormatter.string(from: date)
        // 結果表示
        return str
    }
    func animationType(type:Int){
        switch type {
            case 0:
                BarChartView.transition(with: barChartView, duration: 0.8, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            case 1:
                BarChartView.transition(with: barChartView, duration: 0.8, options: [.transitionFlipFromRight], animations: nil, completion: nil)
            case 2:
                BarChartView.transition(with: barChartView, duration: 0.8, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
            default: break
        }
    }
    func setData(){
        aDay = convertDateToString(date: weekDataArray[path].start)
        zDay = convertDateToString(date: weekDataArray[path].last)
        dateLabel.text = "\(aDay) ~ \(zDay)"
        rawData = weekDataArray[path].week
        setUpBarCharts()
    }

    func setUpBarCharts(){
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset) + 1, y: Double($0.element)) }
        
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.colors = [.systemBlue]
//        dataSet.barBorderWidth = 10
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        barChartView.leftAxis.axisMinimum = 0 //y左軸最小値
        barChartView.leftAxis.zeroLineColor = .systemGray
        //アニメーション
        barChartView.animate(yAxisDuration: 1.5)
        // ラベルの数を設定
        barChartView.leftAxis.labelCount = 5
        // ラベルの色を設定
        barChartView.leftAxis.labelTextColor = .black
        // グリッドの色を設定
        barChartView.leftAxis.gridColor = .systemGray
        // 軸線は非表示にする
        barChartView.leftAxis.drawAxisLineEnabled = false
        //グラフの凡例が表示されているので非表示
        barChartView.legend.enabled = false
//        barChartView.isUserInteractionEnabled = false
        //軸のグリッド線を消す
        barChartView.xAxis.drawGridLinesEnabled = false
//
        barChartView.rightAxis.enabled = false

        // 凡例を非表示にする
        barChartView.legend.enabled = false

        // ズームできないようにする
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        //X軸　曜日の表示 youbi
        barChartView.xAxis.labelCount = 7
        barChartView.xAxis.labelPosition = .bottom
        let formatter = ChartWeekFormatter()
        barChartView.xAxis.valueFormatter = formatter
        
        dataSet.valueFont = .systemFont(ofSize: 10)
        
        dataSet.valueFormatter = ValueFormatter(of: rawData)
        // y軸を整数表示にする
//        barChartView.rightAxis.granularityEnabled = true
        barChartView.leftAxis.granularityEnabled = true
//        barChartView.rightAxis.granularity = 1.0
        barChartView.leftAxis.granularity = 1.0
    }

}



struct studyWeekData {
    var week:[Double]
    var last:Date
    var start:Date
}

