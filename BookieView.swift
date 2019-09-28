//
//  BookieView.swift
//  StudPokerGenius
//
//  Created by Mark Davison on 16/07/2019.
//  Copyright © 2019 anditwasso. All rights reserved.
//

import UIKit

class BookieView: UIView {

    @IBOutlet weak var banner: UILabel!
    
    @IBOutlet weak var mainSV: UIStackView!
    
    @IBOutlet weak var p2SV: UIStackView!
    @IBOutlet weak var p1SV: UIStackView!
    
    @IBOutlet weak var p4SV: UIStackView!
    @IBOutlet weak var p3SV: UIStackView!
    
    @IBOutlet weak var p5SV: UIStackView!
    
    @IBOutlet weak var p6SV: UIStackView!
    
    @IBOutlet weak var p1: UITextField!
    
    @IBOutlet weak var p1Odds: UITextField!
    
    @IBOutlet weak var p1Stake: UITextField!
    
    @IBOutlet weak var p1Winnings: UITextField!
    
    
    @IBOutlet weak var p2: UITextField!
    @IBOutlet weak var p2Odds: UITextField!
    
    @IBOutlet weak var p2Stake: UITextField!
    @IBOutlet weak var p2Winnings: UITextField!
    
    @IBOutlet weak var p3: UITextField!
    @IBOutlet weak var p3Odds: UITextField!
    
    @IBOutlet weak var p3Stake: UITextField!
    @IBOutlet weak var p3Winnings: UITextField!
    
    @IBOutlet weak var p4: UITextField!
    
    @IBOutlet weak var p4Odds: UITextField!
    
    @IBOutlet weak var p4Stake: UITextField!
    @IBOutlet weak var p4Winnings: UITextField!
    @IBOutlet weak var p5: UITextField!
    
    @IBOutlet weak var p5Odds: UITextField!
    @IBOutlet weak var p5Stake: UITextField!
    @IBOutlet weak var p5Winnings: UITextField!
    
    @IBOutlet weak var p6: UITextField!
    
    @IBOutlet weak var p6Odds: UITextField!
    
    @IBOutlet weak var p6Stake: UITextField!
    
    @IBOutlet weak var p6Winnings: UITextField!
    
    public struct BufferedBet{
        var stake : Int
        var oddsStr : String
        var player : Int
        var street : Int
        var winnings : Int
    }
    
    public var buffer : [BufferedBet] = []
    
    public var uncommittedStakesTotal = 0
    
    public var playerLabels = [UITextField]()
    public var oddsLabels = [UITextField]()
    public var stakeLabels = [UITextField]()
    public var winLabels = [UITextField]()
    public var stacks = [UIStackView]()
    
    var betsPlaced = [StreetBetting]()
    var betPlacedDisc = UITextField()
    var allDiscs = [UITextField]()

    @IBOutlet weak var sessionLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    var bufferedStakes = [0,0,0,0,0,0]
    
    @IBAction func enterStake(_ sender: Any) {

        let player = (sender as AnyObject).tag - 1
   //     let street = thisGame!.currentStreet
   //     let streetBets = thisGame.allStreetBets[street-3]
        let stake = trimStake(string: (sender as AnyObject).text)
        let streetBet = getStreetBet(player: player)
        let potentialWinnings = Int(streetBet.odds) * stake
        uncommittedStakesTotal += stake
        let remainingMoney = thisGame!.moneyLeft - uncommittedStakesTotal
        if remainingMoney < 0 {
            (sender as! UITextField).text = "\(game.chosenCurrency)0"
            return
            
        }
        bufferedStakes[player] = stake
        let bb = BufferedBet(stake: stake, oddsStr: streetBet.pOddsStr, player: player, street: thisGame!.currentStreet, winnings: potentialWinnings)
        buffer.append(bb)
        
        banner.text = "Who will win? Place a bet of up to " + game.chosenCurrency + String(remainingMoney)
        winLabels[player].text = game.chosenCurrency + String(potentialWinnings)

        formatView(tField: sender as! UITextField)
    
        // betAlerts(p1, p2)
 //       commitTransaction(player: player, stake: stake)
        
    }
    
