//
//  PieChartViewDetailController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/31.
//

import UIKit
import Charts

class PieChartViewDetailController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    var totalStudyTime = 0.0
    let goalTime = 10000
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPieChart()
    }
    func setupPieChart(){
        setStatusBarBackgroundColor(.link)
        pieChartView.highlightPerTapEnabled = true
        pieChartView.chartDescription?.enabled = true
        pieChartView.drawEntryLabelsEnabled = true
        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = true
        pieChartView.isUserInteractionEnabled = true

        //value1 -> 今までの勉強時間
        //value2 -> 残りの勉強時間
        let value1 = PieChartDataEntry(value: 0)
        let value2 = PieChartDataEntry(value: 0)
        
        var number = [PieChartDataEntry]()
        value1.value = round(totalStudyTime)
        
        if totalStudyTime >= 10000{
            pieChartView.centerText = "Expert"
            number = [value1,value2]
            self.navigationItem.title = "Expert"
        
        }
        else{
            value2.value = Double(goalTime) - value1.value
            pieChartView.centerText = "残り\(goalTime - Int(totalStudyTime))時間"
            value1.label = "\(value1.value)時間"
            value2.label = "残り\(value2.value)時間"
            number = [value1,value2]
        }
        let chartDataSets = PieChartDataSet(entries: number,label: "aaaaaaaa")
        let chartData = PieChartData(dataSet: chartDataSets)
        
        chartDataSets.setColors(UIColor.link, UIColor.systemGray3)
        chartDataSets.valueTextColor = UIColor.darkGray
        chartDataSets.entryLabelColor = .black
       
        pieChartView.data = chartData
        pieChartView.holeColor = .systemGray6
        chartDataSets.selectionShift = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        pieChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.usePercentValuesEnabled = true
    }
    

}
