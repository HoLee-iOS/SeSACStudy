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
    
    //MARK: - 데이트 셀 포맷 변경
    func changeDateCell() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let convertDate = formatter.date(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        if let date = convertDate {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    //MARK: - 데이트 포맷 변경
    func changeDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let convertDate = formatter.date(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        if let date = convertDate {
            return dateFormatter.string(from: date + 3600 * 9)
        }
        return ""
    }
}