    var thisGame : GameBetting?

    
    public func formatView(tField : UITextField) {
        bluifyOutlet.isEnabled = true
        let rightStack = stacks[tField.tag-1]
        tField.textColor = UIColor.white
        tField.backgroundColor = UIColor.darkGray
        tField.isEnabled = false
        betPlacedDisc = goldDisc(x: tField.frame.maxX + 85, y: tField.frame.minY + 4)
        rightStack.addSubview(betPlacedDisc)
        tField.text = "\(game.chosenCurrency)\(tField.text!)"
    }
    
    public func getStreetBet(player: Int) -> StreetBetting {
        switch thisGame!.currentStreet {
        case 3:
            return thisGame!.street3Bets[player]
        case 4:
            return thisGame!.street4Bets[player]
        case 5:
            return thisGame!.street5Bets[player]
        case 6:
            return thisGame!.street6Bets[player]
        case 7:
            return thisGame!.street7Bets[player]
        default:
            return thisGame!.street3Bets[player]

        }
        
    }
    
    public func commitTransaction(player : Int, stake : Int) {
        let currentSB = getStreetBet(player: player)

        thisGame!.amountStaked += stake
        thisGame!.moneyLeft = thisGame!.moneyLeft - thisGame!.amountStaked
        currentSB.stake = stake
        currentSB.winnings = Int(currentSB.odds) * stake
        currentSB.betPlaced = true
        currentSB.handValueActual = game.allCurrentHands[currentSB.player].5
        currentSB.handStringActual = game.allCurrentHands[currentSB.player].3
        //      streetBets[player].posActual = Int(game.allCurrentHands[player].6)!
        currentSB.handValueBest = game.allBestHands[currentSB.player].5
        currentSB.handStringBest = game.allBestHands[currentSB.player].3
        //      streetBets[player].posActual = Int(game.allBestHands[player].6)!
        currentSB.handValueProb = game.allLikelyHands[currentSB.player].5
        currentSB.handStringProb = game.allLikelyHands[currentSB.player].3
        //      streetBets[player].posActual = Int(game.allLikelyHands[player].6)!
        banner.text = "Bets placed for card \(thisGame!.currentStreet)."
        uncommittedStakesTotal = 0
        bluifyOutlet.isEnabled = false
        thisGame!.betsPlaced.append(currentSB)
    }
    
    public func rollbackTransaction() {
        bluifyOutlet.isEnabled = false
        for s in stakeLabels {
            s.textColor = UIColor.white
            s.backgroundColor = UIColor.darkGray
            s.text = "\(game.chosenCurrency)0"
            s.isEnabled = true
        }
        for w in winLabels {
            w.text = "\(game.chosenCurrency)0"
        }
        for d in allDiscs {
            d.removeFromSuperview()
        }
        uncommittedStakesTotal = 0
        banner.text = "Who will win? Place a bet of up to €" + String(thisGame!.moneyLeft)

    }
    
