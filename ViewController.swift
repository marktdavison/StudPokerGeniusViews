//
//  ViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 28/05/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyStoreKit


//public class Game


public var game = Game()

//////////////////////////////////////
/*
 ViewController creates key UI objects and variables many of which need to be cleansed
 - activeCards array
 - Cards - but this is static and can remain as is
 - PnCards - I think these could now be removed
 - PnBest - these need to be cleared
 - Players Int
 - AllPlayers array
 - cardImage/n not sure I need to change this
 - nextCard - needs reset
 - pnOptions/ActualHand - already reset
 - DisplayCard and its properties
 
 
 
 
 
 the following appear not to be used
 - tv
 - handOrder
 - backgroundImageLayer
 - count
 - max
 - play
 - timer
 
 
 
 */


public  class ViewController: UIViewController, SideMenuDelegate,  UIGestureRecognizerDelegate,  UIAdaptivePresentationControllerDelegate {
 
    @IBOutlet weak var reloadedBanner: UILabel!
    
    public override func viewDidAppear(_ animated: Bool) {
        print("Fave: This is View DID APPPEEEEAAAAAH")
        if !game.initialAnimationPlayed {
            animateDealtCards()
        }
        if game.state == "loadingFavourite" {
            outletShuffle.setTitle("Deal", for: UIControlState.normal)
            outletHitMe.alpha = 0
            outletShuffle.alpha = 1
            game.doNotShuffle = true
            game.state = "init"
            animateAbort()
            print("Fave: game state changed to init")
        } else {
            outletShuffle.setTitle("Shuffle & Deal", for: UIControlState.normal)
            print("Fave: in viewDidAppear but NOT loading favourite this time")
        }
        if game.mainScreenOddsHidden == true {
            for l in game.mainScreenOddsLabels {
                l.alpha = 0
            }
        } else {
                for l in game.mainScreenOddsLabels {
                    l.alpha = 1
                }
            }
        }
    
    internal func didSelectMenuItem(withTitle title: String, index: Int) {
        print("In didSelectMenuItem of ViewController \(title)")
        if title == "Settings" {
            performSegue(withIdentifier: "prefSeque", sender: self)
        }
        if title == "Deck" {
            performSegue(withIdentifier: "deckSeque", sender: self)
        }
        if title == "Calculator" {
            performSegue(withIdentifier: "ffSeque", sender: self)
        }
        if title == "Replace Card" {
            performSegue(withIdentifier: "insertSeque", sender: self)
        }
        if title == "Favourites" {
            print("Faves: In Favourites sidemenu handler")

            performSegue(withIdentifier: "favouritesSeque", sender: self)
        }
        if title == "About" {
            performSegue(withIdentifier: "aboutSeque", sender: self)
        }
        if title == "Abort Game" {
            clearUp()
        } 
        if title == "System" {
            performSegue(withIdentifier: "sysinfoSeque", sender: self)
        }
        if title == "Subscriptions" {
            performSegue(withIdentifier: "subSeque", sender: self)
        }
    }
    
    
    @IBOutlet weak var starterLabel: UILabel!
    
    
//    public var activeCards: [DisplayedCard] = []
    
    let transitionDelegate = TransitionDelegate()

 //   public var upCards : [Card] = []
 //   public var dealtCards : [Card] = []

    @IBAction func buttonShuffleAnddeal(_ sender: UIButton) {

        shuffleAndDeal()
           //    Main.shuffle()
    }
    
    @IBOutlet weak var tv: UITextView!
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        print("Faves: In Add to Favourites IBAction")
        outletAddToFavourites.alpha = 0
        let favDeck = game.myDeckOfCards.deck.map{$0.getOrder}
        let df = DateFormatter()
        df.dateStyle = .medium
        let df2 = DateFormatter()
        df2.timeStyle = .medium
        let dateString = df.string(from: Date())
        let timeString = df2.string(from: Date())
        let cellContents = Data2()
        cellContents.winningHand = game.winningHand
        cellContents.handTime = dateString + " " + timeString
        for o in favDeck {
            cellContents.faveDeck.append(o)
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(cellContents)
            }
            let alert = UIAlertController(title: "Favourite Saved!", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } catch {
            print("Error initialising new Realm \(error)")
        }
        
