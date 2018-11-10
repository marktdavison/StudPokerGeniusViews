//
//  OddsViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 19/08/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit


class OddsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.userInfo.incOddsView()
    }

    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var oddsText: UITextView!
    
    
    @IBOutlet weak var bestHands: UITextView!
    
    @IBAction func closeButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
        }
    
    
    private var suitSym: [String: String] = [

        "Clubs" : "♣️",
        "Hearts"  : "❤️",
        "Diamonds" : "♦️",
        "Spades"  : "♠️"
    ]
    private var faceAbbr: [String: String] = [
        "Ace"  :  "A",
        "Deuce"  :  "2",
        "Trip"  :  "3",
        "Four"  :  "4",
        "Five"  :  "5",
        "Six"  :  "6",
        "Seven"  :  "7",
        "Eight"  :  "8",
        "Nine"  :  "9",
        "Ten"  :  "10",
        "Jack"  :  "J",
        "Queen"  : "Q",
        "King"  :  "K"
    ]
    
    @IBOutlet weak var perspectiveOutlet: UISwitch!
    
    @IBAction func perspectiveSwitch(_ sender: UISwitch) {
        game.userInfo.incOddsViewSneakyPeak()
        if perspectiveOutlet.isOn == true {
            perspectiveLabel.text = "Player View"
            populateOverlayPlayer()
        } else {
            if game.currentSubscriber {
                populateOverlayCheater()
                perspectiveLabel.text = "Cheat\'s View"
            } else {
                presentSubscriptionAlert(functionality: "Switching to Cheat\'s View")
                perspectiveOutlet.setOn(true, animated: true)
            }


        }
    }
    @IBOutlet weak var perspectiveLabel: UILabel!

    @IBOutlet weak var card1: UILabel!
    
    @IBOutlet weak var card2: UILabel!
    @IBOutlet weak var card3: UILabel!

    @IBOutlet weak var card4: UILabel!
    @IBOutlet weak var card5: UILabel!
    @IBOutlet weak var card6: UILabel!
    
    @IBOutlet weak var s3tot: UILabel!
    @IBOutlet weak var s4tot: UILabel!
    @IBOutlet weak var s5tot: UILabel!
    @IBOutlet weak var s6tot: UILabel!
    
    
    @IBOutlet weak var straflu3Odds: UILabel!
    @IBOutlet weak var poker3Odds: UILabel!
    @IBOutlet weak var fh3Odds: UILabel!
    @IBOutlet weak var flush3Odds: UILabel!
    @IBOutlet weak var run3Odds: UILabel!
    @IBOutlet weak var trips3Odds: UILabel!
    @IBOutlet weak var twoPair3Odds: UILabel!
    @IBOutlet weak var pair3Odds: UILabel!
    @IBOutlet weak var high3Odds: UILabel!
    
    @IBOutlet weak var straflu4Odds: UILabel!
 //   @IBOutlet weak var sf4Odds: UILabel!
    @IBOutlet weak var poker4Odds: UILabel!
    @IBOutlet weak var fh4Odds: UILabel!
    @IBOutlet weak var flush4Odds: UILabel!
    @IBOutlet weak var run4Odds: UILabel!
    @IBOutlet weak var trips4Odds: UILabel!
    @IBOutlet weak var twoPair4Odds: UILabel!
    @IBOutlet weak var pair4Odds: UILabel!
    @IBOutlet weak var high4Odds: UILabel!
    
        
    @IBOutlet weak var straflu5Odds: UILabel!
    @IBOutlet weak var poker5Odds: UILabel!
    @IBOutlet weak var fh5Odds: UILabel!
    @IBOutlet weak var flush5Odds: UILabel!
    @IBOutlet weak var run5Odds: UILabel!
    @IBOutlet weak var trips5Odds: UILabel!
    @IBOutlet weak var twopair5Odds: UILabel!
    @IBOutlet weak var pair5Odds: UILabel!
    @IBOutlet weak var high5Odds: UILabel!
    
    
    @IBOutlet weak var straflu6Odds: UILabel!
    @IBOutlet weak var poker6Odds: UILabel!
    @IBOutlet weak var fh6Odds: UILabel!
    @IBOutlet weak var flush6Odds: UILabel!
    @IBOutlet weak var run6Odds: UILabel!
    @IBOutlet weak var trips6Odds: UILabel!
    @IBOutlet weak var twopair6Odds: UILabel!
    @IBOutlet weak var pair6Odds: UILabel!
    @IBOutlet weak var high6Odds: UILabel!
    
    
    override func didReceiveMemoryWarning() {
      
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var handItem:Hands!
    
    func configureView(){
        if let hand = self.handItem {
            self.playerLabel.text = "Player \(hand.uniqueHandRef)"
            self.bestHands.text = hand.bestCurrentHand()
            let cardNo = hand.allMyCards.count
            if cardNo <= 3 {
                straflu4Odds.alpha = 0
                poker4Odds.alpha = 0
                fh4Odds.alpha = 0
                flush4Odds.alpha = 0
                run4Odds.alpha = 0
                trips4Odds.alpha = 0
                twoPair4Odds.alpha = 0
                pair4Odds.alpha = 0
                high4Odds.alpha = 0
                card4.alpha = 0
                card5.alpha = 0
                card6.alpha = 0

            }
            if cardNo <= 4 {
                straflu5Odds.alpha = 0
                poker5Odds.alpha = 0
                fh5Odds.alpha = 0
                flush5Odds.alpha = 0
                run5Odds.alpha = 0
                trips5Odds.alpha = 0
                twopair5Odds.alpha = 0
                pair5Odds.alpha = 0
                high5Odds.alpha = 0
            }
            if cardNo <= 5 {
                straflu6Odds.alpha = 0
                poker6Odds.alpha = 0
                fh6Odds.alpha = 0
                flush6Odds.alpha = 0
                run6Odds.alpha = 0
                trips6Odds.alpha = 0
                twopair6Odds.alpha = 0
                pair6Odds.alpha = 0
                high6Odds.alpha = 0
            }


        
            card1.text = getAbbr(card: hand.allMyCards[0])
            card2.text = getAbbr(card: hand.allMyCards[1])
            card3.text = getAbbr(card: hand.allMyCards[2])

            if cardNo == 4 {
                card4.text = getAbbr(card: hand.allMyCards[3])

            } else if cardNo == 5 {
                card4.text = getAbbr(card: hand.allMyCards[3])
                card5.text = getAbbr(card: hand.allMyCards[4])

            } else if cardNo > 5 {
                card4.text = getAbbr(card: hand.allMyCards[3])
                card5.text = getAbbr(card: hand.allMyCards[4])
                card6.text = getAbbr(card: hand.allMyCards[5])
               
            }
            
         // by default show the seen odds
            populateOverlayPlayer()
         
        }
    }
    
    public func populateOverlayCheater() {
        
        if let hand = self.handItem {
            straflu3Odds.textColor = UIColor.yellow
            straflu4Odds.textColor = UIColor.yellow
            straflu5Odds.textColor = UIColor.yellow

            straflu6Odds.textColor = UIColor.yellow

            poker3Odds.textColor = UIColor.yellow

            poker4Odds.textColor = UIColor.yellow

            poker5Odds.textColor = UIColor.yellow

            poker6Odds.textColor = UIColor.yellow

            fh3Odds.textColor = UIColor.yellow

            fh4Odds.textColor = UIColor.yellow

            fh5Odds.textColor = UIColor.yellow

            fh6Odds.textColor = UIColor.yellow

            flush3Odds.textColor = UIColor.yellow

            flush4Odds.textColor = UIColor.yellow

            flush5Odds.textColor = UIColor.yellow

            flush6Odds.textColor = UIColor.yellow

            run3Odds.textColor = UIColor.yellow

            run4Odds.textColor = UIColor.yellow

            run5Odds.textColor = UIColor.yellow

            run6Odds.textColor = UIColor.yellow

            trips3Odds.textColor = UIColor.yellow

            trips4Odds.textColor = UIColor.yellow

                trips5Odds.textColor = UIColor.yellow

            trips6Odds.textColor = UIColor.yellow

            twoPair3Odds.textColor = UIColor.yellow

            twoPair4Odds.textColor = UIColor.yellow

            twopair5Odds.textColor = UIColor.yellow
            twopair6Odds.textColor = UIColor.yellow
            pair3Odds.textColor = UIColor.yellow

            pair4Odds.textColor = UIColor.yellow

            pair5Odds.textColor = UIColor.yellow

            pair6Odds.textColor = UIColor.yellow

            high3Odds.textColor = UIColor.yellow

            high4Odds.textColor = UIColor.yellow

            high5Odds.textColor = UIColor.yellow

            high6Odds.textColor = UIColor.yellow

            
            
            straflu3Odds.text = String(format: "%.2f", 100 * hand.odds.strafluRealOdds[0]) + "%"
            straflu4Odds.text = String(format: "%.2f", 100 * hand.odds.strafluRealOdds[1]) + "%"
            straflu5Odds.text = String(format: "%.2f", 100 * hand.odds.strafluRealOdds[2]) + "%"
            straflu6Odds.text = String(format: "%.2f", 100 * hand.odds.strafluRealOdds[3]) + "%"
            poker3Odds.text = String(format: "%.2f", 100 * hand.odds.pokerRealOdds[0]) + "%"
            poker4Odds.text = String(format: "%.2f", 100 * hand.odds.pokerRealOdds[1]) + "%"
            poker5Odds.text = String(format: "%.2f", 100 * hand.odds.pokerRealOdds[2]) + "%"
            poker6Odds.text = String(format: "%.2f", 100 * hand.odds.pokerRealOdds[3]) + "%"
            fh3Odds.text = String(format: "%.1f", 100 * hand.odds.fhRealOdds[0]) + "%"
            fh4Odds.text = String(format: "%.1f", 100 * hand.odds.fhRealOdds[1]) + "%"
            fh5Odds.text = String(format: "%.1f", 100 * hand.odds.fhRealOdds[2]) + "%"
            fh6Odds.text = String(format: "%.1f", 100 * hand.odds.fhRealOdds[3]) + "%"
            flush3Odds.text = String(format: "%.1f", 100 * hand.odds.flushRealOdds[0]) + "%"
            flush4Odds.text = String(format: "%.1f", 100 * hand.odds.flushRealOdds[1]) + "%"
            flush5Odds.text = String(format: "%.1f", 100 * hand.odds.flushRealOdds[2]) + "%"
            flush6Odds.text = String(format: "%.1f", 100 * hand.odds.flushRealOdds[3]) + "%"
            run3Odds.text = String(format: "%.1f", 100 * hand.odds.runRealOdds[0]) + "%"
            run4Odds.text = String(format: "%.1f", 100 * hand.odds.runRealOdds[1]) + "%"
            run5Odds.text = String(format: "%.1f", 100 * hand.odds.runRealOdds[2]) + "%"
            run6Odds.text = String(format: "%.1f", 100 * hand.odds.runRealOdds[3]) + "%"
            trips3Odds.text = String(format: "%.f", 100 * hand.odds.tripsRealOdds[0]) + "%"
            trips4Odds.text = String(format: "%.f", 100 * hand.odds.tripsRealOdds[1]) + "%"
            trips5Odds.text = String(format: "%.f", 100 * hand.odds.tripsRealOdds[2]) + "%"
            trips6Odds.text = String(format: "%.f", 100 * hand.odds.tripsRealOdds[3]) + "%"
            twoPair3Odds.text = String(format: "%.f", 100 * hand.odds.twopairRealOdds[0]) + "%"
            twoPair4Odds.text = String(format: "%.f", 100 * hand.odds.twopairRealOdds[1]) + "%"
            twopair5Odds.text = String(format: "%.f", 100 * hand.odds.twopairRealOdds[2]) + "%"
            twopair6Odds.text = String(format: "%.f", 100 * hand.odds.twopairRealOdds[3]) + "%"
            pair3Odds.text = String(format: "%.f", 100 * hand.odds.pairRealOdds[0]) + "%"
            pair4Odds.text = String(format: "%.f", 100 * hand.odds.pairRealOdds[1]) + "%"
            pair5Odds.text = String(format: "%.f", 100 * hand.odds.pairRealOdds[2]) + "%"
            pair6Odds.text = String(format: "%.f", 100 * hand.odds.pairRealOdds[3]) + "%"
            high3Odds.text = String(format: "%.f", 100 * hand.odds.highRealOdds[0]) + "%"
            high4Odds.text = String(format: "%.f", 100 * hand.odds.highRealOdds[1]) + "%"
            high5Odds.text = String(format: "%.f", 100 * hand.odds.highRealOdds[2]) + "%"
            high6Odds.text = String(format: "%.f", 100 * hand.odds.highRealOdds[3]) + "%"
            
            s3tot.text = String(format: "%.2f", hand.odds.highRealOdds[0] + hand.odds.pairRealOdds[0] + hand.odds.twopairRealOdds[0] + hand.odds.tripsRealOdds[0] + hand.odds.runRealOdds[0] + hand.odds.flushRealOdds[0] + hand.odds.fhRealOdds[0] + hand.odds.pokerRealOdds[0] + hand.odds.strafluRealOdds[0])
            s4tot.text = String(format: "%.2f", hand.odds.highRealOdds[1] + hand.odds.pairRealOdds[1] + hand.odds.twopairRealOdds[1]    + hand.odds.tripsRealOdds[1] + hand.odds.runRealOdds[1] + hand.odds.flushRealOdds[1] + hand.odds.fhRealOdds[1] + hand.odds.pokerRealOdds[1] + hand.odds.strafluRealOdds[1])
            s5tot.text = String(format: "%.2f", hand.odds.highRealOdds[2] + hand.odds.pairRealOdds[2] + hand.odds.twopairRealOdds[2] + hand.odds.tripsRealOdds[2] + hand.odds.runRealOdds[2] + hand.odds.flushRealOdds[2] + hand.odds.fhRealOdds[2] + hand.odds.pokerRealOdds[2] + hand.odds.strafluRealOdds[2])
            s6tot.text = String(format: "%.2f", hand.odds.highRealOdds[3] + hand.odds.pairRealOdds[3] + hand.odds.twopairRealOdds[3] + hand.odds.tripsRealOdds[3] + hand.odds.runRealOdds[3] + hand.odds.flushRealOdds[3] + hand.odds.fhRealOdds[3] + hand.odds.pokerRealOdds[3] + hand.odds.strafluRealOdds[3])
        }
        
    }

    public func populateOverlayPlayer() {
        straflu3Odds.textColor = UIColor.black
        straflu4Odds.textColor = UIColor.black
        straflu5Odds.textColor = UIColor.black
        
        straflu6Odds.textColor = UIColor.black
        
        poker3Odds.textColor = UIColor.black
        
        poker4Odds.textColor = UIColor.black
        
        poker5Odds.textColor = UIColor.black
        
        poker6Odds.textColor = UIColor.black
        
        fh3Odds.textColor = UIColor.black
        
        fh4Odds.textColor = UIColor.black
        
        fh5Odds.textColor = UIColor.black
        
        fh6Odds.textColor = UIColor.black
        
        flush3Odds.textColor = UIColor.black
        
        flush4Odds.textColor = UIColor.black
        
        flush5Odds.textColor = UIColor.black
        
        flush6Odds.textColor = UIColor.black
        
        run3Odds.textColor = UIColor.black
        
        run4Odds.textColor = UIColor.black
        
        run5Odds.textColor = UIColor.black
        
        run6Odds.textColor = UIColor.black
        
        trips3Odds.textColor = UIColor.black
        
        trips4Odds.textColor = UIColor.black
        
        trips5Odds.textColor = UIColor.black
        
        trips6Odds.textColor = UIColor.black
        
        twoPair3Odds.textColor = UIColor.black
        
        twoPair4Odds.textColor = UIColor.black
        
        twopair5Odds.textColor = UIColor.black
        twopair6Odds.textColor = UIColor.black
        pair3Odds.textColor = UIColor.black
        
        pair4Odds.textColor = UIColor.black
        
        pair5Odds.textColor = UIColor.black
        
        pair6Odds.textColor = UIColor.black
        
        high3Odds.textColor = UIColor.black
        
        high4Odds.textColor = UIColor.black
        
        high5Odds.textColor = UIColor.black
        
        high6Odds.textColor = UIColor.black
        
        switch game.oddsFormat {
        case "IP":
            popOverlayPercent()
        case "Dec":
            popOverlayDecimal()
        case "Fra":
            popOverlayFractional()
        case "Mon":
            popOverlayMoneyline()
        default:
            popOverlayPercent()
        }

        
        
    }
    
    public func popOverlayPercent() {
        if let hand = self.handItem {
            
            straflu3Odds.text = String(format: "%.2f", 100 * hand.odds.strafluOdds[0]) + "%"
            straflu4Odds.text = String(format: "%.2f", 100 * hand.odds.strafluOdds[1]) + "%"
            straflu5Odds.text = String(format: "%.2f", 100 * hand.odds.strafluOdds[2]) + "%"
            straflu6Odds.text = String(format: "%.2f", 100 * hand.odds.strafluOdds[3]) + "%"
            poker3Odds.text = String(format: "%.2f", 100 * hand.odds.pokerOdds[0]) + "%"
            poker4Odds.text = String(format: "%.2f", 100 * hand.odds.pokerOdds[1]) + "%"
            poker5Odds.text = String(format: "%.2f", 100 * hand.odds.pokerOdds[2]) + "%"
            poker6Odds.text = String(format: "%.2f", 100 * hand.odds.pokerOdds[3]) + "%"
            fh3Odds.text = String(format: "%.1f", 100 * hand.odds.fhOdds[0]) + "%"
            fh4Odds.text = String(format: "%.1f", 100 * hand.odds.fhOdds[1]) + "%"
            fh5Odds.text = String(format: "%.1f", 100 * hand.odds.fhOdds[2]) + "%"
            fh6Odds.text = String(format: "%.1f", 100 * hand.odds.fhOdds[3]) + "%"
            flush3Odds.text = String(format: "%.1f", 100 * hand.odds.flushOdds[0]) + "%"
            flush4Odds.text = String(format: "%.1f", 100 * hand.odds.flushOdds[1]) + "%"
            flush5Odds.text = String(format: "%.1f", 100 * hand.odds.flushOdds[2]) + "%"
            flush6Odds.text = String(format: "%.1f", 100 * hand.odds.flushOdds[3]) + "%"
            run3Odds.text = String(format: "%.1f", 100 * hand.odds.runOdds[0]) + "%"
            run4Odds.text = String(format: "%.1f", 100 * hand.odds.runOdds[1]) + "%"
            run5Odds.text = String(format: "%.1f", 100 * hand.odds.runOdds[2]) + "%"
            run6Odds.text = String(format: "%.1f", 100 * hand.odds.runOdds[3]) + "%"
            trips3Odds.text = String(format: "%.f", 100 * hand.odds.tripsOdds[0]) + "%"
            trips4Odds.text = String(format: "%.f", 100 * hand.odds.tripsOdds[1]) + "%"
            trips5Odds.text = String(format: "%.f", 100 * hand.odds.tripsOdds[2]) + "%"
            trips6Odds.text = String(format: "%.f", 100 * hand.odds.tripsOdds[3]) + "%"
            twoPair3Odds.text = String(format: "%.f", 100 * hand.odds.twopairOdds[0]) + "%"
            twoPair4Odds.text = String(format: "%.f", 100 * hand.odds.twopairOdds[1]) + "%"
            twopair5Odds.text = String(format: "%.f", 100 * hand.odds.twopairOdds[2]) + "%"
            twopair6Odds.text = String(format: "%.f", 100 * hand.odds.twopairOdds[3]) + "%"
            pair3Odds.text = String(format: "%.f", 100 * hand.odds.pairOdds[0]) + "%"
            pair4Odds.text = String(format: "%.f", 100 * hand.odds.pairOdds[1]) + "%"
            pair5Odds.text = String(format: "%.f", 100 * hand.odds.pairOdds[2]) + "%"
            pair6Odds.text = String(format: "%.f", 100 * hand.odds.pairOdds[3]) + "%"
            high3Odds.text = String(format: "%.f", 100 * hand.odds.highOdds[0]) + "%"
            high4Odds.text = String(format: "%.f", 100 * hand.odds.highOdds[1]) + "%"
            high5Odds.text = String(format: "%.f", 100 * hand.odds.highOdds[2]) + "%"
            high6Odds.text = String(format: "%.f", 100 * hand.odds.highOdds[3]) + "%"
            let s3 = hand.odds.highOdds[0] + hand.odds.pairOdds[0] + hand.odds.twopairOdds[0] + hand.odds.tripsOdds[0] + hand.odds.runOdds[0] + hand.odds.flushOdds[0] + hand.odds.fhOdds[0] + hand.odds.pokerOdds[0] + hand.odds.strafluOdds[0]
            let s4 = hand.odds.highOdds[1] + hand.odds.pairOdds[1] + hand.odds.twopairOdds[1]    + hand.odds.tripsOdds[1] + hand.odds.runOdds[1] + hand.odds.flushOdds[1] + hand.odds.fhOdds[1] + hand.odds.pokerOdds[1] + hand.odds.strafluOdds[1]
            let s5 = hand.odds.highOdds[2] + hand.odds.pairOdds[2] + hand.odds.twopairOdds[2] + hand.odds.tripsOdds[2] + hand.odds.runOdds[2] + hand.odds.flushOdds[2] + hand.odds.fhOdds[2] + hand.odds.pokerOdds[2] + hand.odds.strafluOdds[2]
            let s6 = hand.odds.highOdds[3] + hand.odds.pairOdds[3] + hand.odds.twopairOdds[3] + hand.odds.tripsOdds[3] + hand.odds.runOdds[3] + hand.odds.flushOdds[3] + hand.odds.fhOdds[3] + hand.odds.pokerOdds[3] + hand.odds.strafluOdds[3]
            
            s3tot.text = String(format: "%.1f", s3*100)
            s4tot.text = String(format: "%.1f", s4*100)
            s5tot.text = String(format: "%.1f", s5*100)
            s6tot.text = String(format: "%.1f", s6*100)
        }
        
        
    }
    
    
    public func popOverlayDecimal() {
        if let hand = self.handItem {
            
            straflu3Odds.text = cvIP_Dec(pc: hand.odds.strafluOdds[0])
            straflu4Odds.text = cvIP_Dec(pc: hand.odds.strafluOdds[1])
            straflu5Odds.text = cvIP_Dec(pc: hand.odds.strafluOdds[2])
            straflu6Odds.text = cvIP_Dec(pc: hand.odds.strafluOdds[3])
            poker3Odds.text = cvIP_Dec(pc:  hand.odds.pokerOdds[0])
            poker4Odds.text = cvIP_Dec(pc:  hand.odds.pokerOdds[1])
            poker5Odds.text = cvIP_Dec(pc:  hand.odds.pokerOdds[2])
            poker6Odds.text = cvIP_Dec(pc:  hand.odds.pokerOdds[3])
            fh3Odds.text = cvIP_Dec(pc:  hand.odds.fhOdds[0])
            fh4Odds.text = cvIP_Dec(pc:  hand.odds.fhOdds[1])
            fh5Odds.text = cvIP_Dec(pc:  hand.odds.fhOdds[2])
            fh6Odds.text = cvIP_Dec(pc:  hand.odds.fhOdds[3])
            flush3Odds.text = cvIP_Dec(pc:  hand.odds.flushOdds[0])
            flush4Odds.text = cvIP_Dec(pc:  hand.odds.flushOdds[1])
            flush5Odds.text = cvIP_Dec(pc:  hand.odds.flushOdds[2])
            flush6Odds.text = cvIP_Dec(pc:  hand.odds.flushOdds[3])
            run3Odds.text = cvIP_Dec(pc:  hand.odds.runOdds[0])
            run4Odds.text = cvIP_Dec(pc:  hand.odds.runOdds[1])
            run5Odds.text = cvIP_Dec(pc:  hand.odds.runOdds[2])
            run6Odds.text = cvIP_Dec(pc:  hand.odds.runOdds[3])
            trips3Odds.text = cvIP_Dec(pc:  hand.odds.tripsOdds[0])
            trips4Odds.text = cvIP_Dec(pc:  hand.odds.tripsOdds[1])
            trips5Odds.text = cvIP_Dec(pc:  hand.odds.tripsOdds[2])
            trips6Odds.text = cvIP_Dec(pc:  hand.odds.tripsOdds[3])
            twoPair3Odds.text = cvIP_Dec(pc: hand.odds.twopairOdds[0])
            twoPair4Odds.text = cvIP_Dec(pc: hand.odds.twopairOdds[1])
            twopair5Odds.text = cvIP_Dec(pc: hand.odds.twopairOdds[2])
            twopair6Odds.text = cvIP_Dec(pc: hand.odds.twopairOdds[3])
            pair3Odds.text = cvIP_Dec(pc:  hand.odds.pairOdds[0])
            pair4Odds.text = cvIP_Dec(pc:  hand.odds.pairOdds[1])
            pair5Odds.text = cvIP_Dec(pc:  hand.odds.pairOdds[2])
            pair6Odds.text = cvIP_Dec(pc:  hand.odds.pairOdds[3])
            high3Odds.text = cvIP_Dec(pc:  hand.odds.highOdds[0])
            high4Odds.text = cvIP_Dec(pc:  hand.odds.highOdds[1])
            high5Odds.text = cvIP_Dec(pc:  hand.odds.highOdds[2])
            high6Odds.text = cvIP_Dec(pc:  hand.odds.highOdds[3])
        }
        
    }
    
    public func popOverlayFractional() {
        if let hand = self.handItem {
            
            straflu3Odds.text = cvIP_Fra(pc: hand.odds.strafluOdds[0])
            straflu4Odds.text = cvIP_Fra(pc: hand.odds.strafluOdds[1])
            straflu5Odds.text = cvIP_Fra(pc: hand.odds.strafluOdds[2])
            straflu6Odds.text = cvIP_Fra(pc: hand.odds.strafluOdds[3])
            poker3Odds.text = cvIP_Fra(pc:  hand.odds.pokerOdds[0])
            poker4Odds.text = cvIP_Fra(pc:  hand.odds.pokerOdds[1])
            poker5Odds.text = cvIP_Fra(pc:  hand.odds.pokerOdds[2])
            poker6Odds.text = cvIP_Fra(pc:  hand.odds.pokerOdds[3])
            fh3Odds.text = cvIP_Fra(pc:  hand.odds.fhOdds[0])
            fh4Odds.text = cvIP_Fra(pc:  hand.odds.fhOdds[1])
            fh5Odds.text = cvIP_Fra(pc:  hand.odds.fhOdds[2])
            fh6Odds.text = cvIP_Fra(pc:  hand.odds.fhOdds[3])
            flush3Odds.text = cvIP_Fra(pc:  hand.odds.flushOdds[0])
            flush4Odds.text = cvIP_Fra(pc:  hand.odds.flushOdds[1])
            flush5Odds.text = cvIP_Fra(pc:  hand.odds.flushOdds[2])
            flush6Odds.text = cvIP_Fra(pc:  hand.odds.flushOdds[3])
            run3Odds.text = cvIP_Fra(pc:  hand.odds.runOdds[0])
            run4Odds.text = cvIP_Fra(pc:  hand.odds.runOdds[1])
            run5Odds.text = cvIP_Fra(pc:  hand.odds.runOdds[2])
            run6Odds.text = cvIP_Fra(pc:  hand.odds.runOdds[3])
            trips3Odds.text = cvIP_Fra(pc:  hand.odds.tripsOdds[0])
            trips4Odds.text = cvIP_Fra(pc:  hand.odds.tripsOdds[1])
            trips5Odds.text = cvIP_Fra(pc:  hand.odds.tripsOdds[2])
            trips6Odds.text = cvIP_Fra(pc:  hand.odds.tripsOdds[3])
            twoPair3Odds.text = cvIP_Fra(pc: hand.odds.twopairOdds[0])
            twoPair4Odds.text = cvIP_Fra(pc: hand.odds.twopairOdds[1])
            twopair5Odds.text = cvIP_Fra(pc: hand.odds.twopairOdds[2])
            twopair6Odds.text = cvIP_Fra(pc: hand.odds.twopairOdds[3])
            pair3Odds.text = cvIP_Fra(pc:  hand.odds.pairOdds[0])
            pair4Odds.text = cvIP_Fra(pc:  hand.odds.pairOdds[1])
            pair5Odds.text = cvIP_Fra(pc:  hand.odds.pairOdds[2])
            pair6Odds.text = cvIP_Fra(pc:  hand.odds.pairOdds[3])
            high3Odds.text = cvIP_Fra(pc:  hand.odds.highOdds[0])
            high4Odds.text = cvIP_Fra(pc:  hand.odds.highOdds[1])
            high5Odds.text = cvIP_Fra(pc:  hand.odds.highOdds[2])
            high6Odds.text = cvIP_Fra(pc:  hand.odds.highOdds[3])
        }
        
    }
    
    public func popOverlayMoneyline() {
        if let hand = self.handItem {
            
            straflu3Odds.text = cvIP_Mon(pc: hand.odds.strafluOdds[0])
            straflu4Odds.text = cvIP_Mon(pc: hand.odds.strafluOdds[1])
            straflu5Odds.text = cvIP_Mon(pc: hand.odds.strafluOdds[2])
            straflu6Odds.text = cvIP_Mon(pc: hand.odds.strafluOdds[3])
            poker3Odds.text = cvIP_Mon(pc:  hand.odds.pokerOdds[0])
            poker4Odds.text = cvIP_Mon(pc:  hand.odds.pokerOdds[1])
            poker5Odds.text = cvIP_Mon(pc:  hand.odds.pokerOdds[2])
            poker6Odds.text = cvIP_Mon(pc:  hand.odds.pokerOdds[3])
            fh3Odds.text = cvIP_Mon(pc:  hand.odds.fhOdds[0])
            fh4Odds.text = cvIP_Mon(pc:  hand.odds.fhOdds[1])
            fh5Odds.text = cvIP_Mon(pc:  hand.odds.fhOdds[2])
            fh6Odds.text = cvIP_Mon(pc:  hand.odds.fhOdds[3])
            flush3Odds.text = cvIP_Mon(pc:  hand.odds.flushOdds[0])
            flush4Odds.text = cvIP_Mon(pc:  hand.odds.flushOdds[1])
            flush5Odds.text = cvIP_Mon(pc:  hand.odds.flushOdds[2])
            flush6Odds.text = cvIP_Mon(pc:  hand.odds.flushOdds[3])
            run3Odds.text = cvIP_Mon(pc:  hand.odds.runOdds[0])
            run4Odds.text = cvIP_Mon(pc:  hand.odds.runOdds[1])
            run5Odds.text = cvIP_Mon(pc:  hand.odds.runOdds[2])
            run6Odds.text = cvIP_Mon(pc:  hand.odds.runOdds[3])
            trips3Odds.text = cvIP_Mon(pc:  hand.odds.tripsOdds[0])
            trips4Odds.text = cvIP_Mon(pc:  hand.odds.tripsOdds[1])
            trips5Odds.text = cvIP_Mon(pc:  hand.odds.tripsOdds[2])
            trips6Odds.text = cvIP_Mon(pc:  hand.odds.tripsOdds[3])
            twoPair3Odds.text = cvIP_Mon(pc: hand.odds.twopairOdds[0])
            twoPair4Odds.text = cvIP_Mon(pc: hand.odds.twopairOdds[1])
            twopair5Odds.text = cvIP_Mon(pc: hand.odds.twopairOdds[2])
            twopair6Odds.text = cvIP_Mon(pc: hand.odds.twopairOdds[3])
            pair3Odds.text = cvIP_Mon(pc:  hand.odds.pairOdds[0])
            pair4Odds.text = cvIP_Mon(pc:  hand.odds.pairOdds[1])
            pair5Odds.text = cvIP_Mon(pc:  hand.odds.pairOdds[2])
            pair6Odds.text = cvIP_Mon(pc:  hand.odds.pairOdds[3])
            high3Odds.text = cvIP_Mon(pc:  hand.odds.highOdds[0])
            high4Odds.text = cvIP_Mon(pc:  hand.odds.highOdds[1])
            high5Odds.text = cvIP_Mon(pc:  hand.odds.highOdds[2])
            high6Odds.text = cvIP_Mon(pc:  hand.odds.highOdds[3])
        }
        
    }
    
    public func cvIP_Dec(pc: Double)-> String {
        if pc == 0 {
            return("-")
        }
        let pc100 = pc * 100
        print("cvIP_Dec: percent = \(pc100)")
        var ans: Double = 100/pc100
        if ans > 9999 {
            ans = 9999
        }
        print("cvIP_Dec: converted raw = \(pc100)")

        let retStr = String(format: "%.1f", ans)
        print("cvIP_Dec: returned \(retStr)")

        return(retStr)
    }

    
    public func cvIP_Fra(pc: Double)-> String {
        if pc == 0 {
            return("-")
        }
        let pc100 = pc * 100
        print("cvIP_Fra: percent = \(pc100)")
        var ans: Double = 100/pc100
        ans -= 1
        if ans > 9999 {
            ans = 9999
        }
        print("cvIP_Fra: converted raw = \(pc100)")
        
        let retStr = String(format: "%.f", ans) + "/1"
        print("cvIP_Fra: returned \(retStr)")
        
        return(retStr)
    }

    public func cvIP_Mon(pc: Double)-> String {
        if pc == 0 {
            return("-")
        }
        print("cvIP_Mon: unconverted pc = \(pc)")

        var ans = Double()
        let pc100 : Double = pc * 100
        print("cvIP_Mon: converted raw = \(pc100)")

        if pc100 > 50 {
            ans = 100-pc100
            print("cvIP_Mon Greater than 50: ans 1: \(ans)")
            
            ans = pc100/ans
            print("cvIP_Mon Greater than 50: ans 2: \(ans)")

            ans = ans * 100
            print("cvIP_Mon Greater than 50: ans 3: \(ans)")
            if ans > 9999 {
                ans = 9999
            }
            let retStr = String(format: "-%.f", ans)
            print("cvIP_Mon: returned \(retStr)")
            return(retStr)
        } else {
            ans = 100-pc100
            print("cvIP_Mon Less than 50: ans 1: \(ans)")
            ans = ans/pc100
            print("cvIP_Mon Less than 50: ans 2: \(ans)")

            ans = ans * 100
            print("cvIP_Mon Less than 50: ans 3: \(ans)")
            if ans > 9999 {
                ans = 9999
            }
            let retStr = String(format: "+%.f", ans)
            print("cvIP_Mon: returned \(retStr)")
            return(retStr)
        }
        
     /*   var ans: Double = 100/pc100
        ans -= 1
        if ans > 9999 {
            ans = 9999
        }
        
        let retStr = String(format: "%.f", ans) + "/1"
        print("cvIP_Mon: returned \(retStr)") */
        
   
    }
    
     override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     
     self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 250)
     
     self.view.layer.cornerRadius = 5
        
     
     }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    private func getAbbr(card : Card) -> String {
        let fc = faceAbbr[card.face]
        let st = suitSym[card.suit]

        return(fc! + st!)
    }
    
    
    
    internal func presentSubscriptionAlert(functionality: String) {
        let alert = UIAlertController(title: "Sorry but \(functionality) is available only to Pro users. ", message: "You may access a host of features when you go Pro:\n\n\tPerspective Switch\n\tChange to your favoured Odds format\n\tChange upcoming cards\n\tSave & reload games\n\tName Players\n\tHide odds on main screen).\n\nGo to the subscription screen to see your status?", preferredStyle: .alert)
        
        let actionLoad = UIAlertAction(title: "Go", style: .default) { (action) in
            print("Pref alert selected Go")
            self.performSegue(withIdentifier: "oddsToSubSeque", sender: self)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            print("Pref alert selected Cancel")
            
        }
        alert.addAction(actionLoad)
        alert.addAction(actionCancel)
        
        //        alert.addTextField { (field) in
        //            textField = field
        //            textField.placeholder = "Add a new category"
        //       }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.verticalSizeClass == .compact {
            print("ovc: orientation is Landscape")
            
        } else {
            print("ovc: orientation is \(newCollection.verticalSizeClass)")
            
        }
    }
    
    /*@IBAction func closePressed(_ sender: AnyObject) {
     presentingViewController?.dismiss(animated: true, completion: nil)
     }*/
  
}
