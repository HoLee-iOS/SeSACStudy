//
//  PageViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import SnapKit

final class PageViewController: UIPageViewController {
    
    let pageControl = UIPageControl(frame: .zero)
    
    var pages: [UIViewController] = [UIViewController]()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setConstraints()
        setControl()
    }
    
    @objc func moveTo(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }
    
    func setConfigure() {
        dataSource = self
        delegate = self
        
        for i in 0..<PageContents.contents.count {
            let vc = PageContentsViewController()
            vc.imageView.image = PageContents.contents[i].imgs
            vc.label.text = PageContents.contents[i].strings
            pages.append(vc)
        }
        
        setViewControllers([pages[0]], direction: .forward, animated: true)
        
        view.addSubview(pageControl)
    }
    
    func setConstraints() {
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.8)
        }
    }
    
    func setControl() {
        pageControl.numberOfPages = PageContents.contents.count
        pageControl.pageIndicatorTintColor = GrayScale.gray5
        pageControl.currentPageIndicatorTintColor = BlackNWhite.black
        pageControl.allowsContinuousInteraction = false
        pageControl.addTarget(self, action: #selector(moveTo), for: .valueChanged)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    //MARK: 이전 페이지 설정
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return previousIndex < 0 ? pages[2] : pages[previousIndex]
    }
    
    //MARK: 다음 페이지 설정
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return nextIndex >= pages.count ? pages[0] : pages[nextIndex]
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
    
    //MARK: 총 페이지 갯수 설정
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    //MARK: 디스플레이된 형태로 페이지 가져오는 설정
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first else { return 0 }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else { return 0 }
        return firstVCIndex
    }
    
    //MARK: 페이지 컨트롤 연결
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentPageViewController = pageViewController.viewControllers?.first else { return }
        guard let index = pages.firstIndex(of: currentPageViewController) else { return }
        pageControl.currentPage = index
    }
}