 /*       if let faves = UserDefaults.standard.object(forKey: "favourites") as? [[Card]] {
            print("Faves: was able to Get stored data")
            
            var storedData = faves
            let count = faves.count
            let newEntryHand = game.winningHand
            let newEntryTime = dateString + " " + timeString

            storedData.append(favDeck)
            UserDefaults.standard.set(storedData, forKey: "favourites")
            print("vc faves = \(faves)")
            
        } else {
            let concatTime = dateString + timeString
 //           let storedData = [(game.winningHand, concatTime)]
            let storedData = [favDeck]

            print("Faves: prepping to write first UD record: \(game.winningHand), \(concatTime), \(storedData)")

           UserDefaults.standard.set(storedData, forKey: "favourites")
           print("Faves: was NOT able to Get stored data")
            
        } */
    }
    
    @IBOutlet weak var outletAddToFavourites: UIButton!
    
    @IBAction func blurit(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let ovc = sb.instantiateViewController(withIdentifier: "Overlay") as! OddsViewController
        transitioningDelegate = transitionDelegate
        ovc.transitioningDelegate = transitionDelegate
        ovc.modalPresentationStyle = .custom
   //     ovc.preferredContentSize = CGSize(200, 100)
     //   ovc.modalTransitionStyle = .flipHorizontal
        let hand = allPlayers[0].playerHand
        self.present(ovc, animated: true, completion: nil)
        ovc.handItem = hand
        
        
     /*   let ovc = OddsViewController(nibName: "OddsViewController", bundle: nil)
        ovc.modalPresentationStyle = .popover
     //   ovc.modalTransitionStyle = .flipHorizontal
        ovc.preferredContentSize = .init(width: 20, height: 20)
 
        self.present(ovc, animated:  true, completion: nil)
        if let pop = ovc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        } */
        
        
      /*  let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        tv.alpha = 1 */

    }
    
    @IBAction func buttonHitMe(_ sender: UIButton) {
        hitMe()
    }
    
    let handOrder = ["High Card", "Pair", "Two Pair", "Trips", "Straight", "Flush", "Full House", "Poker", "Straight Flush", "Royal Flush"]
    
 //   let cardOrder = ["Ace","Deuce","Trip","Four","Five","Six","Seven","Eight","Nine","Ten","Jack","Queen", "King","Ace"]
    
    
    let Cards = [
        /// note to self originslly yhr order was hearts, spades clubs diamonds.  I dont think the orde wsa important so I think I am ok to move it to match with the order the cards are created in
        
        "AceHearts": (#imageLiteral(resourceName: "ace_of_hearts"), "Ace", "Hearts"),
        "DeuceHearts": (#imageLiteral(resourceName: "2_of_hearts"), "Deuce", "Hearts"),
        "TripHearts": (#imageLiteral(resourceName: "3_of_hearts"), "Trip", "Hearts"),
        "FourHearts": (#imageLiteral(resourceName: "4_of_hearts"), "Four", "Hearts"),
        "FiveHearts": (#imageLiteral(resourceName: "5_of_hearts"), "Five", "Hearts"),
        "SixHearts": (#imageLiteral(resourceName: "6_of_hearts"), "Six", "Hearts"),
        "SevenHearts": (#imageLiteral(resourceName: "7_of_hearts"), "Seven", "Hearts"),
        "EightHearts": (#imageLiteral(resourceName: "8_of_hearts"), "Eight", "Hearts"),
        "NineHearts": (#imageLiteral(resourceName: "9_of_hearts"), "Nine", "Hearts"),
        "TenHearts": (#imageLiteral(resourceName: "10_of_hearts"), "Ten", "Hearts"),
        "JackHearts": (#imageLiteral(resourceName: "jack_of_hearts"), "Jack", "Hearts"),
        "QueenHearts": (#imageLiteral(resourceName: "queen_of_hearts"), "Queen", "Hearts"),
        "KingHearts": (#imageLiteral(resourceName: "king_of_hearts"), "King", "Hearts"),

        "AceDiamonds": (#imageLiteral(resourceName: "ace_of_diamonds"), "Ace", "Diamonds"),
        "DeuceDiamonds": (#imageLiteral(resourceName: "2_of_diamonds"), "Deuce", "Diamonds"),
        "TripDiamonds": (#imageLiteral(resourceName: "3_of_diamonds"), "Trip", "Diamonds"),
        "FourDiamonds": (#imageLiteral(resourceName: "4_of_diamonds"), "Four", "Diamonds"),
        "FiveDiamonds": (#imageLiteral(resourceName: "5_of_diamonds"), "Five", "Diamonds"),
        "SixDiamonds": (#imageLiteral(resourceName: "6_of_diamonds"), "Six", "Diamonds"),
        "SevenDiamonds": (#imageLiteral(resourceName: "7_of_diamonds"), "Seven", "Diamonds"),
        "EightDiamonds": (#imageLiteral(resourceName: "8_of_diamonds"), "Eight", "Diamonds"),
        "NineDiamonds": (#imageLiteral(resourceName: "9_of_diamonds"), "Nine", "Diamonds"),
        "TenDiamonds": (#imageLiteral(resourceName: "10_of_diamonds"), "Ten", "Diamonds"),
        "JackDiamonds": (#imageLiteral(resourceName: "jack_of_diamonds"), "Jack", "Diamonds"),
        "QueenDiamonds": (#imageLiteral(resourceName: "queen_of_diamonds"), "Queen", "Diamonds"),
        "KingDiamonds": (#imageLiteral(resourceName: "king_of_diamonds"), "King", "Diamonds"),
        
        "AceClubs": (#imageLiteral(resourceName: "ace_of_clubs"), "Ace", "Clubs"),
        "DeuceClubs": (#imageLiteral(resourceName: "2_of_clubs"), "Deuce", "Clubs"),
        "TripClubs": (#imageLiteral(resourceName: "3_of_clubs"), "Trip", "Clubs"),
        "FourClubs": (#imageLiteral(resourceName: "4_of_clubs"), "Four", "Clubs"),
        "FiveClubs": (#imageLiteral(resourceName: "5_of_clubs"), "Five", "Clubs"),
        "SixClubs": (#imageLiteral(resourceName: "6_of_clubs"), "Six", "Clubs"),
        "SevenClubs": (#imageLiteral(resourceName: "7_of_clubs"), "Seven", "Clubs"),
        "EightClubs": (#imageLiteral(resourceName: "8_of_clubs"), "Eight", "Clubs"),
        "NineClubs": (#imageLiteral(resourceName: "9_of_clubs"), "Nine", "Clubs"),
        "TenClubs": (#imageLiteral(resourceName: "10_of_clubs"), "10Ten", "Clubs"),
        "JackClubs": (#imageLiteral(resourceName: "jack_of_clubs"), "Jack", "Clubs"),
        "QueenClubs": (#imageLiteral(resourceName: "queen_of_clubs"), "Queen", "Clubs"),
        "KingClubs": (#imageLiteral(resourceName: "king_of_clubs"), "King", "Clubs"),
        
        "AceSpades": (#imageLiteral(resourceName: "ace_of_spades"), "Ace", "Spades"),
        "DeuceSpades": (#imageLiteral(resourceName: "2_of_spades"), "Deuce", "Spades"),
        "TripSpades": (#imageLiteral(resourceName: "3_of_spades"), "Trip", "Spades"),
        "FourSpades": (#imageLiteral(resourceName: "4_of_spades"), "Four", "Spades"),
        "FiveSpades": (#imageLiteral(resourceName: "5_of_spades"), "Five", "Spades"),
        "SixSpades": (#imageLiteral(resourceName: "6_of_spades"), "Six", "Spades"),
        "SevenSpades": (#imageLiteral(resourceName: "7_of_spades"), "Seven", "Spades"),
        "EightSpades": (#imageLiteral(resourceName: "8_of_spades"), "Eight", "Spades"),
        "NineSpades": (#imageLiteral(resourceName: "9_of_spades"), "Nine", "Spades"),
        "TenSpades": (#imageLiteral(resourceName: "10_of_spades"), "Ten", "Spades"),
        "JackSpades": (#imageLiteral(resourceName: "jack_of_spades"), "Jack", "Spades"),
        "QueenSpades": (#imageLiteral(resourceName: "queen_of_spades"), "Queen", "Spades"),
        "KingSpades": (#imageLiteral(resourceName: "king_of_spades"), "King", "Spades")
    
    
        ]

    @IBOutlet weak var outletHitMe: UIButton!
    @IBOutlet weak var outletShuffle: UIButton!
    /*
    @IBOutlet weak var p1Cards: UILabel!
    
    @IBOutlet weak var p2Cards: UILabel!
    
    @IBOutlet weak var p3Cards: UILabel!
    
    @IBOutlet weak var p4Cards: UILabel!
    
    
    @IBOutlet weak var p1Best: UILabel!
    
    @IBOutlet weak var p2Best: UILabel!
    
    @IBOutlet weak var p3Best: UILabel!
    
    @IBOutlet weak var p4Best: UILabel!
    
    @IBOutlet weak var p1Label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var p3Label: UILabel!
    @IBOutlet weak var p4Label: UILabel!
    */
    
   // public var players: Int = 4
    
    var allPlayers: [Player] = []
    
    var backgroundImageLayer: CAShapeLayer!
    
    var cardImage: UIImageView!

    var cardImage2: UIImageView!

    var cardImage3: UIImageView!
    var cardImage4: UIImageView!
    var cardImage5: UIImageView!
    
    public var nextCard: Int = 1
    
    var count = 1
    let max = 23
    var play = true
    var timer = Timer()
    var shifted : Bool = false
    var origXY = CGPoint()
    var origY = CGPoint()
    
    public func buildScreenObjects(anchors: [CGPoint]) -> [[UILabel]]{
        var wide = Int()
        var high = Int()
        
        if game.inPortrait {
            wide = game.portraitWidth
            high = game.portraitHeight
        } else {
            wide = game.landscapeWidth
            high = game.landscapeHeight
        }
        let adjOptX = Int(wide / 60) // 5
        let adjOptY = Int(Double(high) / 3.3) //200
        let adjActX = 0
        let adjActY = Int(high / 20) //25
        let adjCardX = -Int(wide / 7) // - 50
        let adjCardY = Int(high / 4) // 120
        var counter : Int = 0
        var playerLabels = [UILabel]()
        var allLabels : [[UILabel]] = []
        for a in anchors {
            playerLabels = []
            let l : UILabel = UILabel()
            counter += 1
            l.frame = CGRect(x: a.x, y: a.y, width: 200, height: 60)
            l.textColor = UIColor.white
            l.textAlignment = NSTextAlignment.left
        //    l.text = "Player \(counter)"
            l.text = game.playerNames[counter - 1]
            self.view.addSubview(l)
            playerLabels.append(l)
            
            let o : UILabel =    UILabel()
            o.frame = CGRect(x: Int(a.x) + adjOptX, y: Int(a.y) + adjOptY, width: 200, height: 50)
          //  o.backgroundColor = UIColor.orange
            o.textColor = UIColor.white
            o.numberOfLines = 3
            o.textAlignment = NSTextAlignment.left
            o.text = "Some options"
            o.font = UIFont(name: "Helvetica", size: 7)
            self.view.insertSubview(o, belowSubview: self.view)
         //   self.view.addSubview(o)
           // self.view.sendSubview(toBack: o)
            playerLabels.append(o)
            game.mainScreenOddsLabels.append(o)
            let act : UILabel = UILabel()
            act.frame = CGRect(x: Int(a.x) + adjActX, y: Int(a.y) + adjActY, width: 200, height: 50)
         //   act.backgroundColor = UIColor.purple
            act.textColor = UIColor.white
            act.alpha = 1
            act.textAlignment = NSTextAlignment.left
            act.text = "actual stuff"
            act.font = UIFont(name: "Helvetica", size: 7)
            self.view.addSubview(act)
            playerLabels.append(act)
            game.mainScreenOddsLabels.append(act)

            let b : UILabel = UILabel()
            b.frame = CGRect(x: Int(a.x) + adjActX, y: Int(a.y) + adjActY, width: 200, height: 28)
      //      b.backgroundColor = UIColor.cyan
            b.textColor = UIColor.white
            b.textAlignment = NSTextAlignment.left
            b.font = UIFont(name: "Helvetica", size: 11)
            b.text = "Bestest stuff"
            self.view.addSubview(b)
            playerLabels.append(b)
            allLabels.append(playerLabels)
            game.mainScreenOddsLabels.append(b)

        }
        game.screenObjectsBuilt = true
        
        print(allLabels[0][1].text)
     //   game.mainScreenLabels = allLabels
        return allLabels
    }
    
    public func moveScreenObjectsToPortrait(anchors: [CGPoint]) {
        let adjLWidth = 50
        let adjLHeight = 30
        let adjOWidth = 60
        let adjOHeight = 25
        let adjBWidth = 68
        let adjBHeight = 14
        let adjCardWidth = 30
        let adjCardHeigth = 45
        
        let adjOptX = Int(game.portraitWidth / 60) // 5
        let adjOptY = Int(Double(game.portraitHeight) / 3.3) //200
        let adjActX = 0
        let adjActY = Int(game.portraitHeight / 20) //25
        let adjCardX = Int(game.portraitWidth / 7) // - 50
        let adjCardY = Int(Double(game.portraitHeight) / 4.3) // 120
        var counter : Int = 0
        
        print("Moving screen objects: Dimensions of this screen: Height \(game.portraitHeight), Width \(game.portraitWidth). )")
        if !game.screenObjectsBuilt {
            print("Screen Objects Not Built yet")
            return
        }
        //     cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        
        UIView.animate(withDuration: 1) {
            print("In Animation")
            for p in 0...game.players - 1 {
                print("Player \(p), x anchor: \(anchors[p].x), y anchor: anchors[p].y")
                game.playingScreenObjects[p][0].center = CGPoint(x: Int(anchors[p].x) + adjLWidth, y: Int(anchors[p].y) + adjLHeight)
                //    game.playingScreenObjects[p][1].center = CGPoint(x: 200, y: 100)
                game.playingScreenObjects[p][1].center = CGPoint(x: Int(anchors[p].x) + adjOptX + adjOWidth, y: Int(anchors[p].y) + adjOptY + adjOHeight)
                game.playingScreenObjects[p][2].center = CGPoint(x: Int(anchors[p].x) + adjActX + adjOWidth, y: Int(anchors[p].y) + adjActY + adjOHeight)
                game.playingScreenObjects[p][3].center = CGPoint(x: Int(anchors[p].x) + adjActX + adjBWidth, y: Int(anchors[p].y) + adjActY + adjBHeight)
                
                for ac in self.activeCards {
                    var fan : CGFloat = 0
                    if ac.cardNo > 1 {
                        fan = CGFloat(ac.cardNo - 1) * 0.25
                    }
                    print("mSOTP: ac.player is \(ac.player) and p is \(p)")
                    if ac.player - 1 == p {
                        
                        self.dealDisplayedCard(playerNo: p, xPos: anchors[p].x, yPos: anchors[p].y + CGFloat(adjCardY), splay: fan, ci: ac.screenCard)
                    }
                }
                //           cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                
                
                
                
            }
            
        }
    }
    
    
    public func moveScreenObjectsToLandscape(anchors: [CGPoint]) {
        let adjLWidth = 50
        let adjLHeight = 30
        let adjOWidth = 55
        let adjOHeight = 25
        let adjBWidth = 68
        let adjBHeight = 14
        let adjCardWidth = 30
        let adjCardHeigth = 45

        let adjOptX = Int(game.landscapeWidth / 70) // 5
        let adjOptY = Int(game.landscapeHeight / 7) //200
        let adjActX = 0
        let adjActY = Int(game.landscapeHeight / 12) //25
        let adjCardX = Int(game.landscapeWidth  / 7) // - 50
        let adjCardY = Int(game.landscapeHeight / 3) // 120
        var counter : Int = 0
        
        print("Moving screen objects: Dimensions of this screen: Height \(game.landscapeHeight), Width \(game.landscapeWidth ). )")
        if !game.screenObjectsBuilt {
            print("Screen Objects Not Built yet")
            return
        }
   //     cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)

        UIView.animate(withDuration: 1) {
            print("In Animation")
            for p in 0...game.players - 1 {
                print("Player \(p), x anchor: \(anchors[p].x), y anchor: anchors[p].y")
                // L
                game.playingScreenObjects[p][0].center = CGPoint(x: Int(anchors[p].x) + adjLWidth, y: Int(anchors[p].y) + adjLHeight)
            //    game.playingScreenObjects[p][1].center = CGPoint(x: 200, y: 100)
                // O
                game.playingScreenObjects[p][1].center = CGPoint(x: Int(anchors[p].x) + adjOptX + adjOWidth, y: Int(anchors[p].y) + adjOptY + adjOHeight)
                // Act
                game.playingScreenObjects[p][2].center = CGPoint(x: Int(anchors[p].x) + adjActX + adjBWidth, y: Int(anchors[p].y) + adjActY + adjBHeight)
                // B
                game.playingScreenObjects[p][3].center = CGPoint(x: Int(anchors[p].x) + adjActX + adjBWidth, y: Int(anchors[p].y) + adjActY + adjBHeight)
                
                for ac in self.activeCards {
                    var fan : CGFloat = 0
                    if ac.cardNo > 1 {
                        fan = CGFloat(ac.cardNo - 1) * 0.25
                    }
                    print("mSOTL: ac.player is \(ac.player) and p is \(p)")

                    if ac.player - 1 == p {
                        self.dealDisplayedCard(playerNo: p, xPos: anchors[p].x + CGFloat(adjCardX), yPos: anchors[p].y + CGFloat(adjCardY), splay: fan, ci: ac.screenCard)
                    /* if ac.player - 1 == p {
                            self.dealDisplayedCard(playerNo: p, xPos: CGFloat(Int(anchors[p].x) + adjCardX + adjCardWidth), yPos: CGFloat(Int(anchors[p].y) + adjCardY + adjCardHeigth), splay: fan, ci: ac.screenCard)

                    } */
                    }
                    
                }
     //           cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)



                
            }
            
        }
    }
     //   var playerLabels = [UILabel]()
     //   var allLabels : [[UILabel]] = []
     //       playerLabels.append(l)
//            allLabels.append(playerLabels)
    
   //     return allLabels
    
    
    public func placeScreenObjects(port: Bool) -> [CGPoint]{
        var playerAnchors : [CGPoint] = []
        print("PSO: No of Players: \(game.players). No of anchors is \(playerAnchors.count)")
        var wide = Double()
        var high = Double()
        if port == true {
            wide = Double(game.portraitWidth)
            high = Double(game.portraitHeight)
        } else {
            wide = Double(game.landscapeWidth)
            high = Double(game.landscapeHeight)
        }
        switch game.players {
        case 2:
            playerAnchors.append(CGPoint(x: wide * 0.4, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.4, y: high * 0.5))
        case 3:
            playerAnchors.append(CGPoint(x: wide * 0.2, y: high * 0.15))
            playerAnchors.append(CGPoint(x: wide * 0.6, y: high * 0.15))
            playerAnchors.append(CGPoint(x: wide * 0.4, y: high * 0.5))

        case 4:
            playerAnchors.append(CGPoint(x: wide * 0.1, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.6, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.6, y: high * 0.5))
            playerAnchors.append(CGPoint(x: wide * 0.1, y: high * 0.5))

        case 5:
            playerAnchors.append(CGPoint(x: wide * 0.1, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.4, y: high * 0.05))
            playerAnchors.append(CGPoint(x: wide * 0.7, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.6, y: high * 0.6))
            playerAnchors.append(CGPoint(x: wide * 0.2, y: high * 0.6))

        case 6:
            playerAnchors.append(CGPoint(x: wide * 0.1, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.4, y: high * 0.05))
            playerAnchors.append(CGPoint(x: wide * 0.7, y: high * 0.1))
            playerAnchors.append(CGPoint(x: wide * 0.7, y: high * 0.45))
            playerAnchors.append(CGPoint(x: wide * 0.4, y: high * 0.55))
            playerAnchors.append(CGPoint(x: wide * 0.1, y: high * 0.45))

        default:
            print("wrong number of players")
        }
        print("PSO 2: No of Players: \(game.players). No of anchors is \(playerAnchors.count)")

        return playerAnchors
    }
    
  /*
    public func shiftPortrait() {
        //determine model
        var version = String()
        
        switch self.view.bounds.width {
        case 320:
            // iPhone 5s SE
            version = "SE"
            game.cardwidth = 40
            game.cardHeight = 60
        case 375:
            // either iPhone 6, 6s, 7 or 8 OR X
            game.cardwidth = 60
            game.cardHeight = 90
            if self.view.bounds.height ==  667 {
                version = "8"
            } else if self.view.bounds.height == 812 {
                version = "X"
            }
        case 414:
            game.cardwidth = 60
            game.cardHeight = 90
            version = "Plus"
        default:
            print("not a normal screen size else and iPad")
            game.cardwidth = 60
            game.cardHeight = 90
        }
        
        let xAnchor = Int(self.view.bounds.width / 4) // 90
        let yAnchor = Int(self.view.bounds.height / 7) // 120
        let xOffset = Int(self.view.bounds.width / 3) //135
        let yOffset = Int(self.view.bounds.height / 3) //300
        let adjOptX = Int(self.view.bounds.width / 60) // 5
        let adjOptY = Int(self.view.bounds.height / 4) //200
        let adjActX = 0
        let adjActY = Int(self.view.bounds.height / 30) //25
        let adjCardX = -Int(self.view.bounds.width / 7) // - 50
        let adjCardY = Int(self.view.bounds.height / 7) // 120
        
        /**************
         6, 6s, 7, 8 Plus Adjustments:
         adjCardX add 5
         6, 6s, 7, 8 Adjustments
         adjCardX add 5
         adjCardY add 25
         SE, 5, 5s Adjustments
         CArds probably need making smaller,
         Move Options down 50
         Move hitme/shuffle down 100
 ***********************/
        
        UIView.animate(withDuration: 3) {
            self.p1Label.center = CGPoint(x: xAnchor, y: yAnchor)
            self.p1Options.center = CGPoint(x: xAnchor + adjOptX , y: yAnchor + adjOptY)
            self.p1ActualHand.center = CGPoint(x: xAnchor + adjActX, y: yAnchor + adjActY)
            self.p1Best.center = CGPoint(x: xAnchor + adjActX + 30, y: yAnchor + adjOptY)

            self.p2Label.center = CGPoint(x: xAnchor + xOffset, y: yAnchor)
            self.p2Options.center = CGPoint(x: xAnchor + adjOptX + xOffset , y: yAnchor + adjOptY)
            self.P2ActualHand.center = CGPoint(x: xAnchor + adjActX + xOffset, y: yAnchor + adjActY)
            self.p2Best.center = CGPoint(x: xAnchor + adjActX + xOffset + 30, y: yAnchor + adjOptY)

            self.p4Label.center = CGPoint(x: xAnchor, y: yAnchor + yOffset)
            self.p4Options.center = CGPoint(x: xAnchor + adjOptX, y: yAnchor + adjOptY + yOffset)
            self.p4ActualHand.center = CGPoint(x: xAnchor + adjActX, y: yAnchor + adjActY + yOffset - 15)
            self.p4Best.center = CGPoint(x: xAnchor + adjActX + 30, y: yAnchor + adjOptY + yOffset)

            self.p3Label.center = CGPoint(x: xAnchor + xOffset, y: yAnchor + yOffset)
            self.p3Options.center = CGPoint(x: xAnchor + adjOptX + xOffset , y: yAnchor + adjOptY + yOffset)
            self.p3ActualHand.center = CGPoint(x: xAnchor + adjActX + xOffset, y: yAnchor + adjActY + yOffset - 15)
            self.p3Best.center = CGPoint(x: xAnchor + adjActX + xOffset + 30, y: yAnchor + adjOptY + yOffset)

            self.outletHitMe.center = CGPoint(x: Int(self.view.bounds.width / 2) , y: Int(self.view.bounds.height * 0.8))    // 180,750
            self.outletShuffle.center = CGPoint(x: 180, y: 750)  // 180, 650

            for ac in self.activeCards {
                switch ac.player {
                case 1:
            
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY), splay: 0 , ci: ac.screenCard)
                    }
                case 2:
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY), splay: 0 , ci: ac.screenCard)
                    }
                case 4:
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: 0 , ci: ac.screenCard)
                    }
                case 3:
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: 0 , ci: ac.screenCard)
                    }
                default:
                    print("weird thing happened in shiftPortrait")
                    
                }
            }
        }
        
    }
    */
    
    /*
    public func shiftLandscape() {
        let ankL = placeScreenObjects(port: false)
        moveScreenObjectsToLandscape(anchors: ankL)
        /*
        let xAnchor = 200
        let yAnchor = 30
        let xOffset = 335
        let yOffset = 180
        
        let adjOptX = 5
        let adjOptY = 50
        let adjActX = -5
        let adjActY = 25
        let adjCardX = 40
        let adjCardY = 85
        
        UIView.animate(withDuration: 3) {
            self.p1Label.center = CGPoint(x: xAnchor, y: yAnchor)
            self.p1Options.center = CGPoint(x: xAnchor + adjOptX , y: yAnchor + adjOptY)
            self.p1ActualHand.center = CGPoint(x: xAnchor + adjActX, y: yAnchor + adjActY)
            self.p1Best.center = CGPoint(x: xAnchor + adjActX + 30, y: yAnchor + adjOptY)
            
            self.p2Label.center = CGPoint(x: xAnchor + xOffset, y: yAnchor)
            self.p2Options.center = CGPoint(x: xAnchor + adjOptX + xOffset , y: yAnchor + adjOptY)
            self.P2ActualHand.center = CGPoint(x: xAnchor + adjActX + xOffset, y: yAnchor + adjActY)
            self.p2Best.center = CGPoint(x: xAnchor + adjActX + xOffset + 30, y: yAnchor + adjOptY)
            
            self.p4Label.center = CGPoint(x: xAnchor, y: yAnchor + yOffset)
            self.p4Options.center = CGPoint(x: xAnchor + adjOptX, y: yAnchor + adjOptY + yOffset)
            self.p4ActualHand.center = CGPoint(x: xAnchor + adjActX, y: yAnchor + adjActY + yOffset - 15)
            self.p4Best.center = CGPoint(x: xAnchor + adjActX + 30, y: yAnchor + adjOptY + yOffset)
            
            self.p3Label.center = CGPoint(x: xAnchor + xOffset, y: yAnchor + yOffset)
            self.p3Options.center = CGPoint(x: xAnchor + adjOptX + xOffset , y: yAnchor + adjOptY + yOffset)
            self.p3ActualHand.center = CGPoint(x: xAnchor + adjActX + xOffset, y: yAnchor + adjActY + yOffset - 15)
            self.p3Best.center = CGPoint(x: xAnchor + adjActX + xOffset + 30, y: yAnchor + adjOptY + yOffset)
            
            self.outletHitMe.center = CGPoint(x: 410, y: 330)
            self.outletShuffle.center = CGPoint(x: 410, y: 330)
            
            for ac in self.activeCards {
                switch ac.player {
                case 1:
                    
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY), splay: 0 , ci: ac.screenCard)
                    }
                case 2:
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY), splay: 0 , ci: ac.screenCard)
                    }
                case 4:
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: 0 , ci: ac.screenCard)
                    }
                case 3:
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        self.dealDisplayedCard(playerNo: 1, xPos: CGFloat(xAnchor + adjCardX + xOffset) , yPos: CGFloat(yAnchor + adjCardY + yOffset), splay: 0 , ci: ac.screenCard)
                    }
                default:
                    print("weird thing happened in shiftLandscape")
                    
                }
            }
        }*/
        
        
    }
 */
/* 220418
    @IBAction func shiftP(_ sender: UIButton) {
        print("shiftp: subviews are \(view.subviews)")
     ////   let ankP = placeScreenObjects(port: true)
       // game.playingScreenObjects = buildScreenObjects(anchors: game.anchors)
  ////      moveScreenObjectsToPortrait(anchors: ankP)
    }
 */
    /* 220418
 @IBAction func shiftStuff(_ sender: UIButton) {
        shiftLandscape()
} */
        /*
        if shifted == false {

            let xAnchor = 90
            let yAnchor = 120
            p1Label.center = CGPoint(x: xAnchor, y: yAnchor)
            p1Options.center = CGPoint(x: xAnchor + 5 , y: yAnchor + 45)

            p1ActualHand.center = CGPoint(x: xAnchor - 62, y: yAnchor + 25)
            
         //   p1ActualHand.center = CGPoint(x: xAnchor, y: yAnchor)
            // iphonex = 375,812
            shifted = true
            for ac in activeCards {
                if ac.player == 1 {
                    if ac.cardNo != 1 {
                        let mult = Double(ac.cardNo) - 1.0
                        let fan = mult * 0.25
                        dealDisplayedCard(playerNo: 1, xPos: 50, yPos: self.view.bounds.height / 2 - 130, splay: CGFloat(fan) , ci: ac.screenCard)
                    } else {
                        dealDisplayedCard(playerNo: 1, xPos: 50, yPos: self.view.bounds.height / 2 - 130, splay: 0 , ci: ac.screenCard)
                    }

                }
            }
        } else {
            p1ActualHand.center = origXY
            shifted = false
           // p1ActualHand.center = CGPoint(x: xAnchor, y: yAnchor)
            
        }
        
      //  cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        /*
        UIView.animate(withDuration: 1 + Double(player/2)) {
            
            self.cardImage.center = CGPoint(x: xAnchor, y: yAnchor)
            
            
            self.cardImage.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        } */
 */
    
    
 /*
    @IBOutlet weak var p1Options: UITextView!
    
    @IBOutlet weak var p2Options: UITextView!
    
 //   var sideMenu = SideMenu(menuWidth: 100, menuItemTitles: ["Settings", "Deck","Calculator","About"], parentViewController: sid)
    
    @IBOutlet weak var p3Options: UITextView!
    
    @IBOutlet weak var p4Options: UITextView!
    
    @IBOutlet weak var p1ActualHand: UITextView!
    
    @IBOutlet weak var P2ActualHand: UITextView!
    
    @IBOutlet weak var p3ActualHand: UITextView!
    
    @IBOutlet weak var p4ActualHand: UITextView!
 */
    
/*
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.sideMenu.toggleMenu(open: false)

    }
    */
    
    
    @IBOutlet weak var ten: UIImageView!
    
    @IBOutlet weak var jack: UIImageView!
    
    @IBOutlet weak var queen: UIImageView!
    @IBOutlet weak var king: UIImageView!
    @IBOutlet weak var ace: UIImageView!
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    
//    public func createFiveImages() {
//        for cIM in cardArray {
//
//        }
//    }
    
    
    public func animateDealtCards() {

        game.initialAnimationPlayed = true
    //    ten.frame.height = ten.frame.height * 0.5
        var duration : Double = 1.0
        var splay : CGFloat = -0.4
        let cardArray = [ten, jack, queen, king, ace]
        
        for ci in cardArray {
            ci?.frame = CGRect(x: 0, y: 0, width: (ci?.frame.width)! * game.splashCardMultiplier, height: (ci?.frame.height)! * game.splashCardMultiplier)
            ci?.center = CGPoint(x: -100, y: game.portraitWidth/3)
            ci?.alpha = 1
            UIView.animate(withDuration: duration) {
                ci?.center = CGPoint(x: Double(game.portraitHeight)*0.2, y: Double(game.portraitWidth)*0.7)
                
                ci?.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
                
                let rotation = CGAffineTransform(rotationAngle: splay)
                
                ci?.transform = rotation
                splay += 0.2
                duration += 0.3
            }
        }
    }
    
    
    
    let outfileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("deckout4.csv")
    
    var starterAlreadyShown = false

    
    override public func viewDidLoad() {
        super.viewDidLoad()
    //    print("Dimensions of this screen: Height \(self.view.bounds.height), Width \(self.view.bounds.width)... \(UIDevice).self.self")
        
        if !starterAlreadyShown {
            UIView.animate(withDuration: 2) {
                self.starterLabel.text = self.starterLabel.text! + "\n\nSwipe Right to reveal the menu or press Shuffle and Deal to start a new game."
                self.starterLabel.alpha = 1
                self.starterAlreadyShown = true
            }
        }
        let hideOddsOnScreenObject = UserDefaults.standard.object(forKey: "mainScreenOddsHidden")
        if let hideOddsOnMainScreen = hideOddsOnScreenObject as? Bool {
            game.mainScreenOddsHidden = hideOddsOnMainScreen
        }
        
        let playersObject = UserDefaults.standard.object(forKey: "players")

        if let players = playersObject as? Int {
            print("VDL: Stored value of number of players is \(players)")
            game.players = players
            
        } else {
            print("vdl: players not previously stored")
            game.players = 4
            
        }
        
        let player1Object = UserDefaults.standard.object(forKey: "p1")
        
        if let p1Name = player1Object as? String {
            print("VDL: The name of player 1 is \(p1Name)")
            if p1Name != "" {
                game.playerNames[0] = p1Name
            } else {
                game.playerNames[0] = "Player 1"
            }
        
        } else {
            print("VDL: player 1 name not already stored: default to Player 1")
            game.playerNames[0] = "Player 1"
            
        }
        let player2Object = UserDefaults.standard.object(forKey: "p2")

        if let p2Name = player2Object as? String {
            print("VDL: The name of player 2 is \(p2Name)")
            if p2Name != "" {
                game.playerNames[1] = p2Name
            } else {
                game.playerNames[1] = "Player 2"
            }
            
        } else {
            print("VDL: player 2 name not already stored: default to Player 2")
            game.playerNames[1] = "Player 2"
            
        }
        let player3Object = UserDefaults.standard.object(forKey: "p3")

        if let p3Name = player3Object as? String {
            print("VDL: The name of player 3 is \(p3Name)")
            if p3Name != "" {
                game.playerNames[2] = p3Name
            } else {
                game.playerNames[2] = "Player 3"
            }
            
            
        } else {
            print("VDL: player 3 name not already stored: default to Player 3")
            game.playerNames[2] = "Player 3"
            
        }
        let player4Object = UserDefaults.standard.object(forKey: "p4")
        
        if let p4Name = player4Object as? String {
            print("VDL: The name of player 4 is \(p4Name)")
            if p4Name != "" {
                game.playerNames[3] = p4Name
            } else {
                game.playerNames[3] = "Player 4"
            }
            
        } else {
            print("VDL: player 4 name not already stored: default to Player 4")
            game.playerNames[3] = "Player 4"
            
        }
        let player5Object = UserDefaults.standard.object(forKey: "p5")

        if let p5Name = player5Object as? String {
            print("VDL: The name of player 5 is \(p5Name)")
            if p5Name != "" {
                game.playerNames[4] = p5Name
            } else {
                game.playerNames[4] = "Player 5"
            }
            
        } else {
            print("VDL: player 5 name not already stored: default to Player 5")
        
            game.playerNames[4] = "Player 5"
            
        }
        let player6Object = UserDefaults.standard.object(forKey: "p6")

        if let p6Name = player6Object as? String {
            print("VDL: The name of player 6 is \(p6Name)")
            if p6Name != "" {
                game.playerNames[5] = p6Name
            } else {
                game.playerNames[5] = "Player 6"
            }
            
        } else {
            print("VDL: player 6 name not already stored: default to Player 6")
            game.playerNames[5] = "Player 6"
            
        }
   //     game.state = "init"
        let origScreenHeight = self.view.bounds.height
        let origScreenWidth = self.view.bounds.width
        if origScreenWidth < origScreenHeight {
            game.inPortrait = true
            game.portraitHeight = Int(origScreenHeight)
            game.portraitWidth = Int(origScreenWidth)
            game.landscapeHeight = Int(origScreenWidth)
            game.landscapeWidth = Int(origScreenHeight)
        } else {
            game.inPortrait = false
            game.portraitHeight = Int(origScreenWidth)
            game.portraitWidth = Int(origScreenHeight)
            game.landscapeHeight = Int(origScreenHeight)
            game.landscapeWidth = Int(origScreenWidth)
        }
        var version = String()
        var checkWidth = Int()
        if !game.versionSet {  // just do this once
            game.versionSet = true
            if game.inPortrait {
                checkWidth = game.portraitWidth
            } else {
                checkWidth = game.landscapeHeight
            }
            
            switch checkWidth {
            case 320:
                // iPhone 5s SE
                version = "SE"
                game.cardwidth = 40
                game.cardHeight = 60
                game.gridCardWidth = 14.0
                game.gridCardHeight = 21.0
                game.gridXOffset = 4.0
                game.splashCardMultiplier = 0.8
            case 375:
                // either iPhone 6, 6s, 7 or 8 OR X
                game.cardwidth = 60
                game.cardHeight = 90
                if self.view.bounds.height ==  667 {
                    version = "8"
                 //   game.gridXOffset = 3.0
                    game.gridCardWidth = 20.0
                    game.gridCardHeight = 30.0
                    game.gridXOffset = 3.0
                    game.splashCardMultiplier = 0.9

                } else if self.view.bounds.height == 812 {
                    version = "X"
                    game.gridCardWidth = 26.0
                    game.gridCardHeight = 39.0
                    game.gridXOffset = 3.0
                    game.splashCardMultiplier = 1.0

                }


            case 414:
                game.cardwidth = 60
                game.cardHeight = 90
                game.gridCardWidth = 22.0
                game.gridCardHeight = 33.0
                game.gridXOffset = 3.0
                game.splashCardMultiplier = 1.0

                version = "Plus"
            case 768:
                game.cardwidth = 80
                game.cardHeight = 120
                game.gridCardWidth = 24.0
                game.gridCardHeight = 36.0
                game.gridXOffset = 2.0


                version = "iPad"
            case 1536:
                game.cardwidth = 80
                game.cardHeight = 120

                version = "iPad Retina, iPad3,  iPad Mini4, iPad Mini Retina, iPad Air, iPad Air2, iPad Pro9.7"
            case 2732:
                game.cardwidth = 100
                game.cardHeight = 150
                
                version = "iPad Pro"
            default:
                print("not a normal screen size else and iPad")
                game.cardwidth = 80
                game.cardHeight = 120
            }
            game.userInfo.setModel(vers: version)
        }

        outletHitMe.alpha = 0
        outletAddToFavourites.alpha = 0
        outletAddToFavourites.layer.cornerRadius = 5.0
        let normalMenuTitles = ["Settings", "Abort Game", "Deck","Calculator","Replace Card","Favourites","About","System","Subscriptions"]
        let ingameMenuTitles = ["Settings", "Abort Game", "Deck","Calculator","Replace Card","Favourites","About","System","Subscriptions"]

        outletHitMe.layer.cornerRadius = 5.0
        outletShuffle.layer.cornerRadius = 5.0
        let sideMenu = SideMenu(menuWidth: 150, menuItemTitles: normalMenuTitles, parentViewController: self)
        sideMenu.menuDelegate = self
        sideMenu.layer.zPosition = 1

    }

    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    public func shuffleAndDeal () {
        if game.runningFavourite {
            reloadedBanner.alpha = 1
        } else {
            reloadedBanner.alpha = 0
        }
        clearUp()

//        if starterLabel.alpha == 1 {
            UIView.animate(withDuration: 1) {
                self.starterLabel.alpha = 0
                self.title1.alpha = 0
                self.title2.alpha = 0
                self.ten.alpha = 0
                self.jack.alpha = 0
                self.queen.alpha = 0
                self.king.alpha = 0
                self.ace.alpha = 0

            }
  //      }
        outletShuffle.alpha = 0
        outletHitMe.alpha = 1
        game.anchors = placeScreenObjects(port: game.inPortrait)
        game.playingScreenObjects = buildScreenObjects(anchors: game.anchors)
        if !game.doNotShuffle {
            game.myDeckOfCards.shuffle() // place Cards in random order
        } else {
            print("Fave: not shuffling this time")
            game.doNotShuffle = false
        }
        game.state = "underway"
        game.userInfo.incGamesPlayed()
 //       var allPlayers : [Player] = []
        print("Fave: in Shuffle&Deal()1 - 9th card is \(game.myDeckOfCards.deck[8].getOrder)")

        for i in 1 ... game.players {
            
            let hand = Hands(uniqueHandRef: i, allMyCards: [])

            let player = Player(playerHand: hand, playerName: "Player" + String(i), playerNumber: i)
            
            // then add the player object to an array of player for future reference
            allPlayers += [player]
     //       print("All Players now includes " + player.playerName)
 
        } 
        print("Fave: in Shuffle&Deal()2 - 9th card is \(game.myDeckOfCards.deck[8].getOrder)")

        for i in 1 ... 3 {
            hitMe()
        }
        print("Fave: in Shuffle&Deal()3 - 9th card is \(game.myDeckOfCards.deck[8].getOrder)")

    }
    
 //   func getImage(key: String) {
        
        
   // }
    
    public func clearUp() {
        print("Clearing up now")
        for i in activeCards {
            i.screenCard.removeFromSuperview()
        }
  /* 220418
         p1Best.text = ""
        p1ActualHand.text = ""
        p1Options.text = ""
        p2Best.text = ""
        P2ActualHand.text = ""
        p2Options.text = ""
        p3Best.text = ""
        p3ActualHand.text = ""
        p3Options.text = ""
        p4Best.text = ""
        p4ActualHand.text = ""
        p4Options.text = "" */
     //   game.myDeckOfCards = nil
      //  reset unseen and undealt to the original state
        game.resetUnseen()
        game.resetUndealt()
        game.visibleCards.removeAll()
        activeCards.removeAll()
        allPlayers.removeAll()
        nextCard = 1
        game.street = 0
        outletAddToFavourites.alpha = 0
        outletShuffle.alpha = 1
  /* 220418
        p1ActualHand.alpha = 1
        P2ActualHand.alpha = 1
        p3ActualHand.alpha = 1
        p4ActualHand.alpha = 1
 */
        for o in game.playingScreenObjects {
            for i in 0 ... 3 {
                o[i].removeFromSuperview()
            }
        }
        game.playingScreenObjects.removeAll()
        game.versionSet = false
        game.screenObjectsBuilt = false
        game.anchors.removeAll()
        outletHitMe.setTitle("Hit Me!", for: UIControlState.normal)
        activeCards.removeAll()
        
        for p in allPlayers {
            p.playerHand.runables.removeAll()
            p.playerHand.sfables.removeAll()
          //  p.playerHand.pairableSetPrivate.removeAll()  error a-coming, will have to do the same with pairableSetReal... i.e. make present in funcs and destroy global var
            p.playerHand.pairableSetReal.removeAll()

            p.playerHand.flushableSetPrivate.removeAll()
            p.playerHand.flushableSetReal.removeAll()

            p.playerHand.matchSetPrivate.removeAll()
            p.playerHand.nonMatchSet.removeAll()
            
        }
        game.matchSetPublic.removeAll()
        game.matchSetReal.removeAll()
        
  //      print("remove")
    //    game.myDeckOfCards.deck.removeAll()
     //   print("init")

        if game.doNotShuffle == false {
            DeckOfCards.init()
            print("shuffle")
            game.myDeckOfCards.shuffle()
            print("Fave: in Clearup() and we are a-shuffling - 9th card is \(game.myDeckOfCards.deck[8].getOrder)")

        } else {
            print("Fave: in Clearup() and NOT shuffling - 9th card is \(game.myDeckOfCards.deck[8].getOrder)")
        //    game.doNotShuffle = false
        }

        game.upCards = game.myDeckOfCards.deck.filter{$0.dealtUp == true}
        for c in game.myDeckOfCards.deck {
            c.dealt = false
            c.dealtUp = false
        }
 
        print("done")

  //      DeckView.resetDeck(DeckView)
        viewDidLoad()  //which will set syaye back to init
        game.runningFavourite = false

    }
    
    public func animateAbort() {
        print("in animateAbort")
        UIView.animate(withDuration: 2) {
            for p in game.playingScreenObjects {
                p[1].alpha = 0
                p[2].alpha = 0
                p[0].alpha = 0
                p[3].alpha = 0
            }
            for a in self.activeCards {
                a.screenCard.alpha = 0
            }
        }
    }
    
    public func animateCompletion() {
        // 1. Identify the player that has won
        // 2. Reveal their cards
        // 3. get rid of those not in myBestFive
        // 4. Hide all the screenObjects except Player label and the cards
        // 5. Make bigger and animate to the top of the screen
        // 6. identify the next best
        // 7. animate to next position
        // 8. repeat stages 6 and 7 
        print("in animateCompletion")
        var allHandValsdict = [Int : Int]()
        var allHandVals = [Int]()
        var indexVals = [Int]()

        var sortedHandVals = [Int : Int]()
        var count : Int = 0
//        InsertionViewController.clearUpInsertions()
        
        for p in allPlayers {
            allHandValsdict.updateValue(p.playerHand.uniqueHandRef, forKey: p.playerHand.handValue)
            allHandVals.append(p.playerHand.handValue)
        }
        let maxVal = allHandVals.max()
        let maxIndex = allHandVals.index(of: maxVal!)
        var winningPlayer = Int()
        print("allHandVals : \(allHandVals)")
        print("MaxVal : \(String(describing: maxVal))")
        print("MaxIndex : \(String(describing: maxIndex))")
        winningPlayer = maxIndex!
        game.winningHand = allPlayers[winningPlayer].playerHand.bestHandString
        UIView.animate(withDuration: 2) {
            for p in game.playingScreenObjects {
                p[1].alpha = 0
                p[2].alpha = 0
                if p[0].text == "Player \(maxIndex! + 1)" {
                    p[0].font = UIFont(name: "Calibri", size: 22)
                    p[0].textColor = UIColor.black
                    p[0].center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height * 0.1)
                    p[3].center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height * 0.15)
                    p[3].font = UIFont(name: "Calibri", size: 12)
                    p[3].textColor = UIColor.black
              //      p[3].text = p[3].text! + " BIG ONE"
                } else {
                    p[0].alpha = 0
                    p[3].alpha = 0
                }
            }
            print("Hitme: begin iterating through activeCards")
            for a in self.activeCards {
                if a.player != maxIndex! + 1 {
                    
                    a.screenCard.alpha = 0
                } else {
                  //  a.revealCard()
                 //   a.screenCard.alpha = 0
                    a.screenCard.center = CGPoint(x: self.view.bounds.width * 0.4, y: self.view.bounds.height * 0.3)
          
                    for c in self.allPlayers[winningPlayer].playerHand.myFive {
                        print(" Winning Player is player: \(winningPlayer)")
                        print("myFive are \(c.description), ")
                        if c.getOrder == a.order {
                            a.screenCard.alpha = 1
                        }
                    }
                }
            }
            self.reloadedBanner.alpha = 0
            game.runningFavourite = false
        }
    }
        

        
    
    public func breakTie(hand1: Int, hand2: Int) -> Int {
        return 0
    }
    
    public func hitMe () {
        var image: UIImage
        print("Hitme >6: state is \(game.state), nextCard is \(nextCard)")
        game.nullifications.removeAll()
        outletShuffle.setTitle("Shuffle & Deal", for: UIControlState.normal)

        if game.state == "over" {
            print("Hitme >6: in the over area 1")

            game.state = "init"
            animateCompletion()
            print("Hitme >6: n the over area 2 \(game.state), nextCard is \(nextCard)")

      //      clearUp()
            print("Hitme >6: n the over area 3 \(game.state), nextCard is \(nextCard)")
            outletHitMe.alpha = 0
            outletShuffle.alpha = 1
            outletAddToFavourites.alpha = 1
            return
        }
        

  
        if nextCard > 7 {
          //  show final state

            for p in 1...game.players {
                
                print("Hitme > 7: player is \(p)")

                 // reveal all the cards
                UIView.animate(withDuration: 3) {
                    let playersDisplayedCards = self.activeCards.filter{$0.player == p}  //an array of 7 cards
                    print("Hitme > 7: player is \(p),  playerDisplayedCard.count is \(playersDisplayedCards.count)")

         
                    for c in playersDisplayedCards {
                      //  print("Hitme > 7: card.order is \(c.order),  playerDisplayedCard.count is \(playersDisplayedCards.count)")
                        c.revealCard()
                        c.screenCard.alpha = 0
                        for myFiveCard in self.allPlayers[p-1].playerHand.myFive {
                            print("Hitme > 7: screenCard.order is \(c.order),  myFiveCard.order is \(myFiveCard.getOrder) - desc: \(myFiveCard.description)")

                            if c.order == myFiveCard.getOrder {
                                print("Hitme > 7: MATCH!!!")
                                c.screenCard.alpha = 1
                     //           c.revealCard()
                            }
                        }
                    }
                }
            }
            outletHitMe.setTitle("Finish", for: UIControlState.normal)
            game.state = "over"
        } else {
          //  game.state remains underway
            for p in 0...game.players - 1 {
                print("testing hitme <=6 \(String(describing: game.playingScreenObjects[p][0].text))")

                if nextCard > 6 {
                    for l in game.playingScreenObjects {
                        l[1].alpha = 0
                        l[2].alpha = 0
                        l[3].alpha = 1
                    }
                } else {
                    for l in game.playingScreenObjects {

                    l[1].alpha = 1
                    l[2].alpha = 1
                    l[3].alpha = 0
                    }
                }
            }
        

        
        for i in 1 ... game.players {

            if let card = game.myDeckOfCards.dealCard() {

                
                let key = card.dictKey
                let dictTuple = Cards[key]
                let (info1, _, _) = dictTuple!
                
                let player = allPlayers[i-1]
                let hand = player.playerHand
                hand.addCard(card: card)


                game.playingScreenObjects[i-1][2].text = hand.currentActualHandString
                game.playingScreenObjects[i-1][3].text = hand.bestHandString
       //         print("cah: Hand \(hand.uniqueHandRef). hitme2. NextCard = \(nextCard). outputstring: \(game.playingScreenObjects[i-1][2].text!)")
                let order = card.getOrder
                playerCard(player: i, cardno: nextCard, frontImage: info1, order: order)
            
                
                game.upCards = game.myDeckOfCards.deck.filter{$0.dealtUp == true}
      //          let setOfDealtUpCardIDs = game.upCards[0].getOrder
                game.dealtCards = game.myDeckOfCards.deck.filter{$0.dealt == true}
                
                print(card.description, "\n") // display Card
                
            }
        }
        /* for each player this little section populates the following sets
                matchSetPrivate - contains cards dealt to them (whether up or down) and up to any other player, in other words, the cards visible to that player
                nonMatchSet - the cards invisible to that player
             it also populates too other sets which are not specific to that player:
                matchSetReal - the cards dealt (both up and down to any player
                matchSetPublic - the cards only dealt up to all players
             the latter two are the same for all players thus are global (game.) vars
        */
        var h : Hands
        var counter : Int = 0
        for p in allPlayers {
            h = p.playerHand
            let latestCard = h.allMyCards[h.allMyCards.count-1]
            game.matchSetReal.insert(latestCard.getOrder)
            h.matchSetPrivate.insert(latestCard.getOrder)
            if h.allMyCards.count >= 3 {
                game.matchSetPublic.insert(latestCard.getOrder)
                
            }
        }

        for p in allPlayers {
            h = p.playerHand
            h.matchSetPrivate = h.matchSetPrivate.union(game.matchSetPublic)
            h.nonMatchSet = game.cardSet.subtracting(h.matchSetPrivate)
            
            let street = h.allMyCards.count
 
            if street >= 3 && street <= 6 {

                setOddsPrivate(h: h, index: street - 3)
                setOddsPublic(h: h, index: street - 3)
                setOddsReal(h: h, index: street - 3)
                
                h.currentOptionsString = h.currentHandOptions()
                game.playingScreenObjects[counter][1].text = h.currentOptionsString
 
                counter += 1
                
            } else if street == 7 {

                outletHitMe.setTitle("Reveal Hands", for: UIControlState.normal)

            }
        }

        nextCard += 1
        game.street += 1

    
            
        }
        if game.mainScreenOddsHidden == true {
            for l in game.mainScreenOddsLabels {
                l.alpha = 0
            }
        } else {
            for l in game.mainScreenOddsLabels {
                l.alpha = 1
            }
        }
        if nextCard > 7 {
            for l in game.playingScreenObjects {
                l[2].alpha = 0
                print("Imbecile")
            }
        }
    }
    
    // if "undealt" then probability is calculated with the knowledge of the open cards  and only the hole cards of the current player... soon!
    // if "unseen" then probability is calculated with the knowledge of the hole cards as well as the open cards
 //   let realmO = try! Realm()
    
    
    
    public func saveOutcomePrivate(hand : Hands) {
        let df = DateFormatter()
        df.dateStyle = .medium
        let df2 = DateFormatter()
        df2.timeStyle = .medium
        let dateString = df.string(from: Date())
        let timeString = df2.string(from: Date())
        let wibbleTwit = Outcome()
        let i = hand.allMyCards.count
        wibbleTwit.viewPoint = "Private"
        wibbleTwit.timeOfHand = dateString + timeString
        wibbleTwit.player = hand.uniqueHandRef
        wibbleTwit.card = i
        wibbleTwit.straightFlush = hand.odds.strafluOdds[i - 3]
        wibbleTwit.poker = hand.odds.pokerOdds[i - 3]
        wibbleTwit.fullHouse = hand.odds.fhOdds[i - 3]
        wibbleTwit.flush = hand.odds.flushOdds[i - 3]
        wibbleTwit.straight = hand.odds.runOdds[i - 3]
        wibbleTwit.trips = hand.odds.tripsOdds[i - 3]
        wibbleTwit.twoPair = hand.odds.twopairOdds[i - 3]
        wibbleTwit.pair = hand.odds.pairOdds[i - 3]
        wibbleTwit.highCard = hand.odds.highOdds[i - 3]
        wibbleTwit.totalOdds = wibbleTwit.straightFlush + wibbleTwit.poker + wibbleTwit.fullHouse + wibbleTwit.flush + wibbleTwit.straight + wibbleTwit.trips + wibbleTwit.twoPair + wibbleTwit.pair + wibbleTwit.highCard
        do {
            let realmO = try Realm()
            try realmO.write {
                realmO.add(wibbleTwit)
                let res1 : Int = realmO.objects(Outcome.self).sum(ofProperty: "card") //as! [Double]
                print("VC: SaveOutcome sum of  Outcomes.card = \(res1)")
                let numOutComes : Int = realmO.objects(Outcome.self).count
                print("VC: SaveOutcome count of  Outcomes.totalOdds = \(numOutComes)")
                let averageOdds : Double = realmO.objects(Outcome.self).average(ofProperty: "totalOdds")!
                print("VC: SaveOutcome average of  Outcomes.totalOdds = \(averageOdds)")
                game.userInfo.setAccuracy(avgOdds: averageOdds)
                game.userInfo.setDataPoints(dataPoints: numOutComes)

            }
          } catch {
            print("Error initialising new Realm \(error)")
        }
        
    }
    
    public func setOddsPrivate(h : Hands, index : Int) {
        
        var oddArr : [Double] = [0,0,0,0,0,0,0,0,0]

        var pcSoFar : Double = 0.00
        var goodHandFound : Bool = false
        
        oddArr[0] = h.newStraightFlushOdds(includeHoleCards: "Private")
        oddArr[1] = h.pokerOdds(includeHoleCards: "Private")
        oddArr[2] = h.fhOdds(includeHoleCards: "Private")
        oddArr[3]  = h.flushOdds(includeHoleCards: "Private", reducedDraws: false)
        oddArr[4] = h.newRunOdds(includeHoleCards: "Private")
        oddArr[5]  = h.tripOdds(includeHoleCards: "Private")
        oddArr[6] = h.twoPairOdds(includeHoleCards: "Private")
        oddArr[7] = h.pairOdds(includeHoleCards: "Private")
        print("Calling highOdds from setOdds")
        oddArr[8] = h.highOdds(includeHoleCards: "Private")
        print("Back from highOdds in setOdds")

        //clunky condition - if you have 2 pair you cannot subsequentally get trips so they can be zeroised.  If you currently have trips and twopair you do not lose anything in zeroising the trips because the fh will do so anyway
        if oddArr[6] == 1 {
            oddArr[5] = 0
        }
        var pcHigherHands : Double = 0
        var zeroiseDownFrom = [Int]()
        for i in 0...8 {
            if oddArr[i] == 1 {
                pcHigherHands = 1 - pcSoFar
                goodHandFound = true
                zeroiseDownFrom += [i]
                print("i is \(i)")
            } else if !goodHandFound  {
                pcSoFar += oddArr[i]
            }
            print("Base odds for \(i): \(String(format: "%.2f",oddArr[i]))")
        }
        print("Pre-Adjustment total odds are: \(String(format: "%.2f", pcSoFar))")

        let high = zeroiseDownFrom.min()
        if goodHandFound {
            for i in high! + 1...8 {
                oddArr[i] = 0
            }
            print("Reducing item \(high!) down from \(oddArr[high!]) to \(pcHigherHands)")
            oddArr[high!] = pcHigherHands
        }
        
        for i in 0...8 {
            print("Normalised odds for \(i): \(String(format: "%.2f",oddArr[i]))")
        }
        
        
        h.odds.strafluOdds[index] = oddArr[0]

        h.odds.pokerOdds[index] = oddArr[1]

        h.odds.fhOdds[index] = oddArr[2]

        h.odds.flushOdds[index] = oddArr[3]
 
        h.odds.runOdds[index] = oddArr[4]
        
        // trip is a precursor to full house and poker
        // so this value should be removed from trip odds
        
        //// maybe the error is something to do with multiplying pairodd and trip ofdds - so shouldnt remove house odds from both????
        
      //  let tripPostCursors =  oddArr[2] + oddArr[1]

        h.odds.tripsOdds[index] = oddArr[5] //- tripPostCursors
        
        // twopair is a precursor to full house
        // so this values should be removed from twopair odds
        
   //     let twopairPostCursor =  oddArr[2]
        

        h.odds.twopairOdds[index] = oddArr[6] // - twopairPostCursor
        
        // pair is a precursor to twopair, trips, full house and poker
        // so these values should be removed from pair odds

   //     let pairPostCursors = oddArr[6] + oddArr[5] + oddArr[1]
        
        h.odds.pairOdds[index] = oddArr[7] // - pairPostCursors
        
        h.odds.highOdds[index] = oddArr[8]
       /*
        let flushPlusRun = h.odds.flushOdds[index] + h.odds.runOdds[index]

        if oddArr[8] - flushPlusRun < 0 {
            h.odds.highOdds[index] = oddArr[8]
        } else {
            h.odds.highOdds[index] = oddArr[8] - flushPlusRun
            
        }
*/
        
        let totpc : Double = h.odds.strafluOdds[index] + h.odds.pokerOdds[index] + h.odds.fhOdds[index] + h.odds.flushOdds[index] + h.odds.runOdds[index] + h.odds.tripsOdds[index] + h.odds.twopairOdds[index] + h.odds.pairOdds[index] + h.odds.highOdds[index]
  
        
/*
        
        print("Adjusted Odds for 0: \(String(format: "%.f", 100 * h.handProb["straightFlush"]!))")
        print("Adjusted Odds for 1: \(String(format: "%.f", 100 * h.handProb["poker"]!))")
        print("Adjusted Odds for 2: \(String(format: "%.f",100 * h.handProb["house"]!))")
        print("Adjusted Odds for 3: \(String(format: "%.f",100 * h.handProb["flush"]!))")
        print("Adjusted Odds for 4: \(String(format: "%.f",100 * h.handProb["straight"]!))")
        print("Adjusted Odds for 5: \(String(format: "%.f",100 * h.handProb["trips"]!))")
        print("Adjusted Odds for 6: \(String(format: "%.f",100 * h.handProb["twoPair"]!))")
        print("Adjusted Odds for 7: \(String(format: "%.f",100 * h.handProb["pair"]!))")
        print("Adjusted Odds for 8: \(String(format: "%.f",100 * h.handProb["highCard"]!))") */
        
    /*
        do {
            let fm = FileManager()
            let docsurl = try fm.url(for: .cachesDirectory, in: .userDomainMask , appropriateFor: nil, create: true)
            let arr = try fm.contentsOfDirectory(at: docsurl, includingPropertiesForKeys: nil, options: [])
            arr.forEach{ print("Contents of cache directory \($0.lastPathComponent)")}
        } catch {
            print("error caught")
        }
      */
      //  let outfileURL = Bundle.main.path(forResource: "Deckout", ofType: "csv")
     /*   let fileName = "Deckout1"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
       */
        
        saveOutcomePrivate(hand: h)
        // the following compiles but seems to overwrite the file afresh on each write
        
        var outString = String()
        let counter = h.allMyCards.count - 1
        // none of the following section is required
        
        if counter <= 2 {

            let outString1 = "Card Record,\(h.uniqueHandRef),1,setOdds,Private,\(h.allMyCards[0].face), \(h.allMyCards[0].suit)\n"
            let outString2 = "Card Record,\(h.uniqueHandRef),2,setOdds,Private,\(h.allMyCards[1].face), \(h.allMyCards[1].suit)\n"
            let outString3 = "Card Record,\(h.uniqueHandRef), Card \(h.allMyCards.count) 3,setOdds,Private,\(h.allMyCards[2].face), \(h.allMyCards[2].suit),\(String(format: "%.2f", totpc))%,\(String(format: "%.2f", h.odds.strafluOdds[counter-2]))%,\(String(format: "%.2f", h.odds.pokerOdds[counter-2]))%,\(String(format: "%.2f", h.odds.fhOdds[counter-2]))%,\(String(format: "%.2f", h.odds.flushOdds[counter-2]))%,\(String(format: "%.2f", h.odds.runOdds[counter-2]))%,\(String(format: "%.2f", h.odds.tripsOdds[counter-2]))%,\(String(format: "%.2f", h.odds.twopairOdds[counter-2]))%,\(String(format: "%.2f", h.odds.pairOdds[counter-2]))%,\(String(format: "%.2f", h.odds.highOdds[counter-2]))%\n"

            print("\(outString1)")
            print("\(outString2)")
            print("\(outString3)")
            do {
                    let fileHandle = try FileHandle(forWritingTo: outfileURL)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(outString1.data(using: .utf8)!)
                    fileHandle.write(outString2.data(using: .utf8)!)
                    fileHandle.write(outString3.data(using: .utf8)!)
                    fileHandle.closeFile()
                    
                } catch let error as NSError {
                    print("Failed writing to URL: \(outfileURL), Error: " + error.debugDescription)
                }
            
        }  else {
            let i = h.allMyCards[counter]
            outString = "Card Record,\(h.uniqueHandRef),Card \(h.cardNo),setOdds,Private,\(i.face), \(i.suit),\(String(format: "%.2f", totpc))%,\(String(format: "%.2f", h.odds.strafluOdds[counter-2]))%,\(String(format: "%.2f", h.odds.pokerOdds[counter-2]))%,\(String(format: "%.2f", h.odds.fhOdds[counter-2]))%,\(String(format: "%.2f", h.odds.flushOdds[counter-2]))%,\(String(format: "%.2f", h.odds.runOdds[counter-2]))%,\(String(format: "%.2f", h.odds.tripsOdds[counter-2]))%,\(String(format: "%.2f", h.odds.twopairOdds[counter-2]))%,\(String(format: "%.2f", h.odds.pairOdds[counter-2]))%,\(String(format: "%.2f", h.odds.highOdds[counter-2]))%\n"
            print("\(outString)")

          //  outString = "PO-TEST-OUT,\(h.uniqueHandRef),\(h.cardNo),setOdds,Private,\(i.face), \(i.suit)\n"
            do {
                let fileHandle = try FileHandle(forWritingTo: outfileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(outString.data(using: .utf8)!)
                fileHandle.closeFile()

            } catch let error as NSError {
                print("Failed writing to URL: \(outfileURL), Error: " + error.debugDescription)
            }
        }
      
        

        
    //    print("PO-TEST-OUT,\(uniqueHandRef),\(cardNo),High,Singles,Private,\(allMyCards), \(targetCards), \(draws), \(pop - targetNo), \(pop),\(draws), \(answerpc)")
        
        print("Post-Adjustment total odds are: \(String(format: "%.2f",totpc))")
        
        if totpc > 0.98 && totpc < 1.02 {
            print("Check setOdds-BINGO: TOTAL ODDS ARE IN THE ZONE!! odds are\(totpc). On \(nextCard) street")
        } else if totpc <= 0.98 {
            print("Check setOdds-BELOW: total odds are well below what they should be: \(totpc). On \(nextCard) street")
        } else {
            print("Check setOdds-ABOVE: total odds are well above what they should be: \(totpc). On \(nextCard) street")
            
        }

    
    }
    
    
    public func setOddsPublic(h : Hands, index : Int) {
      // for now I am changing the literal Public to Private in this function - will add the capability to show public odds at some point in the future
        var oddArr : [Double] = [0,0,0,0,0,0,0,0,0]
        
        var pcSoFar : Double = 0.00
        var goodHandFound : Bool = false
        
        oddArr[0] = h.newStraightFlushOdds(includeHoleCards: "Private")
        oddArr[1] = h.pokerOdds(includeHoleCards: "Private")
        oddArr[2] = h.fhOdds(includeHoleCards: "Private")
        oddArr[3]  = h.flushOdds(includeHoleCards: "Private", reducedDraws: false)
        oddArr[4] = h.newRunOdds(includeHoleCards: "Private")
        oddArr[5]  = h.tripOdds(includeHoleCards: "Private")
        oddArr[6] = h.twoPairOdds(includeHoleCards: "Private")
        oddArr[7] = h.pairOdds(includeHoleCards: "Private")
        print("Calling highOdds from setPublicOdds")
        oddArr[8] = h.highOdds(includeHoleCards: "Private")
        print("Back from highOdds in setPublicOdds")
        
        if oddArr[6] == 1 {
            oddArr[5] = 0
        }
        var pcHigherHands : Double = 0
        var zeroiseDownFrom = [Int]()
        for i in 0...8 {
            if oddArr[i] == 1 {
                pcHigherHands = 1 - pcSoFar
                goodHandFound = true
                zeroiseDownFrom += [i]
                print("i is \(i)")
            } else if !goodHandFound  {
                pcSoFar += oddArr[i]
            }
            print("Base odds for \(i): \(String(format: "%.2f",oddArr[i]))")
        }
        print("Pre-Adjustment total odds are: \(String(format: "%.2f", pcSoFar))")
        
        let high = zeroiseDownFrom.min()
        if goodHandFound {
            for i in high! + 1...8 {
                oddArr[i] = 0
            }
            print("Reducing item \(high!) down from \(oddArr[high!]) to \(pcHigherHands)")
            oddArr[high!] = pcHigherHands
        }
        
        for i in 0...8 {
            print("Normalised odds for \(i): \(String(format: "%.2f",oddArr[i]))")
        }
        
        h.handProb["straightFlush"] = oddArr[0]
        h.handProb["poker"] = oddArr[1]
        h.handProb["house"] = oddArr[2]
        h.handProb["flush"] = oddArr[3]
        h.handProb["straight"] = oddArr[4]
        h.handProb["trips"] = oddArr[5]
        h.handProb["twoPair"] = oddArr[6]
        h.handProb["pair"] = oddArr[7]
/// ok, going to try to fix an error that is effecting highCard reported on main screen ... replacing this
 /*       let flushPlusRun = h.odds.flushOdds[index] + h.odds.runOdds[index]
        
        if oddArr[8] - flushPlusRun < 0 {
            h.handProb["highCard"] = oddArr[8]
        } else {
            h.handProb["highCard"] = oddArr[8] - flushPlusRun
            
         }*/
        //with this...
        h.handProb["highCard"] = oddArr[8]


    }
    
    public func setOddsReal(h : Hands, index : Int) {
        var oddArr : [Double] = [0,0,0,0,0,0,0,0,0]
        
        var pcSoFar : Double = 0.00
        var goodHandFound : Bool = false
        
        oddArr[0] = h.newStraightFlushOdds(includeHoleCards: "Real")
        oddArr[1] = h.pokerOdds(includeHoleCards: "Real")
        oddArr[2] = h.fhOdds(includeHoleCards: "Real")
        oddArr[3]  = h.flushOdds(includeHoleCards: "Real", reducedDraws: false)
        oddArr[4] = h.newRunOdds(includeHoleCards: "Real")
        oddArr[5]  = h.tripOdds(includeHoleCards: "Real")
        oddArr[6] = h.twoPairOdds(includeHoleCards: "Real")
        oddArr[7] = h.pairOdds(includeHoleCards: "Real")
        print("Calling highOdds from setRealOdds")

        oddArr[8] = h.highOdds(includeHoleCards: "Real")
        print("Back from highOdds in setRealOdds")

        if oddArr[6] == 1 {
            oddArr[5] = 0
        }
        var pcHigherHands : Double = 0
        var zeroiseDownFrom = [Int]()
        for i in 0...8 {
        if oddArr[i] == 1 {
            pcHigherHands = 1 - pcSoFar
            goodHandFound = true
            zeroiseDownFrom += [i]
            print("i is \(i)")
        } else if !goodHandFound  {
            pcSoFar += oddArr[i]
        }
        print("Base odds for \(i): \(String(format: "%.2f",oddArr[i]))")
        }
        print("Pre-Adjustment total odds are: \(String(format: "%.2f", pcSoFar))")
        
        let high = zeroiseDownFrom.min()
        if goodHandFound {
            for i in high! + 1...8 {
            oddArr[i] = 0
            }
            print("Reducing item \(high!) down from \(oddArr[high!]) to \(pcHigherHands)")
            oddArr[high!] = pcHigherHands
        }
        
        for i in 0...8 {
            print("Normalised odds for \(i): \(String(format: "%.2f",oddArr[i]))")
        }
        
        
        h.odds.strafluRealOdds[index] = oddArr[0]
        
        h.odds.pokerRealOdds[index] = oddArr[1]
        
        h.odds.fhRealOdds[index] = oddArr[2]
        
        h.odds.flushRealOdds[index] = oddArr[3]
        
        h.odds.runRealOdds[index] = oddArr[4]
        
        h.odds.tripsRealOdds[index] = oddArr[5]
        
        h.odds.twopairRealOdds[index] = oddArr[6]
        
        h.odds.pairRealOdds[index] = oddArr[7]
        let flushPlusRun = h.odds.flushRealOdds[index] + h.odds.runRealOdds[index]
        if oddArr[8] - flushPlusRun < 0 {
            h.odds.highRealOdds[index] = oddArr[8]
        } else {
            h.odds.highRealOdds[index] = oddArr[8] - flushPlusRun
            
        }

     //   h.odds.highRealOdds[index] = oddArr[8]
        
        let totpc : Double = h.odds.strafluRealOdds[index] + h.odds.pokerRealOdds[index] + h.odds.fhRealOdds[index] + h.odds.flushRealOdds[index] + h.odds.runRealOdds[index] + h.odds.tripsRealOdds[index] + h.odds.twopairRealOdds[index] + h.odds.pairRealOdds[index] + h.odds.highRealOdds[index]
        
        print("Post-Adjustment total odds are: \(String(format: "%.2f",totpc))")
        if totpc > 0.98 && totpc < 1.02 {
            print("Check setRealOdds-BINGO: TOTAL ODDS ARE IN THE ZONE!! odds are\(totpc). On \(nextCard) street")
        } else if totpc <= 0.98 {
            print("Check setRealOdds-BELOW: total odds are well below what they should be: \(totpc). On \(nextCard) street")
        } else {
            print("Check setRealOdds-ABOVE: total odds are well above what they should be: \(totpc). On \(nextCard) street")
            
        }

        print("Post-Adjustment total odds are: \(String(format: "%.2f",totpc))")
        
    }

    
    
    
   
    public class DisplayedCard {
        public let player : Int
        public let cardNo : Int
        public let screenCard : UIImageView
        public let pngimage : UIImage
        public var faceUp : Bool = true
        public var order = Int()
        
        public init(player: Int, cardNo: Int, screenCard: UIImageView, pngimage: UIImage, faceUp: Bool, order: Int) {
            
            self.player = player;
            self.cardNo = cardNo;
            self.screenCard = screenCard;
            self.pngimage = pngimage;
            self.faceUp = true;
            self.order = order;
           screenCard.isUserInteractionEnabled = true
          }
        
        public func revealCard() {
            screenCard.image = pngimage
            faceUp = true
            
        }
        
        public func hideCard() {
            screenCard.image = #imageLiteral(resourceName: "back@1x")
            faceUp = false
            
        }
    }
   
    public var activeCards: [DisplayedCard] = []
    
    func playerCard(player: Int, cardno: Int, frontImage: UIImage, order: Int) {
        
        let xAnchor: CGFloat = 0.0
        let yAnchor: CGFloat = 0.0
        var radians: CGFloat = 0.0
        var up: Bool = true
        var wide = Int()
        var high = Int()
        cardImage = UIImageView(frame: CGRect(x: xAnchor, y: yAnchor, width: CGFloat(game.cardwidth), height: CGFloat(game.cardHeight)))
        game.visibleCards.append(cardImage)
        if cardno < 3 || cardno == 7 {
            up = false
            cardImage.image = #imageLiteral(resourceName: "back@1x")
        } else {
            cardImage.image = frontImage
            up = true
        }
        
        if game.inPortrait {
            wide = game.portraitWidth
            high = game.portraitHeight
        } else {
            wide = game.landscapeWidth
            high = game.landscapeHeight
        }
        
        let newCard = DisplayedCard(player: player, cardNo: cardno, screenCard: cardImage, pngimage: frontImage, faceUp: up, order: order)
        
        activeCards += [newCard]

    
        
    
        cardImage.center = CGPoint(x: 0, y: high / 2)
        let adjCardX = -wide / 7 // - 50
        let adjCardY = Double(high) / 4.3 // 120
        var fan : CGFloat = 0
        if cardno > 1 {
            fan = CGFloat(cardno - 1) * 0.25
        }
        // put something in here to mean it has to wait half a second before it starts the next animation
       
        UIView.animate(withDuration: 1 + Double(player/2)) {

        self.dealDisplayedCard(playerNo: player-1, xPos: game.anchors[player-1].x, yPos: game.anchors[player-1].y + CGFloat(adjCardY), splay: fan, ci: self.cardImage)
            
  /* old          self.dealDisplayedCard(playerNo: player, xPos: xAnchor, yPos: yAnchor, splay: radians, ci: self.cardImage) */
            self.view.addSubview(self.cardImage)
            self.cardImage.isUserInteractionEnabled = true
                /* this bit creates the gestures and applies them to screen objects */
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight(gesture:)))
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft(gesture:)))
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))

            
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left

            self.cardImage.addGestureRecognizer(swipeRight)
            self.cardImage.addGestureRecognizer(swipeLeft)
            self.cardImage.addGestureRecognizer(tapGestureRecognizer)
        
        }

    }
    
    public func dealDisplayedCard(playerNo: Int, xPos: CGFloat, yPos: CGFloat, splay: CGFloat, ci : UIImageView) {
        
            ci.center = CGPoint(x: xPos, y: yPos)
        
            ci.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            
            let rotation2 = CGAffineTransform(rotationAngle: splay)
            
            ci.transform = rotation2
        
    }
    
    
    @objc func swipedRight(gesture: UIGestureRecognizer) {
        let swipedthing = gesture.view!
        print("swiped right \(swipedthing)")
        for a in activeCards {
            if a.screenCard == swipedthing {
                let p = a.player
                for x in activeCards {
                    if x.player == p {
                        if x.cardNo == 1 || x.cardNo == 2 || x.cardNo == 7 {
                        x.revealCard()
                        }
                    }
                }
            }
        }

    }

    @objc func swipedLeft(gesture: UIGestureRecognizer) {
        let swipedthing = gesture.view!
        print("swiped left \(swipedthing)")
        for a in activeCards {
            if a.screenCard == swipedthing {
                let p = a.player
                for x in activeCards {
                    if x.player == p {
                        if x.cardNo == 1 || x.cardNo == 2 || x.cardNo == 7 {
                        x.hideCard()
                        }
                    }
                }
            }
        }
       
    }

    
    //     let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
    // .isUserInteractionEnabled = true
    //        self.view.addGestureRecognizer(tapGestureRecognizer)
    
    //     let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(gesture:)))
    
    //     swipeRight.direction = UISwipeGestureRecognizerDirection.right
    //     self.view.addGestureRecognizer(swipeRight)
    //     self.view.addGestureRecognizer(tapGestureRecognizer)
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.


/*    @objc func imageTapped(gesture: UIGestureRecognizer) {
 let tappedthing = gesture.view as! UIImageView
 print("tapped up \(tappedthing.image)")
 let cls = tappedthing.superclass
 //      tappedthing.getParent and then do a reveal card on it
 // i could always override the UIImageView class and give it the revealcard method???
 }
 */

    @objc func imageTapped(gesture: UIGestureRecognizer) {
        let tappedthing = gesture.view!
        for a in activeCards {
            if a.screenCard == tappedthing {
                let p = a.player
                for x in activeCards {
                    if x.player == p {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        
                        let ovc = sb.instantiateViewController(withIdentifier: "Overlay") as! OddsViewController
                        transitioningDelegate = transitionDelegate
                        ovc.transitioningDelegate = transitionDelegate
                        ovc.modalPresentationStyle = .custom
                        let hand = allPlayers[p-1].playerHand
                        self.present(ovc, animated: true, completion: nil)
                        ovc.handItem = hand

                    
                    }
                }
 
                print("at least ive been pressed this time")
            }
        }
    }
   
    

    
    
    @IBAction func unwindToMainVC(seg: UIStoryboardSegue!) {
    
       // SideMenu.toggleMenu(open: false)
      //  sideMenu.toggleMenu(open: false)

    }
    
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deckSeque" {
            let deckVC = segue.destination as! DeckView
            deckVC.upCards = game.upCards!
            deckVC.dealtCards = game.dealtCards!
        
        } else if segue.identifier == "ffSeque" {
          /*  let deckVC = segue.destination as! DeckView
            deckVC.upCards = game.upCards
            deckVC.dealtCards = game.dealtCards */
    
        }
   }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("Which comes first - traitcollection did change?")
        print("did: Dimensions of this screen: Height \(self.view.bounds.height), Width \(self.view.bounds.width). )")
        print("it is \(game.inPortrait) that we are now in portrait mode")
     /*   if !game.inPortrait {
            print(" orientation is Landscape")
            let anchorsL = placeScreenObjects(port: false)
            moveScreenObjectsToPortrait(anchors: anchorsL)
         
        } else {
            print("vc: orientation is portrait")
            let anchorsP = placeScreenObjects(port: true)
            moveScreenObjectsToPortrait(anchors: anchorsP)
         
        } */
    }

    
    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("Which comes first - traitcollection will transition?")
        print("will: Dimensions of this screen: Height \(self.view.bounds.height), Width \(self.view.bounds.width). )")

        if newCollection.verticalSizeClass == .compact {
            print("vc: orientation is Landscape")
            game.inPortrait = false
            let anchorsL = placeScreenObjects(port: false)
            moveScreenObjectsToLandscape(anchors: anchorsL)

        } else {
            print("vc: orientation is \(newCollection.verticalSizeClass)")
            game.inPortrait = true
            let anchorsP = placeScreenObjects(port: true)
            moveScreenObjectsToPortrait(anchors: anchorsP)
        }
    }
}








