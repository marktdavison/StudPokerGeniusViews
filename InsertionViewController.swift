//
//  InsertionViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 14/01/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class InsertionViewController: UIViewController, UIGestureRecognizerDelegate {
    let Cards = [
        
        0: (#imageLiteral(resourceName: "ace_of_hearts"), "Ace", "Hearts"),
        1: (#imageLiteral(resourceName: "2_of_hearts"), "Deuce", "Hearts"),
        2: (#imageLiteral(resourceName: "3_of_hearts"), "Trip", "Hearts"),
        3: (#imageLiteral(resourceName: "4_of_hearts"), "Four", "Hearts"),
        4: (#imageLiteral(resourceName: "5_of_hearts"), "Five", "Hearts"),
        5: (#imageLiteral(resourceName: "6_of_hearts"), "Six", "Hearts"),
        6: (#imageLiteral(resourceName: "7_of_hearts"), "Seven", "Hearts"),
        7: (#imageLiteral(resourceName: "8_of_hearts"), "Eight", "Hearts"),
        8: (#imageLiteral(resourceName: "9_of_hearts"), "Nine", "Hearts"),
        9: (#imageLiteral(resourceName: "10_of_hearts"), "Ten", "Hearts"),
        10: (#imageLiteral(resourceName: "jack_of_hearts"), "Jack", "Hearts"),
        11: (#imageLiteral(resourceName: "queen_of_hearts"), "Queen", "Hearts"),
        12: (#imageLiteral(resourceName: "king_of_hearts"), "King", "Hearts"),
        
        13: (#imageLiteral(resourceName: "ace_of_diamonds"), "Ace", "Diamonds"),
        14: (#imageLiteral(resourceName: "2_of_diamonds"), "Deuce", "Diamonds"),
        15: (#imageLiteral(resourceName: "3_of_diamonds"), "Trip", "Diamonds"),
        16: (#imageLiteral(resourceName: "4_of_diamonds"), "Four", "Diamonds"),
        17: (#imageLiteral(resourceName: "5_of_diamonds"), "Five", "Diamonds"),
        18: (#imageLiteral(resourceName: "6_of_diamonds"), "Six", "Diamonds"),
        19: (#imageLiteral(resourceName: "7_of_diamonds"), "Seven", "Diamonds"),
        20: (#imageLiteral(resourceName: "8_of_diamonds"), "Eight", "Diamonds"),
        21: (#imageLiteral(resourceName: "9_of_diamonds"), "Nine", "Diamonds"),
        22: (#imageLiteral(resourceName: "10_of_diamonds"), "Ten", "Diamonds"),
        23: (#imageLiteral(resourceName: "jack_of_diamonds"), "Jack", "Diamonds"),
        24: (#imageLiteral(resourceName: "queen_of_diamonds"), "Queen", "Diamonds"),
        25: (#imageLiteral(resourceName: "king_of_diamonds"), "King", "Diamonds"),
        
        26: (#imageLiteral(resourceName: "ace_of_clubs"), "Ace", "Clubs"),
        27: (#imageLiteral(resourceName: "2_of_clubs"), "Deuce", "Clubs"),
        28: (#imageLiteral(resourceName: "3_of_clubs"), "Trip", "Clubs"),
        29: (#imageLiteral(resourceName: "4_of_clubs"), "Four", "Clubs"),
        30: (#imageLiteral(resourceName: "5_of_clubs"), "Five", "Clubs"),
        31: (#imageLiteral(resourceName: "6_of_clubs"), "Six", "Clubs"),
        32: (#imageLiteral(resourceName: "7_of_clubs"), "Seven", "Clubs"),
        33: (#imageLiteral(resourceName: "8_of_clubs"), "Eight", "Clubs"),
        34: (#imageLiteral(resourceName: "9_of_clubs"), "Nine", "Clubs"),
        35: (#imageLiteral(resourceName: "10_of_clubs"), "Ten", "Clubs"),
        36: (#imageLiteral(resourceName: "jack_of_clubs"), "Jack", "Clubs"),
        37: (#imageLiteral(resourceName: "queen_of_clubs"), "Queen", "Clubs"),
        38: (#imageLiteral(resourceName: "king_of_clubs"), "King", "Clubs"),
        
        39: (#imageLiteral(resourceName: "ace_of_spades"), "Ace", "Spades"),
        40: (#imageLiteral(resourceName: "2_of_spades"), "Deuce", "Spades"),
        41: (#imageLiteral(resourceName: "3_of_spades"), "Trip", "Spades"),
        42: (#imageLiteral(resourceName: "4_of_spades"), "Four", "Spades"),
        43: (#imageLiteral(resourceName: "5_of_spades"), "Five", "Spades"),
        44: (#imageLiteral(resourceName: "6_of_spades"), "Six", "Spades"),
        45: (#imageLiteral(resourceName: "7_of_spades"), "Seven", "Spades"),
        46: (#imageLiteral(resourceName: "8_of_spades"), "Eight", "Spades"),
        47: (#imageLiteral(resourceName: "9_of_spades"), "Nine", "Spades"),
        48: (#imageLiteral(resourceName: "10_of_spades"), "Ten", "Spades"),
        49: (#imageLiteral(resourceName: "jack_of_spades"), "Jack", "Spades"),
        50: (#imageLiteral(resourceName: "queen_of_spades"), "Queen", "Spades"),
        51: (#imageLiteral(resourceName: "king_of_spades"), "King", "Spades")
    ]


    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var confirmOutlet: UIButton!
    @IBOutlet weak var playerNo: UILabel!
    @IBOutlet weak var cardNo: UILabel!
    @IBOutlet weak var gridView: UIView!
    
    @IBAction func playerNoAction(_ sender: UIStepper) {
        playerNo.text = Int(sender.value).description
    }
 /*   @IBAction func actionStepper(_ sender: UIStepper) {
        playerNo.text = Int(sender.value).description
    } */
    @IBOutlet weak var playerStepper: UIStepper!
    @IBOutlet weak var confirmString: UILabel!
    @IBAction func confirmAction(_ sender: Any) {
        game.userInfo.incReplaceConfirm()
        if game.currentSubscriber {
            if !warningFlag {
                game.queuedInsertions.append((pint, cint, cardRef))
                print("IVC: Asserting new queued replacement: \(pint):\(cint):\(cardRef)")
                game.nullifications.insert(cardRef)
                refreshCards()
                cardGrid()
                confirmString.text = ""
            }
        } else {
                presentSubscriptionAlert(functionality: "Changing the Order of Future Cards")
            }
        
    }
    
   
    @IBOutlet weak var cardNoStepper: UIStepper!
    @IBAction func cardNoAction(_ sender: UIStepper) {
        cardNo.text = Int(sender.value).description

    }
    var minPlayer = Int()
    var minCard = Int()
    var maxPlayer = Int()
    var maxCard = Int()
    var warningFlag : Bool = false

 //   var nullifications = Set<Int>()

    var yetToDrawSet = Set<Int>()
    var currentCard = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmOutlet.layer.cornerRadius = 10.0
        cancelOutlet.layer.cornerRadius = 10.0
        cardNoStepper.alpha = 1
        playerStepper.alpha = 1
    //    game.nullifications.removeAll()
        var pint = Int()
        if let p = playerNo.text {
            pint = Int(p)!
        }
        refreshCards()
        playerStepper.maximumValue = Double(game.players)
        print("IVC: playerStep val = \(playerStepper.value), min = \(playerStepper.minimumValue), max = \(playerStepper.maximumValue)")
        currentCard = game.street
        print("IVC: currentcard = \(currentCard)")
        switch currentCard {
        case 0:
            cardNoStepper.alpha = 1
            cardNoStepper.minimumValue = 1
            cardNoStepper.maximumValue = 3
            cardNoStepper.value = 1
        case 3,4,5,6:
            cardNoStepper.alpha = 0
            cardNo.text = String(currentCard + 1)
        default:  // last card dealt
            game.matchSetReal.removeAll()
            refreshCards()
            cardGrid()
            cardNoStepper.value = 1
            playerStepper.value = 1
            cardNoStepper.alpha = 1
            playerStepper.alpha = 1
            playerNo.text = "1"
            cardNo.text = "1"
            confirmString.text = "No insertions possible - last card already dealt"
        }
 /*       if currentCard == 0 {
            cardNoStepper.alpha = 1
            cardNoStepper.minimumValue = 1
            cardNoStepper.maximumValue = 3
            cardNoStepper.value = 1
        } else {
            cardNoStepper.alpha = 0
            cardNo.text = String(currentCard + 1)
        } */
        
        cardGrid()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func refreshCards() {
        yetToDrawSet = game.cardSet.subtracting(game.matchSetReal)
      //  yetToDrawSet = game.cardSet.subtracting(nullifications)

 //       maxStepper = game.players
        
    }

    
    
    public func cardGrid() {
        var xOffset :Double = 0.0
        var yOffset :Double = 0.5
        let xAnchor: CGFloat = 30.0 //was 100.0
        let yAnchor: CGFloat = 24.0 // was 150.0
    //    let radians: CGFloat = 0.0
        var ref: Int = 0
        let backImage = #imageLiteral(resourceName: "back@1x")
        
        for row in ["Hearts", "Diamonds", "Clubs", "Spades"] {
            
            for column in ["Ace", "Deuce", "Trip", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"] {
            

                
                let cIm = UIImageView(frame: CGRect(x: xAnchor, y: yAnchor, width: CGFloat(game.gridCardWidth), height: CGFloat(game.gridCardHeight)))
                if game.nullifications.contains(ref) {
                    cIm.image = backImage
                    cIm.layer.borderWidth = 2.0
                    cIm.layer.borderColor = UIColor.black.cgColor
                    cIm.isUserInteractionEnabled = false

                } else if yetToDrawSet.contains(ref) {
                    let dictTuple = Cards[ref]
                    let (info1, info2, info3) = dictTuple!
                    cIm.image = info1
                    cIm.isUserInteractionEnabled = true
                    cIm.tag = ref
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
                    
                    cIm.addGestureRecognizer(tapGestureRecognizer)
                } else {
                    cIm.image = backImage
                }
                                
         //   cIm.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                cIm.center = CGPoint(x: gridView.bounds.width / 2, y: gridView.bounds.height / 2)

                cIm.center = CGPoint(x: xAnchor , y: yAnchor)
                
                cIm.layer.anchorPoint = CGPoint(x: xOffset, y: yOffset)
                
             //   self.view.addSubview(cIm)
                gridView.addSubview(cIm)



                yOffset -= 1.1
                
                ref += 1
                
            }
            yOffset = 0.5
            
            
            xOffset -= game.gridXOffset
            
        }
    }

    var cardRef = Int()
    var pint = Int()
    var cint = Int()
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        var properFace = String()
        var properSuit = String()
        let tappedthing = gesture.view!
        cardRef = tappedthing.tag

        if let p = playerNo.text {
            pint = Int(p)!
        }
        if let c = cardNo.text {
            cint = Int(c)!
        }
        let dictTuple = Cards[cardRef]
        for q in game.queuedInsertions {
            if q.0 == pint && q.1 == cint {
                confirmString.text = "Warning: Cannot insert twice into the same position!"
                warningFlag = true
            } else {
                warningFlag = false
            }
        }
        /// ok lets take it a tad slower - all of a sudden nothing is working!
        if warningFlag == false {
            
            if let face = dictTuple?.1 {
                print("IVC: face = \(face)")
                properFace = face
            }
            if let suit = dictTuple?.2 {
                print("IVC: suit = \(suit)")
                properSuit = suit
            }
            confirmString.text = "\(properFace) of \(properSuit) will be card \(cint) for Player \(pint).\nPlease Confirm!"
        }
    }
    
    
    
    
    internal func presentSubscriptionAlert(functionality: String) {
        let alert = UIAlertController(title: "Sorry but \(functionality) is available only to Pro users. ", message: "You may access a host of features when you go Pro:\n\n\tPerspective Switch\n\tChange to your favoured Odds format\n\tChange upcoming cards\n\tSave & reload games\n\tName Players\n\tHide odds on main screen.\n\nGo to the subscription screen to see your status?", preferredStyle: .alert)
        
        let actionLoad = UIAlertAction(title: "Go", style: .default) { (action) in
            print("Pref alert selected Go")
            self.performSegue(withIdentifier: "insertToSubSeque", sender: self)
            
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
