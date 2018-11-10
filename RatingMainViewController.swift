//
//  RatingMainViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 29/04/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit
import StoreKit

class RatingMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ten: UIImageView!
    @IBOutlet weak var jack: UIImageView!
    @IBOutlet weak var queen: UIImageView!
    @IBOutlet weak var king: UIImageView!
    @IBOutlet weak var ace: UIImageView!
    
    
    
    
    let ratingArray = ["Happy", "Confused", "Unhappy"]
    let iconArray = [#imageLiteral(resourceName: "happy"),#imageLiteral(resourceName: "confused"),#imageLiteral(resourceName: "unhappy")]
    
    @IBOutlet weak var ratingTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 40
        tableView.layer.cornerRadius = 5
    //    tableView.layer.borderColor = CGColor.blac
        return 3
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("rvc : in cellForRowAt indexpath: row = \(indexPath.row)")
        let rCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "RCell")
        rCell.textLabel?.text = ratingArray[indexPath.row]
        rCell.textLabel?.textColor = UIColor.blue
        rCell.textLabel?.font = UIFont(name:"Avenir", size:16)
        rCell.backgroundColor = UIColor.white
        rCell.imageView?.image = iconArray[indexPath.row]
        rCell.layer.cornerRadius = 2
        return rCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chosenDeck = fCellContents?[indexPath.row].faveDeck
//        print("NewDeck 1 = \(newDeck)")
//        selectedWinningHand = (fCellContents?[indexPath.row].winningHand)!
//        selectedHandTime = (fCellContents?[indexPath.row].handTime)!
//
//        for f in chosenDeck! {
//            newDeck.append(Card(face: game.myDeckOfCards.faces[f % 13], suit: game.myDeckOfCards.suits[f / 13], order: f))
//        }
//        outletLoad.alpha = 1
//
        print("RVC: Rating Selection = \(ratingArray[indexPath.row])")
        switch ratingArray[indexPath.row] {
        case "Happy":
            game.userInfo.incRateHappy()
            game.userInfo.setRate(rateValue : 3)
                if game.userInfo.appOpens > 5 {
                    if #available(iOS 10.3, *) {
                        print("Review Requested")
                        SKStoreReviewController.requestReview()                        
                    } else {
                        // Fallback on earlier versions
                    }
                    
                } else {
                    
                    print("It is probably too early to judge - yo have only run this App \(game.userInfo.appOpens) times.\nWe would welcome you feedback so why not come back in a little while?")
                    
                }
            
            performSegue(withIdentifier: "FeedbackSequeFromRating", sender: self)
        case "Confused":
            game.userInfo.incRateConfused()

            game.userInfo.setRate(rateValue : 2)

            performSegue(withIdentifier: "MoreInfoSequeFromRating", sender: self)
        case "Unhappy":
            game.userInfo.incRateUnhappy()

            game.userInfo.setRate(rateValue : 1)

            performSegue(withIdentifier: "ContactSequeFromRating", sender: self)
        default:
            print("RVC: Error performing Segue")
        }
        
    }

    public func animateDealtCards() {
        let cardArray = [ten, jack, queen, king, ace]
        var duration : Double = 0.5
        var splay : CGFloat = -0.4
        for ci in cardArray {
            ci?.frame = CGRect(x: 0, y: 0, width: (ci?.frame.width)! * game.splashCardMultiplier, height: (ci?.frame.height)! * game.splashCardMultiplier)
            ci?.center = CGPoint(x: -100, y: game.portraitWidth/5)
            ci?.alpha = 1
            UIView.animate(withDuration: duration) {
                ci?.center = CGPoint(x: Double(game.portraitHeight)*0.2, y: Double(game.portraitWidth)*0.35)

                ci?.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            
                let rotation = CGAffineTransform(rotationAngle: splay)
            
                ci?.transform = rotation
                splay += 0.2
                duration += 0.3
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        animateDealtCards()

        //        UIView.animate(withDuration: 2.0) {
            //      dealDisplayedCard(xPos: <#T##CGFloat#>, yPos: <#T##CGFloat#>, splay: <#T##CGFloat#>, ci: <#T##UIImageView#>)
//            let rotationTen = CGAffineTransform(rotationAngle: -0.4)
//            self.ten.transform = rotationTen
//        }
//        UIView.animate(withDuration: 3.0) {
//
//            let rotationJack = CGAffineTransform(rotationAngle: -0.2)
//            self.jack.transform = rotationJack
//        }
//        //    let rotationQueen = CGAffineTransform(rotationAngle: -0.4)
//        //    self.queen.transform = rotationQueen
//        UIView.animate(withDuration: 4.0) {
//            let rotationKing = CGAffineTransform(rotationAngle: 0.2)
//            self.king.transform = rotationKing
//        }
//        UIView.animate(withDuration: 5.0) {
//            let rotationAce = CGAffineTransform(rotationAngle: 0.4)
//            self.ace.transform = rotationAce
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingTable.separatorStyle = .singleLineEtched
        ratingTable.isScrollEnabled = false
   //     ratingTable.layer.borderColor = UIColor.black as? CGColor
        ratingTable.layer.borderWidth = 0.5
        ratingTable.reloadData()
        print("rvc: in view did load")
        // Do any additional setup after loading the view.

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    
  

}
