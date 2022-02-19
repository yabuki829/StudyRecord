//
//  PieChartCell.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/04.
//

import UIKit
import Charts

class PieChartCell: UITableViewCell {

    @IBOutlet weak var pieChart: PieChartView!
    weak var delegate: tableViewUpDater?
    var totalStudyTime = 0.0
    var goalTime = 10000
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(total:Double,time:Int){
        totalStudyTime = total
        goalTime = time
        setupPieChart()
    }
    
    func setupPieChart(){
      
        pieChart.highlightPerTapEnabled = true
        pieChart.chartDescription?.enabled = true
        pieChart.drawEntryLabelsEnabled = true
        pieChart.legend.enabled = false
        pieChart.rotationEnabled = true
        pieChart.isUserInteractionEnabled = true

        //value1 -> 今までの勉強時間
        //value2 -> 残りの勉強時間
        let value1 = PieChartDataEntry(value: 0)
        let value2 = PieChartDataEntry(value: 0)
        
        var number = [PieChartDataEntry]()
        value1.value = round(totalStudyTime)
       
        if totalStudyTime >= 10000{
            pieChart.centerText = "Expert"
            number = [value1,value2]
        }
        else{
            value2.value = Double(goalTime) - value1.value
            pieChart.centerText = String(goalTime - Int(totalStudyTime))
            value1.label = "\(value1.value)時間"
            value2.label = "残り\(value2.value)時間."
            number = [value1,value2]
        }
       
        let chartDataSets = PieChartDataSet(entries: number,label: nil)
        let chartData = PieChartData(dataSet: chartDataSets)
        chartDataSets.setColors(UIColor.link, UIColor.systemGray4)
        chartDataSets.valueTextColor = UIColor.darkGray
        chartDataSets.entryLabelColor = .black
        
        pieChart.data = chartData
        chartDataSets.selectionShift = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        pieChart.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChart.usePercentValuesEnabled = true
    }
}


