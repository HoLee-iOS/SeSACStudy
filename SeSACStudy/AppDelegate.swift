//
//  AppDelegate.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/07.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        aboutRealmMigration()
        
        //MARK: - 앱 실행시 네트워크 상태 확인
        NetworkMonitor.shared.startMonitoring()
        
        //MARK: - 파이어베이스 설정
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
        }
        application.registerForRemoteNotifications()
        
        //MARK: - FCM 토큰 불러오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                UserDefaultsManager.fcmToken = token
                print("FCM registration token: \(token)")
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    
    //마이그레이션 적용
    func aboutRealmMigration() {
        
        let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            
            //이전 버전에 chatDate 타입이 Date -> String으로 변경되었던것에 대한 마이그레이션
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: ChatData.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["chatDate"] = old["chatDate"]
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}



