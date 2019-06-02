//
//  SubscriptionViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 28/07/2018.
//  Copyright © 2018 anditwasso. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class SubscriptionViewController: UIViewController {

    //MARK Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var annualGuide: UILabel!
    @IBOutlet weak var monthlyGuide: UILabel!
    
    @IBOutlet weak var annualLabel: UILabel!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var annualPriceLabel: UILabel!
    
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    
    //@IBOutlet weak var territory: UILabel!
    @IBOutlet weak var appleID: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goProDescription: UILabel!
    @IBAction func termsRequest(_ sender: Any) {
        if let url = URL(string: "http://www.odds4poker.com/terms-of-use") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBOutlet weak var outletSubscribe: UIButton!
    @IBAction func checkAnnualStatus(_ sender: Any) {
        statusLabelAnnual.text = proAnnualVerificationResults
    }
    
    @IBOutlet weak var outletSubscribeMonth: UIButton!
    
    
    
    @IBAction func subscribeMonthly(_ sender: Any) {
        if game.userInfo.subscriptionEnd > Date() {
            let alert = UIAlertController(title: "Subscription Not Expired!", message: "You may only subscribe after your current subscription has expired - yours will expire on \(game.userInfo.subscriptionEnd).", preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            print("Subs: subscribeMonthly--- Tried to subscribe while there way subscription remaining")

        } else {
            print("Subs: subscribeMonthly--- Starting purchaseSubscription: \(game.inAppPurchaseIDs[1]) - \(game.sharedSecret) - .nonrenewing")
            purchaseSubscription(with: game.inAppPurchaseIDs[1], sharedSecret: game.sharedSecret, type: .nonRenewing, validDuration: TimeInterval(24 * 3600 * 31))
        }
    }
    
    @IBAction func subscribeAnnual(_ sender: Any) {
        if game.userInfo.subscriptionEnd > Date() {
            let alert = UIAlertController(title: "Subscription Not Expired!", message: "You may only subscribe after your current subscription has expired - yours will expire on \(game.userInfo.subscriptionEnd).", preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            print("Subs: subscribeAnnual--- Tried to subscribe while there way subscription remaining")
            
        } else {
            print("Subs: subscribeAnnual--- Starting purchaseSubscription\(0): \(game.inAppPurchaseIDs[0]) - \(game.sharedSecret) - .autoRenewable")
            let messageFont = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 9.0)!]

            let alertMessage = """
            • This subscription is for 1-year
            • Subscription Price is: \(String(describing: self.priceLabelAnnual.text!))
            • Payment will be charged to iTunes Account at confirmation of purchase
            • Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period
            • Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal
            • Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase
            The Odds4Poker Terms of Use and link to Privacy Policy: www.odds4poker.com/terms-of-use
            """
            let attrMessage = NSMutableAttributedString(string: alertMessage, attributes: messageFont)
            let alert = UIAlertController(title: "Before you subscribe to Odds4Poker Pro, please note the following!", message: attrMessage.string, preferredStyle: .alert)
        
            let subscribePro = UIAlertAction(title: "Subscribe", style: .default) {(action) in
                print("Subs: selected Subscribe")
                self.purchaseSubscription(with: game.inAppPurchaseIDs[0], sharedSecret: game.sharedSecret, type: .autoRenewable)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default){(action) in
                print("Subs: selected Cancel")

            }
            alert.addAction(subscribePro)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)

        }
    }

    
    @IBOutlet weak var statusLabelAnnual: UILabel!
    @IBOutlet weak var priceLabelAnnual: UILabel!
    
    @IBOutlet weak var priceLabelMonthly: UILabel!
    
    @IBOutlet weak var statusLabelMonthly: UILabel!
    
    
    @IBOutlet weak var goProTV: UITextView!
  
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    var proAnnualVerificationResults = "Annual: Not Verified"  /*{
        willSet {
            print("\nSubs: Annual New value is: ", newValue)

        }
        didSet {
            print("\nSubs: Annual Old value was: ", oldValue)

            tableView.reloadData()
        }
    } */
  
    var proMonthlyVerificationResults = "Monthly: Not Verified"  /*{
        willSet {
            print("\nSubs: Monthly New value is: ", newValue)
            
        }
        didSet {
            print("\nSubs: Monthly Old value was: ", oldValue)
            tableView.reloadData()
        }
    } */
    
    
    @IBAction func restorePurchases(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Subs:--- Restore Failed: \(results.restoreFailedPurchases)")

            }
            else if results.restoredPurchases.count > 0 {
                print("Subs:--- Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet weak var outletRestorePurchases: UIButton!

    var territoryLabel = String()
    var uuidLabel = String()
 
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK - View LIFECYCLE
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if game.smallScreen {
            let smallFrame1 = CGRect(x: outletSubscribe.frame.minX, y: outletSubscribe.frame.minY, width: 70, height: 30)
            let smallFrame2 = CGRect(x: outletSubscribe.frame.minX, y: outletSubscribe.frame.minY-25, width: 70, height: 30)

            let rpFrame = CGRect(x: outletRestorePurchases.frame.minX, y: outletRestorePurchases.frame.minY, width: 120, height: 30)
            outletSubscribe.frame = smallFrame1
            outletSubscribeMonth.frame = smallFrame2
            outletRestorePurchases.frame = rpFrame
        } else if game.normalScreen {
            let midFrame1 = CGRect(x: outletSubscribe.frame.minX, y: outletSubscribe.frame.minY, width: 90, height: 38)
            let midFrame2 = CGRect(x: outletSubscribe.frame.minX, y: outletSubscribe.frame.minY-20, width: 90, height: 38)
            let rpFrame = CGRect(x: outletRestorePurchases.frame.minX, y: outletRestorePurchases.frame.minY, width: 140, height: 38)
            outletSubscribe.frame = midFrame1
            outletSubscribeMonth.frame = midFrame2
            outletRestorePurchases.frame = rpFrame
        } else { //padscreen
            let bigFrame1 = CGRect(x: outletSubscribe.frame.minX, y: outletSubscribe.frame.minY, width: 100, height: 50)
             let bigFrame2 = CGRect(x: outletSubscribe.frame.minX, y: outletSubscribe.frame.minY-40, width: 100, height: 50)
            let rpFrame = CGRect(x: outletRestorePurchases.frame.minX-30, y: outletRestorePurchases.frame.minY, width: 250, height: 50)
            outletSubscribe.frame = bigFrame1
            outletSubscribeMonth.frame = bigFrame2
            outletRestorePurchases.frame = rpFrame
        }
    }
    
    
    override func viewDidLoad() {
   
        verifySubscription(with: game.inAppPurchaseIDs[0], sharedSecret: game.sharedSecret, type: .autoRenewable, validDuration: nil)
        verifySubscription(with: game.inAppPurchaseIDs[1], sharedSecret: game.sharedSecret, type: .nonRenewing, validDuration: TimeInterval(31*24*3600))
        outletSubscribeMonth.layer.cornerRadius = 5.0
        outletSubscribe.layer.cornerRadius = 5.0
        outletRestorePurchases.layer.cornerRadius = 5.0
     //   let fontName = "Bodoni 72 Smallcaps"
        var useThisBodyFontSize = game.bodyFontSize
        goProTV.text = proString
        if game.normalScreen || game.padScreen {
            useThisBodyFontSize = game.bodyFontSize-3
        }
        

        titleLabel.font =  UIFont(name: game.mainTitleFont, size: game.mainTitleFontSize)
        goProTV.font = UIFont(name: game.normalTitleFont, size: game.normalTitleFontSize)
        annualGuide.font = UIFont(name: game.bodyFont, size: useThisBodyFontSize)
        monthlyGuide.font = UIFont(name: game.bodyFont, size: useThisBodyFontSize)
        annualLabel.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        priceLabelAnnual.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        monthlyLabel.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        priceLabelMonthly.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
     //   two.layer
        outletSubscribe.titleLabel?.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        outletSubscribeMonth.titleLabel?.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        outletRestorePurchases.titleLabel?.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        olSave.titleLabel?.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        olTerms.titleLabel?.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)
        
        statusLabelAnnual.font = UIFont(name: game.bodyFont, size: useThisBodyFontSize)
        statusLabelMonthly.font = UIFont(name: game.bodyFont, size: useThisBodyFontSize)

//        print("Font Set: Title Label \(game.mainTitleFont) \(game.mainTitleFontSize)")
//        print("Font Actual: Title Label \(String(describing: titleLabel.font))")
//
//        print("Font Set: GoProTV \(game.normalTitleFont) \(game.normalTitleFontSize)")
//        print("Font Actual: GoProTV \(String(describing: goProTV.font))")
//
//        print("Font Set: AnnualGuide \(game.bodyFont) \(game.bodyFontSize)")
//        print("Font Actual: annualGuide \(String(describing: annualGuide.font))")
//
//        print("Font Set: monthlyGuide \(game.bodyFont) \(game.bodyFontSize)")
//        print("Font Actual: monthlyGuide \(String(describing: monthlyGuide.font))")
//
//        print("Font Set: annualLabel \(game.normalTitleFont) \(game.normalTitleFontSize)")
//        print("Font Actual: annualLabel \(String(describing: annualLabel.font))")
//
//        print("Font Set: priceLabelAnnual \(game.normalTitleFont) \(game.normalTitleFontSize)")
//        print("Font Actual: priceLabelAnnual \(String(describing: priceLabelAnnual.font))")
//
//        print("Font Set: monthlyLabel \(game.normalTitleFont) \(game.normalTitleFontSize)")
//        print("Font Actual: monthlyLabel \(String(describing: monthlyLabel.font))")
//
//        print("Font Set: priceLabelMonthly \(game.normalTitleFont) \(game.normalTitleFontSize)")
//        print("Font Actual: priceLabelMonthly \(String(describing: priceLabelMonthly.font))")
//
//        print("Font Set: outletSubscribe \(game.minorTitleFont) \(game.minorTitleFontSize)")
//        print("Font Actual: outletSubscribe \(String(describing: outletSubscribe.titleLabel?.font))")
//
//        print("Font Set: outletSubscribeMonth \(game.minorTitleFont) \(game.minorTitleFontSize)")
//        print("Font Actual: outletSubscribeMonth \(String(describing: outletSubscribeMonth.titleLabel?.font))")



        uuidLabel = game.userInfo.uuid
        if game.userInfo.country == "anyoldplace" || game.userInfo.country == "Carrier cannot be identified" {
            territoryLabel = "Country Unidentified"
        } else {
            territoryLabel = game.userInfo.country.uppercased()
        }
        goProTV.text = proString //+ "\nTerritory: " + territoryLabel + "\nUnique ID: " + uuidLabel
    
        delay(5.0)
        {
            self.getProductInfo(id: 0)
            self.getProductInfo(id: 1)
            
        }

        
        super.viewDidLoad()


    }

    // MARK: Actions
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
    
    
    @IBOutlet weak var olSave: UIButton!
    
    @IBOutlet weak var olTerms: UIButton!
    
    let proString = "You may Go Pro for 1 Year or 1 Month (31 days) to access premium features such as:Perspective Switch, Changing the Odds format, Replacing Cards in the Deck, Saving and Reloading Games, Naming Players and Hiding Main Screen Odds"
    
