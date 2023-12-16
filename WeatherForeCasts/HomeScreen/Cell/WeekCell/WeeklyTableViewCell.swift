//
//  WeeklyTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {
    @IBOutlet weak var weeklyCollectionView: UICollectionView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var extenLb: UILabel!
    var weeks : [Forecastday] = []
    var goToForecast14Days: (() -> Void)?
//    let qw = WeeklyTableViewCell.frame.width
    

    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        setupCollectionView()
        titleLb.text = NSLocalizedString(titleLb.text ?? "", comment: "")
        extenLb.text = NSLocalizedString(extenLb.text ?? "", comment: "")
        print("cell bounds width: \(bounds.width)")
//        print("weeklyCollectionView: \(weeklyCollectionView.frame.width)")
    }
    func getWeeklyDatas(with forecastWeek: [Forecastday] ) {
        self.weeks = forecastWeek
        weeklyCollectionView.reloadData()
    }
    private func setupCollectionView() {
        if let flowLayout = weeklyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
    }
    private func registerCell() {
        weeklyCollectionView.register(UINib(nibName: "WeeklyWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WeeklyWeatherCollectionViewCell.identifier)
        weeklyCollectionView.dataSource = self
        weeklyCollectionView.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func goToForCast14Days(_ sender: Any) {
        goToForecast14Days?()
    }
}
extension WeeklyTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCollectionViewCell.identifier, for: indexPath) as! WeeklyWeatherCollectionViewCell
        let week = weeks[indexPath.item]
        cell.getWeeklyDatas(with: week)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToForecast14Days?()
        print("Số thứ tự của row được click: \(indexPath.row)")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = bounds.width
        if screenWidth >= 700 {
            return CGSize(width: ((bounds.width)/2)-10, height: 65)
        } else {
            return CGSize(width: bounds.width, height: 65)
        }
    }
}
