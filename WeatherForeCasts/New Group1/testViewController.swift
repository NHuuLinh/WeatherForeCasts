//
//  testViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 30/10/2023.
//

import UIKit

class testViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var testCollectionView: UICollectionView!
    private var selectedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCollectionViewCell", for: indexPath) as! testCollectionViewCell
//        cell.backgroundColor = UIColor(named: "red")
//        cell.blindData(text: "123", backgoundColors: "red")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! testCollectionViewCell
            cell.backGroundColors.backgroundColor = UIColor.black
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCollectionViewCell", for: indexPath) as! testCollectionViewCell
//        self.
//        self.selectedIndexPath = indexPath
//        self.
        print("1")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! testCollectionViewCell
        cell.backGroundColors.backgroundColor = UIColor.white // màu mặc định
    }
    func setupView(){
        testCollectionView.register(UINib(nibName: "testCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "testCollectionViewCell")
    }

}
