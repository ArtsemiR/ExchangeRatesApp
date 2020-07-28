//
//  AppDelegate.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/6/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        #if DEBUG
        NSSetUncaughtExceptionHandler { exception in
            print(exception)
            exception.callStackSymbols.forEach { (stackSymbol) in
                print(stackSymbol)
            }
        }
        #endif

        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExchangeRatesApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
