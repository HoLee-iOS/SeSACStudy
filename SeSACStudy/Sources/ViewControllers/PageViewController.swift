//
//  PageViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import SnapKit

final class PageViewController: UIPageViewController {
    
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
        setControl()
        setPageContents()
    }
    
    func setConfigure() {
        dataSource = self
        delegate = self
    }
    
    func setControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControl.pageIndicatorTintColor = GrayScale.gray5
        pageControl.currentPageIndicatorTintColor = BlackNWhite.black
    }
    
    func setPageContents() {
        for i in 0..<PageContents.contents.count {
            let vc = PageContentsViewController()
            vc.imageView.image = PageContents.contents[i].imgs
            let style = NSMutableParagraphStyle()
            let fontSize: CGFloat = 24
            let lineheight = fontSize * 1.6
            style.minimumLineHeight = lineheight
            style.maximumLineHeight = lineheight
            style.alignment = .center
            let attributedText = NSMutableAttributedString(string: PageContents.contents[i].highlight ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.medium, size: 24)!, NSAttributedString.Key.foregroundColor: BrandColor.green, .paragraphStyle: style, .baselineOffset: (lineheight - fontSize) / 4])
            attributedText.append(NSAttributedString(string: PageContents.contents[i].strings, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.regular, size: 24)!, NSAttributedString.Key.foregroundColor: BlackNWhite.black, .paragraphStyle: style, .baselineOffset: (lineheight - fontSize) / 4]))
            vc.label.attributedText = attributedText
            pages.append(vc)
        }
        
        setViewControllers([pages[0]], direction: .forward, animated: true)
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
}