//    let proString = "You may Go Pro for 1 Year or 1 Month (31 days) to access premium features such as:\n\tPerspective Switch\n\tChanging the Odds format\n\tReplacing Cards in the Deck\n\tSaving and Reloading Games\n\tNaming Players\n\tHiding Main Screen Odds"
//
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation


    public func getProductInfo(id: Int){
        SwiftyStoreKit.retrieveProductsInfo([game.inAppPurchaseIDs[id]]) { result in
            if let product = result.retrievedProducts.first {
                print("Product: \(product.localizedTitle) - \(product.localizedDescription), price: \(product.localizedPrice!)")

                if id == 0 {
                    print("Subs:--- .AutoRenewable1 - verify results is \(self.proAnnualVerificationResults)")
                    self.priceLabelAnnual.text = product.localizedPrice!
                    self.statusLabelAnnual.text = self.proAnnualVerificationResults
                    print("Subs:--- .AutoRenewable2 - verify results is \(self.proAnnualVerificationResults)")
                } else if id == 1 {
                    print("Subs:--- .nonrenewing1 - verify results is \(self.proMonthlyVerificationResults)")
                        self.priceLabelMonthly.text = product.localizedPrice!
                    self.statusLabelMonthly.text = self.proMonthlyVerificationResults
                    print("Subs:--- .nonrenewing2 - verify results is \(self.proMonthlyVerificationResults)")
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Subs:--- Invalid product identifier: \(invalidProductId)")
                self.statusLabelAnnual.text = "Name not identified"
            }
            else {
                print("Subs:--- Error: \(String(describing: result.error))")
            }
        }
    }

    
   // let sharedSecret :String =  "4bc122b5cb304d079aa700ac2fa92d98"
    
    enum SubscriptionType: Int {
        case autoRenewable = 0,
         nonRenewing = 1
    }
    
    enum PurchaseType: Int {
        case simple = 0,
        autoRenewing,
        nonRenewing
    }
    
    

    func verifySubscription(with Id: String, sharedSecret: String, type: SubscriptionType , validDuration: TimeInterval? = nil) {
        print("Subs: VS--- A")
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        print("Subs: VS--- B")

        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {

                case .success(let receipt):
                    print("Subs: VS--- C2")

                switch type {

                case .autoRenewable:
                    print("Subs: VS--- D1")

                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable,
                        productId: Id,
                        inReceipt: receipt)
                    print("Subs: VS--- D2")

                    switch purchaseResult {
                    case .purchased(let expiryDate):
              //          let exdata = parseExpiryDate(with: expiryDate)
                        print("Subs: VS--- D2.1: Great News! \(Id) is valid until \(expiryDate.expiryDate)")
                        self.proAnnualVerificationResults = "Great News! You are on this plan until \(expiryDate.expiryDate).    Auto-renews unless turned off in Settings at least a day before end."
                        game.currentSubscriber = true
                        game.userInfo.setSubscriptionEnd(end: expiryDate.expiryDate)
                    case .expired(let expiryDate):
                        print("Subs: VS--- D2.1: Oh dear! \(Id) is expired since \(expiryDate.expiryDate)")
                        self.proAnnualVerificationResults = "Oh dear! Your subscription expired on \(expiryDate.expiryDate).  This is an auto-renewable subscription."
                   //     game.userInfo.subscriptionEnd = expiryDate.expiryDate
                        game.userInfo.setSubscriptionEnd(end: expiryDate.expiryDate)

                    case .notPurchased:
                        print("Subs: VS--- D2.1: Oh dear! The user has never purchased \(Id)")
                        self.proAnnualVerificationResults = "The user has never purchased this subscription.  If you wish to select this subscription please be aware it is auto-renewable."
                    default:
                        print("Subs: VS--- D2.1: No record of purchase of this autorenewable")
                        self.proAnnualVerificationResults = "No record of purchase of this auto-renewable."
                    }
                    print("Subs: VS--- D3")

                case .nonRenewing:
                    print("Subs: VS--- E1")

                    guard let validDuration = validDuration else {return}
                    print("Subs: VS--- E2")

                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .nonRenewing(validDuration: validDuration),
                        productId: Id,
                        inReceipt: receipt)
                    print("Subs: VS--- E3")

                    switch purchaseResult {
                    case .purchased(let expiryDate):
                        print("Subs: VS--- E3.1: Great News! \(Id) is valid until \(expiryDate.expiryDate)")
                        self.proMonthlyVerificationResults = "Great News! You are on this plan until \(expiryDate.expiryDate).  Please Note: this is a non-renewing subscription."
                        game.currentSubscriber = true
                        game.userInfo.setSubscriptionEnd(end: expiryDate.expiryDate)


                    case .expired(let expiryDate):
                        print("Subs: VS--- E3.1: Oh dear! \(Id) is expired since \(expiryDate.expiryDate)")
                        self.proMonthlyVerificationResults = "Oh dear! Your \(Id) subscription expired on \(expiryDate.expiryDate).  Please Note: this is a non-renewing subscription."
                    //    game.userInfo.subscriptionEnd = expiryDate.expiryDate
                        game.userInfo.setSubscriptionEnd(end: expiryDate.expiryDate)


                    case .notPurchased:
                        print("Subs: VS--- E3.1: Oh dear! The user has never purchased \(Id)")
                        self.proMonthlyVerificationResults = "Oh dear! The user has never purchased \(Id).  Please Note: this is a non-renewing subscription."
                        /// should set expiry date to some point in the past
                    default:
                        print("Subs: VS--- D3.1: No record of purchase of this autorenewable")
                        self.proAnnualVerificationResults = "No record of purchase of this auto-renewable."
                    }
                }
            print("Subs: VS--- F")
            case .error(let error):
                print("Subs: VS--- Receipt verification failed: \(error)")
            }
        }
    }

    func purchaseSubscription(with id: String, sharedSecret: String, type: SubscriptionType, validDuration: TimeInterval? = nil) {
  //      if type == .simple {
        print("Subs: PS--- ID = \(id), sub type = \(type)")
        SwiftyStoreKit.retrieveProductsInfo([id]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    // handle result (same as above)
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        print("Subs: PS--- Purchase Success 1: \(product.productId)")
                        game.currentSubscriber = true
                        game.userInfo.setSubscriptionStart(start: Date())
//                        /*error*/                  if #available(iOS 11.2, *) {
//                            print("Subs: PS--- Calling setSubscriptionEnd with \(product.product.subscriptionPeriod)")
//                        } else {
//                            // Fallback on earlier versions
//                        }
                        game.userInfo.setSubscriptionEnd(end: game.userInfo.subscriptionEnd)
                        /// can't see how the above line is right -  would expect it to get a subscription end date from product
                        guard let validDuration = validDuration else {return}
                        print("Subs: PS--- Purchase Success 2: \(product.productId)")

                        self.verifySubscription(with: id, sharedSecret: sharedSecret, type: type, validDuration: validDuration)
                        print("Subs: PS--- Purchase Success 3: \(product.productId)")
 
                        
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Subs: PS--- Unknown error. Please contact support")
                        case .clientInvalid: print("Subs: PS--- Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("Subs: PS--- The purchase identifier was invalid")
                        case .paymentNotAllowed: print("Subs: PS--- The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("Subs: PS--- The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Subs: PS--- Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Subs: PS--- Could not connect to the network")
                        case .cloudServiceRevoked: print("Subs: PS--- User has revoked permission to use this cloud service")
                        default:
                            print("Subs: Default --- Unknown error. Please contact support")
                            
                        }
                    }
                }
            }
        }
  
    }

}
