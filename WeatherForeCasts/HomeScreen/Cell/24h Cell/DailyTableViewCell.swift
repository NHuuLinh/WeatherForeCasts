//
//  DailyTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit
import Charts

class DailyTableViewCell: UITableViewCell{
    
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLb: UILabel!
    
    var hours = [Hour]()
    var goTodailyForecastVC: (() -> Void)?
    let lineChartView = LineChartView()
    var dataEntries: [ChartDataEntry] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        scrollView.delegate = self
        dailyCollectionView.delegate = self
        titleLb.text = NSLocalizedString("Forecast 24h", comment: "")
    }
    
    func getData24h(from currentTime: String?, with forecastHours: [Hour]) {
        chartView.subviews.forEach { $0.removeFromSuperview() }
        dataEntries.removeAll()
//        chartView.subviews.forEach({ $0.removeFromSuperview() })
        // Chuyển đổi thời gian hiện tại thành giờ
        let currentHour = DateConvert.convertDate(date: currentTime ?? "0", inputFormat: "yyyy-MM-dd HH:ss", outputFormat: "HH")
        let startHour = Int(currentHour) ?? 0
        // Kiểm tra xem có đủ dữ liệu cho 24 giờ tiếp theo không
        guard startHour + 24 <= forecastHours.count else {
            print("Not enough data for 24 hours forecast.")
            return
        }
        // Lấy dữ liệu dự báo cho 24 giờ kể từ thời điểm hiện tại
        hours = Array(forecastHours[startHour..<startHour+24])

        for i in 0..<hours.count {
                let xValue = 60 * Double(i)
                let dataEntry = ChartDataEntry(x: xValue, y: hours[i].tempC)
                dataEntries.append(dataEntry)
            }
        var lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Temperature")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.valueColors = [UIColor.clear]
        lineChartDataSet.setColor(.white)
//        lineChartDataSet.valueFont = UIFont.systemFont(ofSize: 14)
        lineChartDataSet.drawValuesEnabled = false
        lineChartView.data = lineChartData
        lineChartView.backgroundColor = UIColor.clear
        lineChartView.gridBackgroundColor = UIColor.clear
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.frame = CGRect(x: 20, y: 110, width: 1630, height: 50)
        chartView.addSubview(lineChartView)
        // Refresh the chart
        lineChartView.notifyDataSetChanged()
        dailyCollectionView.reloadData()
    }
    private func registerCell() {
        dailyCollectionView.register(UINib(nibName: "DailyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        dailyCollectionView.dataSource = self
        dailyCollectionView.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func goToDailyForecast(_ sender: Any) {
        goTodailyForecastVC?()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == dailyCollectionView {
            scrollView.contentOffset = dailyCollectionView.contentOffset
        } else if scrollView == scrollView {
            dailyCollectionView.contentOffset = scrollView.contentOffset
        }
    }
}
extension DailyTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCollectionViewCell", for: indexPath) as! DailyCollectionViewCell
        let hour = hours[indexPath.item]
        cell.getData24h(with: hour)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goTodailyForecastVC?()
        print("Số thứ tự của row được click: \(indexPath.row)")
    }
    
    private func setupCollectionView() {
        if let flowLayout = dailyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
    }
}
