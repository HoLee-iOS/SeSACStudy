//
//  DateViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit

class DateViewController: BaseViewController {
    
    let dateView = DateView()
    
    override func loadView() {
        self.view = dateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        
        func dateFormatted(date: Date) -> String {
            let birth = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
            return dateFormatter.string(from: birth)
        }
        
        dateView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.dateView.nextButton.backgroundColor == GrayScale.gray6 {
                    vc.showToast("새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
                } else {
                    UserDefaultsManager.birth = dateFormatted(date: vc.dateView.picker.date)
                    print(UserDefaultsManager.birth)
                    vc.navigationController?.pushViewController(EmailViewController(), animated: true)
                }
            }
            .disposed(by: dateView.disposeBag)
    }
}

