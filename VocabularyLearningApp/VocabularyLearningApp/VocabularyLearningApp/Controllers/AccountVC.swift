//
//  AccountVC.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 4.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import Charts
import VocabularyLearningAppAPI

class AccountVC: UIViewController, ChartViewDelegate
{

    @IBOutlet weak var chartView: BarChartView!
    let firebaseChart: FetchLearnChartsProtocol = FetchLearnCharts()
    
    var dataLabels = [""]
    var yVals: [BarChartDataEntry] = []
    let dayCount: Int = Date().getMonthDays()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

        yVals.removeAll()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .short
        
        firebaseChart.learnCharts(userID: "String") { result in
            switch result {
            case .success(let value):
                self.yVals.removeAll()
                for i in 0..<value.date.count
                {
                    self.yVals.append(BarChartDataEntry(x: Double(i), y: Double(value.correctArray[i])))
                }
                self.setChartData()
            case .failure:
                print("HATA")
            }
        }
        chartView.delegate = self
        chartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: -10)
        
//        chartView.rightAxis.enabled = false
//        chartView.leftAxis.enabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 15)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .lightGray
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = self

        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        setChartData()
    }

    func setChartData()
    {
        let red = UIColor(red: 211/255, green: 74/255, blue: 88/255, alpha: 1)
        let green = UIColor(red: 110/255, green: 190/255, blue: 102/255, alpha: 1)
        
        let colors = yVals.map { (entry) -> NSUIColor in
            return entry.y > 0 ? green : red
        }
        
        let set = BarChartDataSet(entries: yVals, label: "")
        set.colors = colors
        set.valueColors = colors

        let data = BarChartData(dataSet: set)
    
        data.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        chartView.data = data
    }
}
extension AccountVC: IAxisValueFormatter
{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}
