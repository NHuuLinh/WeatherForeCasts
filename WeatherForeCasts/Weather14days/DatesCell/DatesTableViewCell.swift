//
//  DatesTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import UIKit

class DatesTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var datesForecastCollectionView: UICollectionView!
    private var dates1 = [String]()
    private var dates : [Forecastday] = []
    private var onClickDate : ((Int) -> Void)?
    private var selectedDateIndex: Int?
    private var selectedIndexPath: IndexPath? // Thêm biến này để theo dõi ô được chọn
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    private func setupCollectionView() {
        if let flowLayout = datesForecastCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize.height = 50
            flowLayout.itemSize.width = 50
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
        datesForecastCollectionView.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: "DatesCollectionViewCell", bundle: nil)
        datesForecastCollectionView.register(nib, forCellWithReuseIdentifier: "DatesCollectionViewCell")
        datesForecastCollectionView.dataSource = self
        datesForecastCollectionView.delegate = self
    }

    func bindData(dates: [Forecastday], selectedDateIndex: Int?, onClickDate: ((Int) -> Void)?) {
        self.dates = dates
        self.selectedDateIndex = selectedDateIndex
        self.onClickDate = onClickDate
        self.datesForecastCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatesCollectionViewCell", for: indexPath) as! DatesCollectionViewCell
        let date = dates[indexPath.item]
        let isSelected = indexPath.row == selectedDateIndex ?? 0
        cell.bindData(date: date, isSelected: isSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onClickDate?(indexPath.row)
        collectionView.reloadData()
    }
}
