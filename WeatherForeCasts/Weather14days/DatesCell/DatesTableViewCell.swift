//
//  DatesTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import UIKit

class DatesTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var datesForecastCollectionView: UICollectionView!
    private var dates = [String]()
    private var onClickDate : ((IndexPath) -> Void)?
//    private var selectedIndexPath: IndexPath? // Thêm biến này để theo dõi ô được chọn
    

    override func awakeFromNib() {
        super.awakeFromNib()
         setupCollectionView()
    }
    private func setupCollectionView(){
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
//    Truyền data và closure call từ WeatherLongDayViewController xuống đây
//    */
    func bindData(date: String) {
        self.dates = [date]
        self.datesForecastCollectionView.reloadData()
    }
    func setOnClickDateHandler(_ onClickDate: ((IndexPath) -> Void)?) {
        self.onClickDate = onClickDate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatesCollectionViewCell", for: indexPath) as! DatesCollectionViewCell
        let date = dates[indexPath.row]
        cell.bindData(date: date)
        return cell
    }

    /// Khi user chọn vào 1 category thì call closure để truyền action về HomeViewController để call lại API
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
//        self.onClickDate?(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! DatesCollectionViewCell
            cell.dateBackGroundColors.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.14, alpha: 1.00)
        cell.dateLb.textColor = UIColor.white
//        self.datesForecastCollectionView.reloadData()
        print("1")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DatesCollectionViewCell
        cell.dateBackGroundColors.backgroundColor = UIColor.white // màu mặc định
        cell.dateLb.textColor = UIColor.black
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
}