    public func trimStake(string: String) -> Int {
        let toTrim = CharacterSet(charactersIn: "£$€¥")
        let trimmedStake = string.trimmingCharacters(in: toTrim)
        let stake = Int(trimmedStake)!
        return stake
    }
    
    
    

    
    public func betAlert(bets: [BufferedBet], disc: UITextField) -> Bool {

        var confirmed : Bool = false
        var multiple : Bool
        var alertMessage : String
        let messageFont = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 7.0)!]
        if bets.count > 1 {
            multiple = true
        } else if bets.count == 1 {
            multiple = false
        } else {
            return false
        }
        
        if !multiple {
            let b = bets[0]
            alertMessage = """
            • You have placed a \(game.chosenCurrency)\(b.stake) stake at \(b.oddsStr) on \(game.playerNames[b.player]) with \(7-b.street) cards yet to come.
            • You stand to win \(game.chosenCurrency)\(b.winnings) on this bet.
            • You still have \(game.chosenCurrency)\(String(describing: thisGame!.moneyLeft-b.stake)) to bet by the end of the game.
            """

        } else {
            var totalStakes = 0
            alertMessage = """
            You have placed \(bets.count) bets at card number \(bets[0].street):
            """
            for b in bets {
                alertMessage += "\n\t• \(game.chosenCurrency)\(b.stake) on \(game.playerNames[b.player]) at \(b.oddsStr) to win \(game.chosenCurrency)\(b.winnings)"
                totalStakes+=b.stake
            }
            if thisGame!.moneyLeft - totalStakes >= 0 {
                alertMessage += "\nYou can place no further bets for the remainder of the game"

            } else {
                alertMessage += "\nYou have \(game.chosenCurrency)\(thisGame!.moneyLeft - totalStakes) to bet by the end of the game"
            }
        }
        let attrMessage = NSMutableAttributedString(string: alertMessage, attributes: messageFont)
        let alert = UIAlertController(title: "Please confirm your betting", message: attrMessage.string, preferredStyle: .alert)
        
        let confirmBet = UIAlertAction(title: "Confirm", style: .default) {(action) in
            print("BV: selected Confirm Bet")
            confirmed = true
            for b in bets {
                self.commitTransaction(player: b.player, stake: self.bufferedStakes[b.player-1])

            }
//            UIView.animate(withDuration: 4) {
//                disc.frame = CGRect(x: 0, y: 0, width: disc.frame.width * 2, height: disc.frame.height * 2)
//                disc.layer.cornerRadius = 16
//                disc.center = game.playingScreenObjects[b.player][0].center
//                disc.text = game.chosenCurrency + String(b.winnings)
//            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default){(action) in
            print("BV: selected Cancel")
            confirmed = false
            self.rollbackTransaction()
        }
        alert.addAction(confirmBet)
        alert.addAction(cancel)
        game.vcHandle!.present(alert, animated: true, completion: nil)
        
        return confirmed
    }
    
    
    public func goldDisc(x: CGFloat, y: CGFloat) -> UITextField {
        let gd = UITextField(frame: CGRect(x: x, y: y, width: 16, height: 16))
        gd.backgroundColor = .yellow
        gd.layer.cornerRadius = 8
        gd.text = game.chosenCurrency
        gd.textColor = .blue
        gd.textAlignment = NSTextAlignment.center
        gd.font = UIFont(name: game.bodyFont, size: 10)
        allDiscs.append(gd)
        return gd
    }
    
    public func prepareBookieBoard() {
        setPlayers()
        for l in playerLabels {
            l.clipsToBounds = true
            l.layer.cornerRadius = 5.0
            l.isEnabled = false
        }
        for o in oddsLabels {
            o.clipsToBounds = true
            o.layer.cornerRadius = 5.0
            o.isEnabled = false
        }
        for s in stakeLabels {
            s.clipsToBounds = true
            s.layer.cornerRadius = 5.0
            s.isEnabled = true
            s.textColor = UIColor.black
            s.backgroundColor = UIColor.white
        }
        
        for w in winLabels {
            w.clipsToBounds = true
            w.layer.cornerRadius = 5.0
            w.isEnabled = false
        }
        
        bluifyOutlet.isEnabled = false

        setOdds()
    }
    
    
    public func niceifyTVs() {
        
        p1.clipsToBounds = true
        p1.layer.cornerRadius = 5.0
        p2.clipsToBounds = true
        p2.layer.cornerRadius = 5.0
        p3.clipsToBounds = true
        p3.layer.cornerRadius = 5.0
        p4.clipsToBounds = true
        p4.layer.cornerRadius = 5.0
        p1Odds.clipsToBounds = true
        p1Odds.layer.cornerRadius = 5.0
        p2Odds.clipsToBounds = true
        p2Odds.layer.cornerRadius = 5.0
        p3Odds.clipsToBounds = true
        p3Odds.layer.cornerRadius = 5.0
        p4Odds.clipsToBounds = true
        p4Odds.layer.cornerRadius = 5.0
        p1Stake.clipsToBounds = true
        p1Stake.layer.cornerRadius = 5.0
        p2Stake.clipsToBounds = true
        p2Stake.layer.cornerRadius = 5.0
        p3Stake.clipsToBounds = true
        p3Stake.layer.cornerRadius = 5.0
        p4Stake.clipsToBounds = true
        p4Stake.layer.cornerRadius = 5.0
        p1Winnings.clipsToBounds = true
        p1Winnings.layer.cornerRadius = 5.0
        p2Winnings.clipsToBounds = true
        p2Winnings.layer.cornerRadius = 5.0
        p3Winnings.clipsToBounds = true
        p3Winnings.layer.cornerRadius = 5.0
        p4Winnings.clipsToBounds = true
        p4Winnings.layer.cornerRadius = 5.0
        bluifyOutlet.clipsToBounds = true
        bluifyOutlet.layer.cornerRadius = 5.0
    }
    
    @IBOutlet weak var bluifyOutlet: UIButton!
    
    
    public func setPlayers() {
        playerLabels = [p1,p2,p3,p4,p5,p6]
        oddsLabels = [p1Odds,p2Odds,p3Odds,p4Odds,p5Odds,p6Odds]
        stakeLabels = [p1Stake,p2Stake,p3Stake,p4Stake,p5Stake,p6Stake]
        winLabels = [p1Winnings,p2Winnings,p3Winnings,p4Winnings,p5Winnings,p6Winnings]
        stacks = [p1SV,p2SV,p3SV,p4SV,p5SV,p6SV]
        for i in 0...game.players-1 {
            let sb = getStreetBet(player: i)
            playerLabels[i].text = game.playerNames[i]
            oddsLabels[i].text = sb.pOddsStr
        }
        for j in game.players...5 {
            playerLabels[j].alpha = 0
            oddsLabels[j].alpha = 0
            stakeLabels[j].alpha = 0
            winLabels[j].alpha = 0
        }
        
        setUpLabels()
        bluifyOutlet.isEnabled = false
        for i in 0...game.players-1 {
            stakeLabels[i].backgroundColor = UIColor.white
            stakeLabels[i].textColor = UIColor.black

            
        }
    }
    
    public func setUpLabels() {
   /*     var s : Int = 0
        let sesh = CareerBetting.sharedCareer.currentSession?.sessionNo
        s = CareerBetting.sharedCareer.currentSession!.sessionNo */
    //    print("UB: s is \(s), sesh is \(String(describing: sesh))")
 
        sessionLabel.text = "Session: \(CareerBetting.sharedCareer.currentSession!.sessionNo)"
        gameLabel.text = "Game: \(String(describing: CareerBetting.sharedCareer.currentSession!.currentGame!.gameNo))"
        streetLabel.text = "Card: \(String(describing: CareerBetting.sharedCareer.currentSession!.currentGame!.currentStreet))"
    }
    
    public func setOdds() {
      /*  playerLabels = [p1,p2,p3,p4,p5,p6]
        oddsLabels = [p1Odds,p2Odds,p3Odds,p4Odds,p5Odds,p6Odds]
        stakeLabels = [p1Stake,p2Stake,p3Stake,p4Stake,p5Stake,p6Stake]
        winLabels = [p1Winnings,p2Winnings,p3Winnings,p4Winnings,p5Winnings,p6Winnings] */
        setUpLabels()
        
        switch thisGame!.currentStreet {
        case 3:
            for i in 0...game.players-1 {
                oddsLabels[i].text = thisGame!.street3Bets[i].pOddsStr
            }
        case 4:
            for i in 0...game.players-1 {
                oddsLabels[i].text = thisGame!.street4Bets[i].pOddsStr
            }
        case 5:
            for i in 0...game.players-1 {
                oddsLabels[i].text = thisGame!.street5Bets[i].pOddsStr
            }
        case 6:
            for i in 0...game.players-1 {
                oddsLabels[i].text = thisGame!.street6Bets[i].pOddsStr
            }
        case 7:
            for i in 0...game.players-1 {
                oddsLabels[i].text = thisGame!.street7Bets[i].pOddsStr
            }
        default:
            for i in 0...game.players-1 {
                oddsLabels[i].text = thisGame!.street3Bets[i].pOddsStr
            }
        }
        
        for j in game.players...5 {
            playerLabels[j].alpha = 0
            oddsLabels[j].alpha = 0
            stakeLabels[j].alpha = 0
            winLabels[j].alpha = 0
        
        }

    }
    
 
    @IBAction func bluifytv(_ sender: Any) {
        betAlert(bets: buffer, disc: betPlacedDisc)
    }
    
 
    override func awakeFromNib() {


        thisGame = CareerBetting.sharedCareer.currentSession!.currentGame!

        prepareBookieBoard()
    }
    
    
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
