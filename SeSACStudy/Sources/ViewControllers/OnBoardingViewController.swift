//
//  OnBoardingViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/08.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {
    
    lazy var myView: UIView = {
        let view = UIView()        
        return view
    }()
    
    let pageVC = PageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
        setConstraints()
        addView()
    }
    
    func configureUI() {
        view.addSubview(myView)
    }
    
    func setConstraints() {
        
        myView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func addView() {
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { make in
            make.edges.equalTo(myView.snp.edges)
        }
        pageVC.didMove(toParent: self)
    }
}
