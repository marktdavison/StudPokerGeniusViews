//
//  MoreInfoViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 30/04/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let cr : CGFloat = 10
    

    @IBOutlet weak var upperLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var infoTV: UITextView!

    
    let whyText = "This App delivers the chances of achieving any of hand.  It does so at any point in the game.  And it does so with a very high degree of accuracy.  Most poker players resort to and trust their gut instinct... this is why most poker players lose.\n\nGain an appreciation of the real odds you have of achieving aany hand and you will improve your play."
    
    let appProblemText = "The problem that this app is concerned with is partially probability but largely combinatorics. \nCombinatorics is the essential precursor to understanding the probability of any given event.  The way you count the possible outcomes differs depending upon the nature of the problem. \nOur problem is to understand the probability of getting any one of the 9 possible hands, at any betting point in a game of stud poker, depending upon what the known and unknown cards are in the deck at that moment. \nFirstly, therefore we need to know how many possible outcomes there are in a game of 7-card Stud as this will act as the denominator in our probability calculation. \nThe answer depends on 2 factors that are features of stud poker: \n1. It does not matter what order the cards come in (a 10, J, Q is the same as a Q, J, 10)\n2. When a card is dealt it cannot be redealt - repetition is not allowed.  For mathematical problems of this nature we use Hypergeometric Distribution to count the outcomes."
    

    
    let hyperGeoText = "If there were no restrictions then the number of outcomes would simply be the factorial of 52 (the number of cards in the deck).  In other words 1x2x3x…50x51x52, or 52! for short. Factorials rise steeply to become fairly big numbers as you can tell from this illustration\n6! = 1 x 2 x 3 x 4 x 5 x 6 = 620\n7! = 6! x 7 = 5,040\n8! = 7! x 8 = 40,320\nThe factorial of 52 doesn’t make much sense when you see it written in long-hand, best to think of it as around about 8 to the par of 67."
    
    

    let aboutVersionText = "This is Odds4Poker - Seven Card Stud\n\nRelease Date 5th July 2018\n\nVersion O4P-7CS-1.0"
    
    let accuracyText = "It is useful to illustrate the problems related to assessing accuracy with an example.\n\nLet us a 6-player game is in progress with 1 card yet to be dealt and nobody has folded.  36 cards will have been dealt, as a player you can see your own hole cards but none of your opponents: so 26 cards are visible to you and 26 are hidden. Your best hand is currently a King high, but as you also have a 10, Jack and Queen you are still on for a straight, your other cards are 6 and 8. You look at the visible cards: no 9s or Aces are out.  The chance of you getting a run is 8 in 26 - just over 30%.  Easy - there are just 26 alternatives and we can know intuitively that that figure is accurate!  The challenge of accuracy becomes clearer however when we consider the odds of a run after only 3 cards have been dealt.  \nIf your first 3 cards had been 6, 8 and King then there were several possible straights to assess:\n\t2,3,4,5,6\n\t3,4,5,6,7\n\t4,5,6,7,8\n\nIn short, there would be a very great number of combinations that could give you a straight.\n\nThe next card will be 1 in 44, the next 1 in 38, the next 1 in 32 and the last 1 in 26.In other words 4 in 44*38*32*26 = nearly 1.4m alternatives.  Odds4Poker looks at each of these combinations and assesses its likelihood.  Great care and attention has gone into achieving an excellent degree of accuracy, however, there will be the occassional combination that we will have missed."
    
    let accuracyText2 = "There is a surrogate measure that is simple and fairly effective means of knowing how accurate the results of the Odds4Poker are.\nWhen the odds of the 9 possible hands are calculated they should theoretically add up to 100%. (Each such group of calculations is a single data point.) If they add up to 50% or 150% then you can know that the results are worthless.  However, POdds4Poker results  trend towards 101.5% after a few dozen data points are assessed.  As they are just over 100% it suggests that certain combinations are being assessed as making up 2 different hands.  The worst accuracy levels are, as one might expect at the earliest cards.  At Odds4Poker we are committed to improving the level of accuracy to its absolute maximum."
    
    
    let sevenCardStudText = "Considered a much more skilful game than Texas Holdem, Seven Card Stud is among the most popular variants of Poker worldwide.\nEach Player receives two hole cards and an upcard before betting commences. Another upcard is followed by a betting round on three more occasions and then finally another hole card with the final round of betting.  There are a number of variations to this theme."
    
    let probability7CSText = "Before a card is dealt the odds of a player getting any Poker hand in 7-Card Stud, are the following:\n\n\tStraight Flush: 0.03%\n\tPoker (4 of a kind): 0.17%\n\tFull House: 2.60%\n\tFlush: 3.03%\n\tStraight (aka Run): 4.62%\n\tTrips (three of a kind): 4.83%\n\tTwo Pair: 23.5%\n\tPair: 43.8%\n\tHigh Card: 17.4%\n\nAs soon as the first card is dealt however, the odds change.  Odds4Poker  allows you to see how they change, dynamically, as each card is dealt."
    
    
    let futureFeaturesText = "Dependent upon interest there may be a version of the Odds4Poker for 5-Card Stud and for Texas Hold'em"
    
    let knownIssuesText = "\nFavourites Table - entries not deleting.\n\nLandscape mode - player anchors lose integrity so disabled for time being.\n\nOddsViewController - disabled Perspective UISwitch\n\nPlayer name not appearing in Odds Pop-up"
    
    
    let appPrefsText = "Odds can be represented in different formats:\n1. Percentages (the default) - also known as Implied Probability, e.g. 25%\n2. Decimal Odds as used throughout much of Europe e.g. 4.00\n3. Fractional Odds (as used in the UK) e.g. 3 to 1 or 3/1\n4. Moneyline odds, variants of which are used in the US and Asia, e.g. +300\nAll the examples above represent the same probability.\n\nUse the Settings screen to select the number of players you want in your simulated game - you may also name them.\n\nUse the Settings screen to hide/show probability information on the main screen.  This probability info takes into account the cards dealt in-the-hole to each player so if you wish to recreate the actual knowledge you would have about an opponents hand in a real game, you may want to hide this."
    
    
    let appGamePlayText = "Odds4Poker simulates a game of 7-Card Poker with 2 hole cards and one face-up card to begin. Then each remaining card is dealt up individually until the last which is dealt down.\n\nThe order of the deck is randomly generated.  There are no wild cards.  The dealing order is the same in each round.\n\nAs each card is dealt Odds4Poker calculated the probability that a player will end up with each of the 9 possible poker hands. I.e. High Card, Pair, 2-Pair, Trips, Straight, Flush, Full House, Poker, Straight Flush (of which Royal Flush is the best).\n\nAs the game progresses, some information for each player is shown on the main screen\n\n\t-The Best or Maximum hand that this player can achieve.\n\n\t-The Worst or Minimum hand\n\n\t-The hand with the highest probability of being achieved."
    
    let appOddsViewText = "Although the main screen can show some information on the likelihood of achieving certain hands, it is the Odds View Pop-up that provides the richest info.\n\nA Table is presented:\n\n- The first column lists the 9 possible Poker hands in order of best-to-worst.\n- The second column gives the standard probabilities for achieving any hand at the outset of 7-Card Stud before a card is dealt\n- The third column shows the odds of getting any hand at the first betting point of the game which is when the 3rd card is dealt (aka 3rd Street)\n- Each subsequent column is displayable when the 4th, 5th and 6th cards are dealt."
    
    
    
    
    
  
    let hyperGeoTextold = "If there were no restrictions then the number of outcomes would simply be the factorial of 52 (the number of cards in the deck).  In other words 1x2x3x…50x51x52, or 52! for short. Factorials rise steeply to become fairly big numbers as you can tell from this illustration\n6! = 1 x 2 x 3 x 4 x 5 x 6 = 620\n7! = 6! x 7 = 5,040\n8! = 7! x 8 = 40,320\nThe factorial of 52 doesn’t make much sense when you see it written in long-hand, best to think of it as around about 8 to the par of 67."
    
    let hyperGeoTextA = "This allow us to know the chance of an event given 4 pieces of information - in 7 Card Stud these equate to:\n\n1. How many cards can give you your target hand (Outs)\n2. How many cards are yet to come (Draws)\n\n3. How many cards are available to be selected from. Note: in 7-Card Stud we need to assume cards dealt in-the-hole to your opponents are still available. (Deck Size)\n\n4. How many of the target cards you require. (Matches)"
    
    let navigationText = "As screen area is at a premium for this App, navigation is generally achieved via swiping right to reveal a series of menu options and swiping left to hide it.\n\nDuring the time that the menu is revealed the screen is disabled.\n\nWhen the game is in progress you may see the detailed Odds information by pressing on any hand - a grey pop-up will appear.\n\nYou can reveal the hole cards for any player by swiping right on that hand, and swiping left to hide them."
    
    let dataPolicyText = "Odds4Poker does not store any information that could uniquely identify any user. Information that is held is done so for the purpose of understanding how the App is used.  All this information is shown on the System Information screen."
    
    let hyperGeoTextB = "A Simple Example:\n6 Cards have been dealt to each of the 4 players.\nYou have four to a run - 8, 9, 10, Jack - so you are looking for the outside cards: a 7 or a Queen\n\nYou can see from the cards dealt up to your opponents that no 7s or Queens have been dealt up, therefore there are 8 cards in the deck that you cannot see. \n\nThe numbers to put into the hypergeometric calculation are:\n\nDRAWS: 6 cards have been dealt so only 1 card to go\n\nOUTS: Any of the four 7s or any of the 4 Jacks will give you your hand, so 8.\n\nDECK SIZE: 24 cards have been dealt leaving 28 in the pack.  However, 6 of the dealt cards are invisible to you (your opponents hole cards) so you must treat them as in the deck, so 34\n\nMATCHES: you need only one of the outs to make a run so, 1\n\nThe answer returned is 23.5%"
    
    
    let calcOddsText = "The number of possible combinations of 7 cards in a 7-Card Poker game, such as Texas Hold'em or Stud, is  133,784,560. \nThe problem that this app is concerned with is partially probability but largely combinatorics. \nCombinatorics is the essential precursor to understanding the probability of any given event.  The way you count the possible outcomes differs depending upon the nature of the problem. \nOur problem is to understand the probability of getting any one of the 9 possible hands, at any betting point in a game of stud poker, depending upon what the known and unknown cards are in the deck at that moment."
    

    
   
    let mainScreenText = "This is where you play a game of 7-Card Poker. \nYou can change the number of players in the game via Settings and also name them.\nYou can see a subset of Odds information for each player - this can be hidden via Settings.  The Odds information is dynamically updated as each card is dealt.\nAs the game finishes - on dealing of the 7th Card - the 2 worst cards are discarded and the best 5 are selected.  The best hand overall is animated to the top of the screen."
    
    


 
    let favouriteText = "You may wish to save a particular game - to do so select the Add To Favourites button which appears at the end of each game.  This adds it to a stored list.\n\nYou may replay the game at any time by selecting the Favourites menu item and picking the game from the list.\n\nAs you play it there will be a maroon banner across the bottom of the screen to ensure that anyone viewing the screen is aware that it is a reloaded game\n\nNote: When you reload a game you are starting the game with cards in the same order as they were for the previous game.  If you decide to run it with a different number of players then of course the outcome shall be different"
    
    let appGamePlayText1 = "Odds4Poker is not a game, and is not intended to be used in that manner, but as it does use simulated gameplay to illustrate the real odds of poker it is feasible to use it that way with certain restrictions, for instance:\n- At present there is no way for a player to  fold.\n- Dealing always starts with the player in the top leftmost position\n - Anyone looking at the screen can potentially see summary information that would be private to that player (although there is a Setting to hide this summary info).\n - there is no way to bet through this app.\n\nHowever, if you simply wish to use the app as a substitute for dealing random cards from a deck of cards, there is no reason why you should not."
    
    let oddsViewText = "A Pop-up is displayed showing a grid of the poker hands, from best to worse.  Each row shows the odds of ending the game with each of those hands.\nThe first column are Pre-game odds - i.e. the odds as they would be before a card is dealt.\nThe second column showns the odds at the first betting point, i.e. when the 2 hole cards and first public card are dealt - also known as 3rd Street.\nThe next 3 columns show the odds at the next 3 betting points (4th, 5th and 6th Streets).\nThe example below illustrates how the odds for a flush shift:\nOn 4th St. - with 4 to a flush and 3 cards to go, the odds are 40% of getting a flush.\nBut by 6th St.the odds have fallen back to just over 1 in 4."
    
    let appReplaceCardText = "Odds4Poker allows you to mimic a specific game by replacing the next cards to be dealt.\n\nThe Replaced Card screen lets you select the cards you wish to replace for each player.\n\nYou may only insert cards that have not already been dealt."
    
    let appDeckViewText = "The Deck View allows you to see which cards have been dealt already.\n\nYou may opt to only see cards that have been dealt up, or you may toggle using the Switch Button to see the cards that have been deal in-the-hole also.\n\nThis is useful if you want to see how many of your Target cards have already been dealt."
    
    let appCalculatorText = "Odds4Poker uses a technique from Probability Theory called Hypergeomtric Distribution to calculate the chances of drawing the required cards to make any hand.\n\nA Hypergeomtric calculator is included in this App to allow you to calculate the chances of selecting any number of instances from a known population with any number of trials."
    

    let topicsArray = ["Calculation",  "Version",   "Application"]
    
    let subTopicsArray = [["Calculating Odds", "HyperGeometric Distribution", "Probability of Hands"], ["About this Version", "Accuracy","Future Features", "Known Issues"], ["Preferences", "Gameplay", "Odds View", "Replacing Cards", "Deck View", "Calculator"]]
    
    let topicsDict = [
        "Calculation": ["Calculating Odds", "HyperGeometric Distribution", "Probability of Hands"],
        "Version" : ["About this Version", "Accuracy","Future Features", "Known Issues"],
        "Application" : ["Settings", "Gameplay", "Odds View", "Replacing Cards", "Deck View", "Calculator"]
    ]
    let calcTopics = ["Calculating Odds", "HyperGeometric Distribution", "Probability of Hands"]
    
    let versTopics = ["About this Version", "Future Features", "Known Issues"]
    
    let application = ["Settings", "Gameplay", "Odds View", "Replacing Cards", "Deck View", "Calculator"]
   // var selectedTopic : String()
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return topicsArray.count
        } else {
            let selectedTopic = pickerView.selectedRow(inComponent: 0)
            let arr = topicsDict[topicsArray[selectedTopic]]
            return (arr?.count)!
        }
        return 6
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        print("MIVC: in picker")
        let lab : UILabel
        if let label = view as? UILabel { //never happens???
            lab = label
        } else {
            lab = UILabel()
        }
        lab.backgroundColor = UIColor.clear
        lab.sizeToFit()
        print("MIVC: component = \(component) and row = \(row)")
        if component ==  0 {
            lab.text = self.topicsArray[row]
            topicPicker.reloadComponent(1)
        } else {
            let selectedTopic = topicPicker.selectedRow(inComponent: 0)
            let arr = topicsDict[topicsArray[selectedTopic]]
            lab.text = arr?[row]
        }
    //    lab.text = self.subTopicsArray[component][row]

        switch lab.text {
        case "Calculating Odds":
            infoTV.text = appProblemText
        case "HyperGeometric Distribution":
            infoTV.text = hyperGeoText
        case "Known Issues":
            infoTV.text = knownIssuesText
        case "About this Version":
            infoTV.text = aboutVersionText
        case "Accuracy":
            infoTV.text = accuracyText
        case "Settings":
            infoTV.text = appPrefsText
        case "Gameplay":
            infoTV.text = appGamePlayText
        case "Odds View":
            infoTV.text = appOddsViewText
        case "Future Features":
            infoTV.text = futureFeaturesText
        default:
            infoTV.text = whyText
        }
        
        
        return lab
        
    
    }
    
    @IBOutlet weak var topicPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicPicker.reloadComponent(0)
        // Do any additional setup after loading the view.
        topicPicker.layer.cornerRadius = cr
        upperLabel.layer.cornerRadius = cr
        contactButton.layer.cornerRadius = cr
        infoTV.layer.cornerRadius = cr
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
