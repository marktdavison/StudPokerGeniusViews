//
//  FeedbackViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 30/04/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit
import StoreKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var socialMediaButton: UIButton!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var reviewButton: UIButton!

    @IBOutlet weak var contactButton: UIButton!
    @IBAction func requestReview(_ sender: Any) {
        // perhaps move this to the happy rating button code?
//        if game.userInfo.appOpens > 5 {
//            if #available(iOS 10.3, *) {
//                print("Review Requested")
//                SKStoreReviewController.requestReview()
//
//            } else {
//                // Fallback on earlier versions
//            }
//
//        } else {
//
//            print("It is probably too early to judge - yo have only run this App \(game.userInfo.appOpens) times.\nWe would welcome you feedback so why not come back in a little while?")
//
//        }
 }
    
    
    @IBOutlet weak var twitterButton: UIButton!
    
    let cr :CGFloat = 10
    
    
    @IBOutlet weak var fbButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondLabel.layer.cornerRadius = cr
        reviewButton.layer.cornerRadius = cr
        contactButton.layer.cornerRadius = cr
        socialMediaButton.layer.cornerRadius = cr

   //     fbButton.layer.cornerRadius = cr
     //   twitterButton.layer.cornerRadius = cr

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
