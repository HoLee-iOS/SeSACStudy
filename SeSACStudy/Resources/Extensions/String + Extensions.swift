//
//  String + Extensions.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import Foundation

extension String {    
    // MARK: - 휴대폰 번호 하이픈 추가
    func addHypen() -> String {
        var phoneNum = self.map { String($0) }
        if self.count > 3 && self.count < 8 {
            phoneNum[3] = "-"
        } else if self.count > 8 {
            phoneNum[8] = "-"
        }
        return phoneNum.joined()
    }
}
