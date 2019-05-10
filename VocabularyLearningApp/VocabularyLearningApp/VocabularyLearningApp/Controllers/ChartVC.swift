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

class ChartVC: UIViewController, ChartViewDelegate, ChartResponseDelegate
{
    @IBOutlet weak var chartView: BarChartView!
    let chartModel = UserChartModel()
    
//    Grafik verileri
    var dataLabels = [""]
    var dataValues: [BarChartDataEntry] = []
    let dayCount: Int = Date().getMonthDays()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        chartModel.delegate = self
        chartView.delegate = self
        
        prepareChart()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        dateIntervalSelector()
    }
    
    func dateIntervalSelector() // Zaman aralığı seçim menüsü
    {
        let selector = UIAlertController(title: NSLocalizedString("SELECT_MENU", comment: ""), message: NSLocalizedString("SELECT_MENU_DESC", comment: ""), preferredStyle: .actionSheet)
        let dayButton = UIAlertAction(title: NSLocalizedString("SELECT_DAY", comment: ""), style: .default) { (_) in
            self.chartModel.fetchChart(timeInterval: DateInterval.day.rawValue, timeValue: 1)
        }
        let weekButton = UIAlertAction(title: NSLocalizedString("SELECT_WEEK", comment: ""), style: .default) { (_) in
            self.chartModel.fetchChart(timeInterval: DateInterval.day.rawValue, timeValue: 7)
        }
        let monthBuuton = UIAlertAction(title: NSLocalizedString("SELECT_MONTH", comment: ""), style: .default) { (_) in
            self.chartModel.fetchChart(timeInterval: DateInterval.month.rawValue, timeValue: 1)
        }
        let sixMonthBuuton = UIAlertAction(title: NSLocalizedString("SELECT_SIX_MONTH", comment: ""), style: .default) { (_) in
            self.chartModel.fetchChart(timeInterval: DateInterval.month.rawValue, timeValue: 6)
        }
        let yearBuuton = UIAlertAction(title: NSLocalizedString("SELECT_YEAR", comment: ""), style: .default) { (_) in
            self.chartModel.fetchChart(timeInterval: DateInterval.year.rawValue, timeValue: 1)
        }
        let cancelBuuton = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil)
        selector.addAction(dayButton)
        selector.addAction(weekButton)
        selector.addAction(monthBuuton)
        selector.addAction(sixMonthBuuton)
        selector.addAction(yearBuuton)
        selector.addAction(cancelBuuton)
        self.present(selector, animated: true, completion: nil)
    }
    
    func prepareChart() // Grafik sayfası ayarları
    {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .lightGray
        xAxis.granularity = 1
        xAxis.drawAxisLineEnabled = false
        xAxis.valueFormatter = self

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false

        chartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: -10)
        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        chartView.noDataText = NSLocalizedString("NO_CHART_DATA", comment: "")
    }
    
    func loadedChart(date: [String], values: [Int]) // Grafik veriler çekildiği zaman burası haberdar edilir ve veriler yerleştirilir.
    {
        dataLabels.removeAll()
        dataValues.removeAll()
        dataLabels = date

        for i in 0..<values.count
        {
            dataValues.append(BarChartDataEntry(x: Double(i), y: Double(values[i])))
        }
        setChartData()
    }

    func setChartData() // Grafik verileri yerleştirilip grafik yenilenir.
    {
        chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        let set = BarChartDataSet(entries: dataValues, label: "")
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 13))
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        chartView.data = data
    }
    @IBAction func dateIntervalButton(_ sender: Any)
    {
        dateIntervalSelector()
    }
}
extension ChartVC: IAxisValueFormatter
{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}
