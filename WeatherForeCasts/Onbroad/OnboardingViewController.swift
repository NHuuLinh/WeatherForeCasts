//
//  OnboardingViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 22/10/2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionViewOnbroad: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        slides = [
            OnboardingSlide(title: "Dự báo chi tiết 24h",description: "Cập nhật thông tin thời tiết mới nhất.",image: #imageLiteral(resourceName: "Onbroad1") ),
            OnboardingSlide(title: "Thời tiết toàn cầu",description: "Thêm bất kỳ vị trí nào bạn muốn và vuốt dễ dàng để thay đổi.",image: #imageLiteral(resourceName: "Onbroad2")),
            OnboardingSlide(title: "Dự báo vị trí khác nhau",description: "Dễ dàng nắm bắt thời tiết các địa diểm mong muốn.",image: #imageLiteral(resourceName: "Onbroad3"))
        ]
        pageControl.numberOfPages = slides.count
    }
    @IBAction func nextBtnHandle(_ sender: UIButton) {
//        moveToNextPage()
        if currentPage == slides.count - 1 {
            gotoLoginVC()
            
        } else {
            UserDefaults.standard.hasOnboarded = true
            currentPage += 1
                        collectionViewOnbroad.isPagingEnabled = false
                        collectionViewOnbroad.scrollToItem(
                            at: IndexPath(item: currentPage, section: 0),
                            at: .centeredHorizontally,
                            animated: true
                        )
                        collectionViewOnbroad.isPagingEnabled = true
        }
    }
    func moveToNextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionViewOnbroad.scrollToItem(at: indexPath, at: .left, animated: true)
            collectionViewOnbroad.reloadData()
            collectionViewOnbroad.isPagingEnabled = false
            collectionViewOnbroad.scrollToItem(
                at: IndexPath(item: currentPage, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            collectionViewOnbroad.isPagingEnabled = true
        }
    }
    func gotoLoginVC() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            
            let loginNavigation = UINavigationController(rootViewController: loginVC)
            
            uwWindow.rootViewController = loginNavigation// Đưa cho windown 1 viewcontroller
            /// Make visible keywindown
            uwWindow.makeKeyAndVisible()
        } else {
            print("LỖI")
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
