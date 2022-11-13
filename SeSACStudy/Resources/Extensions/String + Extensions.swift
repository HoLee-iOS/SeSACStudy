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
        var phoneNum: String
        if self.count > 3 && self.count < 8 {
            phoneNum = self.replacingOccurrences(of: "(\\d{3})(\\d{1})", with: "$1-$2", options: .regularExpression)
            return phoneNum
        } else if self.count > 8  {
            phoneNum = self.replacingOccurrences(of: "(\\d{3})-(\\d{4})(\\d{1})", with: "$1-$2-$3", options: .regularExpression)
            return phoneNum
        }
        return self
    }
    
    //MARK: - 휴대폰 번호 하이픈 제거
    func removeHypen() -> String {
        let phoneText = self.replacingOccurrences(of: "-", with: "")
        let phoneNum = phoneText.dropFirst()
        return "+82\(phoneNum)"
    }
}
