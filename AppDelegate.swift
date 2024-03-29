//
//  AppDelegate.swift
//  DeckOfCards
//
//  Created by Mark Davison on 28/05/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Parse
import CoreTelephony
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    var window: UIWindow?
    var userInfo = UserInfo()

    //    var userBet : CareerBetting
    
    
    //When Parse is linked up this will find Parse object, but for now it will be created from scratch each time.
 //   var userBet = UserBetInfo()
    
    
//    enum SubscriptionType: Int {
//        case autoRenewable = 0,
//        nonRenewing = 1
//    }
//
//    enum PurchaseType: Int {
//        case simple = 0,
//        autoRenewing,
//        nonRenewing
//    }

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

      //  let userBet = CareerBetting()
        //game.userBet = userBet

       /// TAKE THIS OOT!!
        game.currentSubscriber = true
        print("AppDel: Hi me!")
        var myflag : Int = 0

        print("AD: at this point there lives something called \(CareerBetting.sharedCareer.start)")
        let currentSession = SessionBetting()

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in

            myflag += 1
            game.turnOrange = true
            print("AppDel: turning things orange")
            for purchase in purchases {

                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                            print("AppDel: Purchases Restored!!")
                        }
                    // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    }
                }
            }
        // added 030119 - as my app can deliver the content
        
        print("AppDel: Just before appstore bit")

        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
            game.turnOrange = true
            return(true)
            
           // print("AppDel: Appstore triggered purchase of IAP")
        //    myflag += 2
//
            //  game.userInfo.incMenuSubscriptions()
            //    performSegue(withIdentifier: "subSeque", sender: self)
            // return(true)
        }
        print(game.currentSubscriber)
        
        print("AppDel: setting up Parse Client Config")
        let config = ParseClientConfiguration { (po7csConfig) in
            po7csConfig.applicationId = "pokerodds"
            po7csConfig.server = "http://pokeroddsserver.herokuapp.com/parse"
            po7csConfig.clientKey = "DeckOfCards@18"
        }
        print("AppDel: setting up Parse test object 3")

        Parse.initialize(with: config)
        
        /*
         first bring the memory object into being
         determine whether it already is stored in the DB - checkExists
         if not, create a new DB object and save it - createInDB
         otherwise load the old one in and do some update - LoadFromDB
         */
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        print("AppDel: uuid = \(String(describing: uuid))")
        let query = PFQuery(className: "BackGround2")
        query.whereKey("uuid", equalTo: uuid!)
        //   query.whereKey("uuid", equalTo: "A0DC5487-7FAB-4602-B61F-B48EACBE45BA")
   //     userInfo = UserInfo()
        query.getFirstObjectInBackground( block: { (loadedObject, error) -> Void in
            
            if error != nil {
                self.userInfo.createUserInfoObject()
                print("AppDel: error = \(String(describing: error)) - ParseDB first time through - creating user info object")
            } else if let dbRecord = loadedObject {
                self.userInfo.loadUserInfoFromDB(bgObject: dbRecord)
                print("ParseDB - loading pre-existing database object in a bg object in memory")

            }
            game.userInfo = self.userInfo

            print("AppD: game.userinfo.subscriptionEnd \(game.userInfo.subscriptionEnd)")
            if  game.userInfo.subscriptionEnd > Date()  {
                game.currentSubscriber = true
            }
            print("currentSubscriber = \(game.currentSubscriber)")

        //never delete this next line
        // parse-dashboard --appId pokerodds --masterKey DeckOfCards@18 --serverURL "http://pokeroddsserver.herokuapp.com/parse"
        print("AppDel: Ending!")

        }

        )
        return true

    }
    
    public func getDate() -> String {
        let date = DateFormatter()
        date.dateStyle = .full
        let time = DateFormatter()
        time.timeStyle = .full
        let dateString = date.string(from: Date())
        let timeString = time.string(from: Date())
        return timeString + " " + dateString
    }
    
    func getNetworkDetail() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        guard let info = networkInfo.subscriberCellularProvider else {return "Nope"}
        if let carrier = info.isoCountryCode {
            print("AppDel: Carrier is \(carrier)")
            return carrier
        }
        return "Nope2"
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

    
//    func verifySubscription(with Id: String, sharedSecret: String, type: SubscriptionType , validDuration: TimeInterval? = nil) {
//        print("AD Subs: VS--- A")
//        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
//        print("AD Subs: VS--- B")
//
//        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
//            switch result {
//
//            case .success(let receipt):
//                print("AD Subs: VS--- C2")
//
//                switch type {
//
//                case .autoRenewable:
//                    print(" AD Subs: VS--- D1")
//
//                    let purchaseResult = SwiftyStoreKit.verifySubscription(
//                        ofType: .autoRenewable,
//                        productId: Id,
//                        inReceipt: receipt)
//                    print("AD Subs: VS--- D2")
//
//                    switch purchaseResult {
//                    case .purchased(let expiryDate):
//                        print("AD Subs: VS--- D2.1: Great News! \(Id) is valid until \(expiryDate)")
//                        game.verificationResults[0] = "Great News! You are on this plan until \(expiryDate)"
//                        game.currentSubscriber = true
//                    case .expired(let expiryDate):
//                        print("AD Subs: VS--- D2.1: Oh dear! \(Id) is expired since \(expiryDate)")
//                        game.verificationResults[0] = "Oh dear! Your subscription expired on \(expiryDate)"
//
//                    case .notPurchased:
//                        print("AD Subs: VS--- D2.1: Oh dear! The user has never purchased \(Id)")
//                        game.verificationResults[0] = "The user has never purchased this subscription"
//
//                    }
//
//                    print("AD Subs: VS--- D3")
//
//                case .nonRenewing:
//                    print("AD Subs: VS--- E1")
//
//                    guard let validDuration = validDuration else {return}
//                    print("AD Subs: VS--- E2")
//
//                    let purchaseResult = SwiftyStoreKit.verifySubscription(
//                        ofType: .nonRenewing(validDuration: validDuration),
//                        productId: Id,
//                        inReceipt: receipt)
//                    print("AD Subs: VS--- E3")
//
//                    switch purchaseResult {
//                    case .purchased(let expiryDate):
//                        print("AD Subs: VS--- E3.1: Great News! \(Id) is valid until \(expiryDate)")
//                        game.verificationResults[1] = "Great News! You are on this plan until \(expiryDate)"
//                        game.currentSubscriber = true
//
//
//                    case .expired(let expiryDate):
//                        print("AD Subs: VS--- E3.1: Oh dear! \(Id) is expired since \(expiryDate)")
//                        game.verificationResults[1] = "Oh dear! Your subscription expired on \(expiryDate)"
//
//                    case .notPurchased:
//                        print("AD Subs: VS--- E3.1: Oh dear! The user has never purchased \(Id)")
//                        game.verificationResults[1] = "Oh dear! The user has never purchased \(Id)"
//
//                    }
//                }
//
//
//                print("Subs: VS--- F")
//            case .error(let error):
//                print("Subs: VS--- Receipt verification failed: \(error)")
//            }
//        }
//     //   tableView.reloadData()
//
//    }


}

