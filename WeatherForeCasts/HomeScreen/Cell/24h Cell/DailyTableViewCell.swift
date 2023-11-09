//
//  DailyTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit

class DailyTableViewCell: UITableViewCell{
    
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    var hours: [Hour] = []
    //    var getData24h: ((WeatherData24h) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
//        setupCollectionView()
    }
    func getData24h(with forecastDay: Forecastday) {
        hours = forecastDay.hour
        // Reload collectionView khi cập nhật dữ liệu
        dailyCollectionView.reloadData()
    }
    private func setupCollectionView() {
        if let flowLayout = dailyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
//            flowLayout.itemSize.height = 220
//            flowLayout.itemSize.width = 60
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
    }

    private func registerCell() {
        dailyCollectionView.register(UINib(nibName: "DailyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        dailyCollectionView.dataSource = self
        dailyCollectionView.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
}
