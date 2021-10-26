//
//  GuideViewController.swift
//  Knowing
//
//  Created by Jun on 2021/10/22.
//

import UIKit
import FSPagerView
import Then

class GuideViewController: UIViewController {
    
    let guideScrollView = UIScrollView().then {
        
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.alwaysBounceVertical = false
        $0.isScrollEnabled = true
        $0.bounces = false
    }
    
    let nextButton = CustomButton(title: "다음").then {
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        $0.contentEdgeInsets.top = 14
        $0.contentEdgeInsets.bottom = 15
    }
    
    @objc func goToNext(_ sender: UIButton) {
        if nextButton.titleLabel?.text == "다음" {
            let contentOffset = CGPoint(x: view.frame.width, y: 0)
            guideScrollView.setContentOffset(contentOffset, animated: true)
            nextButton.setTitle("시작하기", for: .normal)
        } else {
            let viewController = LoginViewController()
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }
    
    let pageControl = UIPageControl()
    
    let guideImages:[UIImage] = [UIImage(named: "guide1Image")!, UIImage(named: "guide2Image")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        addContentScrollView()
        setUI()
    }
    
    private func setUI() {
        safeArea.addSubview(guideScrollView)
        guideScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-53)
            $0.leading.equalToSuperview().offset(31)
            $0.trailing.equalToSuperview().offset(-30)
        }

        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.bottom).offset(-61)
        }
        
    }
    
    private func setScrollView() {
        guideScrollView.delegate = self
        guideScrollView.frame = UIScreen.main.bounds
        guideScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(guideImages.count), height: UIScreen.main.bounds.height)
        pageControl.currentPage = 0
        pageControl.numberOfPages = guideImages.count
        pageControl.pageIndicatorTintColor = UIColor.rgb(red: 171, green: 171, blue: 171)
        pageControl.currentPageIndicatorTintColor = UIColor.mainColor
    }
    
    private func addContentScrollView() {
        for i in 0..<guideImages.count {
            let imageView = UIImageView()
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: guideScrollView.bounds.width, height: guideScrollView.bounds.height)
            imageView.image = guideImages[i]
            guideScrollView.addSubview(imageView)
            guideScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
}


extension GuideViewController: UIScrollViewDelegate {
    
    private func setPageControl() {
        pageControl.numberOfPages = guideImages.count
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        if Int(round(value)) == 1 {
            nextButton.setTitle("시작하기", for: .normal)
        } else {
            nextButton.setTitle("다음", for: .normal)
        }
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
    
}




