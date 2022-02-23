//
//  BarChartCell.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/04.
//

import UIKit
import Charts
class BarChartCell: UITableViewCell {

    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var title: UILabel!
    var rawData:[Double] = [0,0,0,0,0,0,0]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    func setCell(titleString:String,data:[Double]){
        rawData = data
        setUpBarCharts()
        title.text = titleString
        
    }
    func setMonthCell(titleString:String,data:[Double]){
        rawData = data
        setUpMonthBarChart()
        title.text = titleString
    }
    func setUpBarCharts(){
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.colors = [.systemBlue]
//        dataSet.barBorderWidth = 10
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        barChartView.leftAxis.axisMinimum = 0.0 //y左軸最小値
        barChartView.leftAxis.zeroLineColor = .systemGray
        //アニメーション
        barChartView.animate(yAxisDuration: 1.5)
        // ラベルの数を設定
        barChartView.leftAxis.labelCount = 10
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
//        let formatter = ChartWeekFormatter()
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:["月","火","水","木","金","土","日"])
        
        dataSet.valueFont = .systemFont(ofSize: 10)
        
        dataSet.valueFormatter = ValueFormatter(of: rawData)
        
        
    }
    func setUpMonthBarChart(){
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.colors = [.systemBlue]
//        dataSet.barBorderWidth = 10
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        barChartView.leftAxis.axisMinimum = 0.0 //y左軸最小値
        barChartView.leftAxis.zeroLineColor = .systemGray
        //アニメーション
        barChartView.animate(yAxisDuration: 1.5)
        // ラベルの数を設定
        barChartView.leftAxis.labelCount = 12
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
        //選択できるようにする
        barChartView.highlightPerTapEnabled = true
        // ズームできないようにする
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        //X軸　曜日の表示 youbi
        barChartView.xAxis.labelCount = 12
        barChartView.xAxis.labelPosition = .bottom
//        let formatter = ChartMonthForMatter()
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"])
        
        dataSet.valueFont = .systemFont(ofSize: 10)
        
        dataSet.valueFormatter = ValueFormatter(of: rawData)
      
    }
}
