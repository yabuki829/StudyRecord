//
//  PieChartViewDetailController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/31.
//

import UIKit
import Charts

class PieChartViewDetailController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var textFieldView: UIView!
    
    var totalStudyTime = 0.0
    var goalTime = 10000
    let studyTime = studyTimeClass()
    var isOn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.transform = CGAffineTransform(translationX: 0, y: -40)
        textField.delegate = self
        goalTime = studyTime.getGoalTime()
        textField.text = String(goalTime)
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

    
    @IBAction func setGoalTime(_ sender: Any) {
        if textField.text?.isEmpty == false{
            textField.resignFirstResponder()
            goalTime = Int(textField.text ?? "10000") ?? 10000
            studyTime.seveGoalTime(time: goalTime)
            setupPieChart()
        }
      
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func openMenu(_ sender: Any) {
        isOn = !isOn
        
        if isOn{
//            textFieldView.isHidden = false
             print("open")
            
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: .beginFromCurrentState,
                animations: { () -> Void in
                    self.textFieldView.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
//            textFieldView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        else{
//            textFieldView.isHidden = true
            print("not open")
          
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: .beginFromCurrentState,
                animations: { () -> Void in
                    self.textFieldView.transform = CGAffineTransform(translationX: 0, y: -40)
                }, completion: nil)
            
        }
    }
    
}
