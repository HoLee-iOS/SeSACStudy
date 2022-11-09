//
//  OnBoardingViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/08.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = BrandColor.green
        button.setTitleColor(BlackNWhite.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let myView: UIView = {
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
        [startButton, myView].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(48)
        }
        
        myView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(startButton.snp.top).offset(-40)
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
