//
//  LeadersViewController.swift
//  StudPokerGenius
//
//  Created by Mark Davison on 17/06/2019.
//  Copyright © 2019 anditwasso. All rights reserved.
//

import UIKit

class LeadersViewController: UIViewController {
 
    @IBOutlet weak var desc: UILabel!
    
    var anchor1 = CGPoint()
    var selectedStreet = Int()
    var origXY = CGPoint()
    var origY = CGPoint()
    var leaderLabels = [UILabel]()
    var pos: Int = 1
    public typealias boardTuple = (Int, String, String, String, Double, Int, String, Int)
    var selectedBoard = [boardTuple]()
    var labelCentre = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedStreet = game.street
        selectedBoard = game.allCurrentHands
        setBoardSelection(board: "Now")
        setStreetSelection(street: game.street)
        print("lvc: this one is for github Street is \(game.street)")
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        buildLeaderLabels(labelNo: sortedBoard.count)
        writeLeaderLabels(board: sortedBoard)
        var i = 0
        for lab in sortedBoard {
            self.moveLabel(newPos: i, playerLabel: lab.7)
            i += 1
        }
    }

    public func setStreetSelection(street: Int) {
        switch street {
        case 3:
            outletThird.isSelected = true
            outletFourth.isSelected = false
            outletFifth.isSelected = false
            outletSixth.isSelected = false
            outletSeventh.isSelected = false

        case 4:

            outletFourth.isSelected = true
            outletThird.isSelected = false
            outletFifth.isSelected = false
            outletSixth.isSelected = false
            outletSeventh.isSelected = false
            
        case 5:

            outletFifth.isSelected = true
            outletFourth.isSelected = false
            outletThird.isSelected = false
            outletSixth.isSelected = false
            outletSeventh.isSelected = false
            
        case 6:

            outletSixth.isSelected = true
            outletFourth.isSelected = false
            outletThird.isSelected = false
            outletFifth.isSelected = false
            outletSeventh.isSelected = false
            
        case 7:

            outletSeventh.isSelected = true
            outletFourth.isSelected = false
            outletThird.isSelected = false
            outletFifth.isSelected = false
            outletSixth.isSelected = false
            
        default:
            outletThird.isSelected = true
        }
        if game.street < 4 {
            outletFourth.isEnabled = false
            outletFifth.isEnabled = false
            outletSixth.isEnabled = false
            outletSeventh.isEnabled = false
        } else if game.street < 5 {
            outletFifth.isEnabled = false
            outletSixth.isEnabled = false
            outletSeventh.isEnabled = false
        } else if game.street < 6 {
            outletSixth.isEnabled = false
            outletSeventh.isEnabled = false
        } else if game.street < 7 {
            outletSeventh.isEnabled = false
        }
    }

    
    public func setBoardSelection(board: String) {
        switch board {
        case "Now":
            outletNow.isSelected = true
            outletProb.isSelected = false
            outletBest.isSelected = false
            outletAnalyse.isSelected = false
            if game.street < 7 {
//                outletProb.isEnabled = false
                outletAnalyse.isEnabled = false
            }
            
        case "Prob":
            outletNow.isSelected = false
            outletProb.isSelected = true
            outletBest.isSelected = false
            outletAnalyse.isSelected = false
            if game.street < 7 {
                //                outletProb.isEnabled = false
                outletAnalyse.isEnabled = false
            }
        case "Best":
            outletNow.isSelected = false
            outletProb.isSelected = false
            outletBest.isSelected = true
            outletAnalyse.isSelected = false
            if game.street < 7 {
                //                outletProb.isEnabled = false
                outletAnalyse.isEnabled = false
            }
        case "Analyse":
            outletNow.isSelected = false
            outletProb.isSelected = false
            outletBest.isSelected = false
            outletAnalyse.isSelected = true
            if game.street < 7 {
                //                outletProb.isEnabled = false
                outletAnalyse.isEnabled = false
            }

        default:
            outletNow.isSelected = true
            outletProb.isSelected = false
            outletBest.isSelected = false
            outletAnalyse.isSelected = false
            if game.street < 7 {
                //                outletProb.isEnabled = false
                outletAnalyse.isEnabled = false
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if game.portraitWidth < 500 {
            self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 400)
        } else {
            self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width / 1.5, height: 400)
        }
        self.view.layer.cornerRadius = 5
        
        
    }
    
    func anim8(l: UILabel, duration: Double, hue: CGColor){
        
        
        CATransaction.begin()
        
        let layer : CAShapeLayer = CAShapeLayer()
        layer.strokeColor = hue
        layer.lineWidth = 8.0
        layer.fillColor = UIColor.clear.cgColor
        
        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 250 , height: 25), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
        layer.path = path.cgPath
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.3
        animation.toValue = 1.2
        
        animation.duration = duration
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock{ [weak l] in
            print("Animation completed")
        }
        
        layer.add(animation, forKey: "myStroke")
        CATransaction.commit()
        l.layer.addSublayer(layer)
    }
    
    
    func moveLabel(newPos: Int, playerLabel: Int){
        
        let lab : UILabel = leaderLabels[playerLabel-1]
        let newCenter : CGPoint = labelCentre[newPos]
        UIView.animate(withDuration: 2) {
            lab.center = newCenter
        }
        
    }
    
    
    
    @IBAction func close(_ sender: Any) {
        print("LVC: tidying up now")
        leaderLabels.removeAll()
    }
    
    
    @IBOutlet weak var outletNow: UIButton!
    
    @IBAction func now(_ sender: Any) {
        setBoardSelection(board: "Now")
        for i in 0..<leaderLabels.count {
            anim8(l: leaderLabels[i], duration: 1.0, hue: UIColor.red.cgColor)
        }
        selectedBoard = game.allCurrentHands
        outletNow.isSelected = true
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    @IBOutlet weak var outletBest: UIButton!
    
    @IBAction func best(_ sender: Any) {
        setBoardSelection(board: "Best")

        for i in 0..<leaderLabels.count {
            anim8(l: leaderLabels[i], duration: 1.0, hue: UIColor.green.cgColor)
        }
        selectedBoard = game.allBestHands
        outletBest.isSelected = true

        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    
    @IBOutlet weak var outletProb: UIButton!
    
    @IBAction func prob(_ sender: Any) {
        setBoardSelection(board: "Prob")

        for i in 0..<leaderLabels.count {
            anim8(l: leaderLabels[i], duration: 1.0, hue: UIColor.yellow.cgColor)
        }
        
        selectedBoard = game.allLikelyHands
// capture highest current hand
// capture highest current player
// capture highest current handValue
// capture highest uniqueHandRef = highRef
// for each of the other hands calculate the probability of the getting something better.
        // wouldn't need to do this in HANDS:CHO? - this may not be possible :-(
        
        // for p in player
        //      if uniqueHandRef != highRef
        //          p.hand.odds.  all those above high value but hand value is not held... we'd have to ccyle through odds.. for that card.. jeez
        
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    
    @IBOutlet weak var outletAnalyse: UIButton!
    
    @IBAction func analyse(_ sender: Any) {
        setBoardSelection(board: "Analyse")

        anim8(l: leaderLabels[3], duration: 0.5, hue: UIColor.green.cgColor)
        outletAnalyse.isSelected = true

    }
    
    @IBAction func third(_ sender: Any) {
        selectedStreet = 3
        setStreetSelection(street: selectedStreet)
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    @IBOutlet weak var outletThird: UIButton!
    
    @IBAction func fourth(_ sender: Any) {
        if game.street < 4 {return}
        selectedStreet = 4
        setStreetSelection(street: selectedStreet)
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
//        buildLeaderLabels(board: sortedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    @IBOutlet weak var outletFourth: UIButton!
    
    @IBAction func fifth(_ sender: Any) {
        if game.street < 5 {return}

        selectedStreet = 5
        setStreetSelection(street: selectedStreet)
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    @IBOutlet weak var outletFifth: UIButton!
    
    @IBAction func sixth(_ sender: Any) {
        if game.street < 6 {return}

        selectedStreet = 6
        setStreetSelection(street: selectedStreet)
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }
    
    @IBOutlet weak var outletSixth: UIButton!
    
    @IBAction func seventh(_ sender: Any) {
        if game.street < 7 {return}

        selectedStreet = 7
        setStreetSelection(street: selectedStreet)
        let sortedBoard = sortLeaders(handsIn: selectedBoard)
        UIView.animate(withDuration: 4) {
            self.writeLeaderLabels(board: sortedBoard)
            var i = 0
            for lab in sortedBoard {
                self.moveLabel(newPos: i, playerLabel: lab.7)
                i += 1
            }
        }
    }

    @IBOutlet weak var outletSeventh: UIButton!
    

    public func sortLeaders(handsIn: [boardTuple])-> ([boardTuple]) {
        // street can = 3,4,5,6 or 7
        // range is 0..player-1, players..players+players -1,
        var boardOut : [boardTuple]
        boardOut = handsIn.filter{$0.0==selectedStreet}

        
        for i in 0..<boardOut.count {
            for j in 1..<boardOut.count {
                if boardOut[j].5 < boardOut[j-1].5 {

                    let temp = boardOut[j-1]
                    boardOut[j-1] = boardOut[j]
                    boardOut[j] = temp
                }
            }
        }
        boardOut.reverse()
        var tiesCount = 0
        var pos = 1
        for b in 0...boardOut.count - 1 {
            if b == boardOut.count - 1 {
                if tiesCount > 0 { // handles last item being tie
                    boardOut[b].6 = "\t=\(pos): "
                } else {
                    boardOut[b].6 = "\t\(pos): "
                }
            } else {
                if boardOut[b].5 == boardOut[b+1].5 {
                    tiesCount += 1
                    boardOut[b].6 = "\t=\(pos): "
                    
                } else {
                    if tiesCount > 0 {
                        boardOut[b].6 = "\t=\(pos): "
                        pos = pos + 1 + tiesCount
                        tiesCount = 0

                    } else {
                        boardOut[b].6 = "\t\(pos): "
                        pos = pos + 1

                    }
                }
            }

        }
        return boardOut
    }
    

    
    public func buildLeaderLabels(labelNo: Int) {
        
        var verticalOffset = 60.0
        for i in 0 ... labelNo - 1 {
            let p = CGPoint(x: 37.5, y: verticalOffset)
            verticalOffset += 60.0
            let l : UILabel = UILabel()
            leaderLabels.append(l)
            l.frame = CGRect(x: p.x, y:p.y, width: 250, height: 25)
            labelCentre.append(l.center)
            l.backgroundColor = UIColor.darkGray
            l.textColor = UIColor.white
            l.layer.masksToBounds = true
            l.layer.cornerRadius = 10.0
            l.font = UIFont(name: "Rockwell", size: game.chosenFontSize)
            self.view.addSubview(l)
            
            pos += 1
            
        }
    }
    public func writeLeaderLabels(board: [boardTuple]) {
        if board.count != leaderLabels.count {
            print("LVC: Error mismatch in numbers of labels and players")
            return
        }
        // associates a label with a player
        
        for player in 0 ... board.count-1 {
            let currentLabel = board[player].7 - 1
            leaderLabels[currentLabel].text = "\(board[player].6) \(board[player].1): \(board[player].2) - \(String(format: "%.1f", 100 * board[player].4) + "%")"
            
        }
        
    }
        
//
//
//        let imageMask = CAShapeLayer()
//        let lineWidth = 5
//        let inset = lineWidth + 3
//        let insetBounds = l.bounds.insetBy(dx: CGFloat(inset), dy: CGFloat(inset))
//        let maskPath = UIBezierPath(roundedRect: l.frame, cornerRadius: 10.0)
//        imageMask.path = maskPath.cgPath
//        imageMask.frame = l.bounds
//
//        labelInQuestion = l
        
        /*
        let p2 = CGPoint(x: 37.5, y: 151.2)
        let l2 : UILabel = UILabel()
        l2.frame = CGRect(x: p2.x, y:p2.y, width: 200, height: 25)
        l2.backgroundColor = UIColor.darkGray
        l2.textColor = UIColor.white
        l2.layer.masksToBounds = true
        l2.layer.cornerRadius = 10.0
        l2.font = UIFont(name: "Rockwell", size: game.chosenFontSize)
        l2.text = "\t2. \(game.allCurrentHands[1].0): \(game.allCurrentHands[0].1) - \(String(format: "%.1f", 100 * game.allCurrentHands[1].3) + "%")"
        self.view.addSubview(l2)
        otherLabelInQuestion = l2 */
    

//    public func buildScreenObjects(anchors: [CGPoint]) -> [[UILabel]]{
//        var wide = Int()
//        var high = Int()
//
//        let adjOptX = Int(wide / 60) // 5
//        let adjOptY = Int(Double(high) / 3.3) //200
//        let adjActX = 0
//        let adjActY = Int(high / 22) //20
//        let adjCardX = -Int(wide / 7) // - 50
//        let adjCardY = Int(high / 4) // 120
//        var counter : Int = 0
//        var playerLabels = [UILabel]()
//        var allLabels : [[UILabel]] = []
//        for a in anchors {
//            playerLabels = []
//            let l : UILabel = UILabel() // the l label holds the Player's Name
//            counter += 1
//            l.frame = CGRect(x: Int(a.x), y: Int(a.y), width: wide/2, height: 60)
//            l.textColor = UIColor.white
//            l.textAlignment = NSTextAlignment.left
//            //    l.text = "Player \(counter)"
//            l.text = game.playerNames[counter - 1]
//            self.view.addSubview(l)
//            playerLabels.append(l)
//
//            let o : UILabel =    UILabel() // Label o holds the 3 options: best, worst, most likely
//            o.frame = CGRect(x: Int(a.x) + adjOptX, y: Int(a.y) + adjOptY, width: wide/2, height: 50)
//            //  o.backgroundColor = UIColor.orange
//            o.textColor = UIColor.white
//            o.numberOfLines = 3
//            o.textAlignment = NSTextAlignment.left
//            o.text = "Some options"
//            o.font = UIFont(name: "Rockwell", size: game.chosenFontSize)
//            self.view.insertSubview(o, belowSubview: self.view)
//            //   self.view.addSubview(o)
//            // self.view.sendSubview(toBack: o)
//            playerLabels.append(o)
//            game.mainScreenOddsLabels.append(o)
//            let act : UILabel = UILabel()  // label act holds the actual hand at that point in time
//            act.frame = CGRect(x: Int(a.x) + adjActX, y: Int(a.y) + adjActY, width: wide/2, height: 50)
//            //   act.backgroundColor = UIColor.purple
//            act.textColor = UIColor.white
//            act.alpha = 1
//            act.textAlignment = NSTextAlignment.left
//            act.text = "actual stuff"
//            act.font = UIFont(name: "Rockwell", size: game.chosenFontSize)
//            self.view.addSubview(act)
//            playerLabels.append(act)
//            game.mainScreenOddsLabels.append(act)
//
//            let b : UILabel = UILabel() // label b holds the best hand and is displayed at the end
//            b.frame = CGRect(x: Int(a.x) + adjActX, y: Int(a.y) + adjActY, width: wide/2, height: 28)
//            //      b.backgroundColor = UIColor.cyan
//            b.textColor = UIColor.white
//            b.textAlignment = NSTextAlignment.left
//            b.font = UIFont(name: "Rockwell", size: game.chosenFontSize + 4)
//            b.text = "Bestest stuff"
//            self.view.addSubview(b)
//            playerLabels.append(b)
//            allLabels.append(playerLabels)
//            game.mainScreenOddsLabels.append(b)
//
//        }
//        game.screenObjectsBuilt = true
//
//        print(allLabels[0][1].text)
//        //   game.mainScreenLabels = allLabels
//        return allLabels
//    }
//
//    public func moveScreenObjectsToPortrait(anchors: [CGPoint]) {
//        let adjLWidth = 50
//        let adjLHeight = 30
//        let adjOWidth = 60
//        let adjOHeight = 25
//        let adjBWidth = 68
//        let adjBHeight = 14
//        let adjCardWidth = 30
//        let adjCardHeigth = 45
//
//        let adjOptX = Int(game.portraitWidth / 60) // 5
//        let adjOptY = Int(Double(game.portraitHeight) / 3.3) //200
//        let adjActX = 0
//        let adjActY = Int(game.portraitHeight / 20) //25
//        let adjCardX = Int(game.portraitWidth / 7) // - 50
//        let adjCardY = Int(Double(game.portraitHeight) / 4.3) // 120
//        var counter : Int = 0
//
//        print("Moving screen objects: Dimensions of this screen: Height \(game.portraitHeight), Width \(game.portraitWidth). )")
//        if !game.screenObjectsBuilt {
//            print("Screen Objects Not Built yet")
//            return
//        }
//        //     cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
//
//        UIView.animate(withDuration: 1) {
//            print("In Animation")
//            for p in 0...game.players - 1 {
//                print("Player \(p), x anchor: \(anchors[p].x), y anchor: anchors[p].y")
//                game.playingScreenObjects[p][0].center = CGPoint(x: Int(anchors[p].x) + adjLWidth, y: Int(anchors[p].y) + adjLHeight)
//                //    game.playingScreenObjects[p][1].center = CGPoint(x: 200, y: 100)
//                game.playingScreenObjects[p][1].center = CGPoint(x: Int(anchors[p].x) + adjOptX + adjOWidth, y: Int(anchors[p].y) + adjOptY + adjOHeight)
//                game.playingScreenObjects[p][2].center = CGPoint(x: Int(anchors[p].x) + adjActX + adjOWidth, y: Int(anchors[p].y) + adjActY + adjOHeight)
//                game.playingScreenObjects[p][3].center = CGPoint(x: Int(anchors[p].x) + adjActX + adjBWidth, y: Int(anchors[p].y) + adjActY + adjBHeight)
//
//                for ac in self.activeCards {
//                    var fan : CGFloat = 0
//                    if ac.cardNo > 1 {
//                        fan = CGFloat(ac.cardNo - 1) * 0.25
//                    }
//                    print("mSOTP: ac.player is \(ac.player) and p is \(p)")
//                    if ac.player - 1 == p {
//
//                        self.dealDisplayedCard(playerNo: p, xPos: anchors[p].x, yPos: anchors[p].y + CGFloat(adjCardY), splay: fan, ci: ac.screenCard)
//                    }
//                }
//                //           cardImage.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
//
//
//
//
//            }
//
//        }
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
