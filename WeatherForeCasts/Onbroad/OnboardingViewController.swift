import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionViewOnbroad: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    
    var slides: [OnboardingSlide] = []

    let nextTitle = NSLocalizedString("Next", comment: "")
    let title1 = NSLocalizedString("Detailed 24-hour forecast", comment: "")
    let title2 = NSLocalizedString("Global Weather", comment: "")
    let title3 = NSLocalizedString("Various location forecasts", comment: "")
    let description1 = NSLocalizedString("Update with the latest weather information.", comment: "")
    let description2 = NSLocalizedString("Add any position you want and easy to change.", comment: "")
    let description3 = NSLocalizedString("Easily grasp the weather of desired locations.", comment: "")
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle(NSLocalizedString("Get Started", comment: ""), for: .normal)
            } else {
                nextBtn.setTitle(nextTitle, for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        slideData()
        
    }
    func slideData(){
        slides = [
            OnboardingSlide(title: title1,
                            description: description1,
                            image: "Onbroad1" ),
            OnboardingSlide(title: title2,
                            description: description2,
                            image: "Onbroad2"),
            OnboardingSlide(title: title3,
                            description: description3,
                            image: "Onbroad3")
            ]
        pageControl.numberOfPages = slides.count
    }
    func registerCell(){
        let cell = UINib(nibName: "OnboardingCollectionViewCell", bundle: nil)
        collectionViewOnbroad.register(cell, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionViewOnbroad.dataSource = self
        collectionViewOnbroad.delegate = self
    }
    @IBAction func nextBtnHandle(_ sender: UIButton) {
        moveToNextPage()
    }
    func moveToNextPage() {
        if currentPage == slides.count - 1 {
            AppDelegate.scene?.goToLogin()
            UserDefaults.standard.hasOnboarded = true
        } else {
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
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(with: slides[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Không có khoảng cách giữa các dòng
    }
    // cài đặt chiều rông khi scroll
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }

}
