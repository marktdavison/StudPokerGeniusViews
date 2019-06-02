//
//  AboutVCViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 02/10/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit

class AboutVCViewController: UIViewController, SideMenuDelegate {

    @IBOutlet weak var newTV: UITextView!
    @IBOutlet weak var upperTV: UITextView!
    
    @IBOutlet weak var lowerScrollView: UIScrollView!
    
 //   @IBOutlet weak var lowerTV: UITextView!
    
    let appProblemText = "\nFirstly, therefore we need to know how many possible outcomes there are in a game of 7-card Stud as this will act as the denominator in our probability calculation. \nThe answer depends on 2 factors that are features of stud poker: \n1. It does not matter what order the cards come in (a 10, J, Q is the same as a Q, J, 10)\n2. When a card is dealt it cannot be redealt - repetition is not allowed.  For mathematical problems of this nature we use Hypergeometric Distribution to count the outcomes."
    
    let hyperGeoTextold = "If there were no restrictions then the number of outcomes would simply be the factorial of 52 (the number of cards in the deck).  In other words 1x2x3x…50x51x52, or 52! for short. Factorials rise steeply to become fairly big numbers as you can tell from this illustration\n6! = 1 x 2 x 3 x 4 x 5 x 6 = 620\n7! = 6! x 7 = 5,040\n8! = 7! x 8 = 40,320\nThe factorial of 52 doesn’t make much sense when you see it written in long-hand, best to think of it as around about 8 to the par of 67."
    
    let hyperGeoTextA = "This allow us to know the chance of an event given 4 pieces of information - in 7 Card Stud these equate to:\n\n1. How many cards can give you your target hand (Outs)\n2. How many cards are yet to come (Draws)\n\n3. How many cards are available to be selected from. Note: in 7-Card Stud we need to assume cards dealt in-the-hole to your opponents are still available. (Deck Size)\n\n4. How many of the target cards you require. (Matches)"
    
    let navigationText = "As screen area is at a premium for this App, navigation is generally achieved via swiping right to reveal a series of menu options and swiping left to hide it.\n\nDuring the time that the menu is revealed the screen is disabled.\n\nWhen the game is in progress you may see the detailed Odds information by pressing on any hand - a grey pop-up will appear.\n\nYou can reveal the hole cards for any player by swiping right on that hand, and swiping left to hide them."
    
    let dataPolicyText = "Odds4Poker does not store any information that could uniquely identify any user. Information that is held is done so for the purpose of understanding how the App is used.  All this information is shown on the System Information screen."
    
    let hyperGeoTextB = "A Simple Example:\n6 Cards have been dealt to each of the 4 players.\nYou have four to a run - 8, 9, 10, Jack - so you are looking for the outside cards: a 7 or a Queen\n\nYou can see from the cards dealt up to your opponents that no 7s or Queens have been dealt up, therefore there are 8 cards in the deck that you cannot see. \n\nThe numbers to put into the hypergeometric calculation are:\n\nDRAWS: 6 cards have been dealt so only 1 card to go\n\nOUTS: Any of the four 7s or any of the 4 Jacks will give you your hand, so 8.\n\nDECK SIZE: 24 cards have been dealt leaving 28 in the pack.  However, 6 of the dealt cards are invisible to you (your opponents hole cards) so you must treat them as in the deck, so 34\n\nMATCHES: you need only one of the outs to make a run so, 1\n\nThe answer returned is 23.5%"
    
    
    let calcOddsText = "The number of possible combinations of 7 cards in a 7-Card Poker game, such as Texas Hold'em or Stud, is  133,784,560. \nThe problem that this app is concerned with is partially probability but largely combinatorics. \nCombinatorics is the essential precursor to understanding the probability of any given event.  The way you count the possible outcomes differs depending upon the nature of the problem. \nOur problem is to understand the probability of getting any one of the 9 possible hands, at any betting point in a game of stud poker, depending upon what the known and unknown cards are in the deck at that moment."
    
    let aboutVersionText = "This is Odds4Poker - Seven Card Stud\n\n\t\tRelease Date: \(game.appReleaseDate)\n\n\t\tVersion:  \(game.appVersion)\n\n\t\tBuild: \(game.appBuild)"
    
    let accuracyText = "It is useful to illustrate the problems related to assessing accuracy with an example.\n\nLet us a 6-player game is in progress with 1 card yet to be dealt and nobody has folded.  36 cards will have been dealt, as a player you can see your own hole cards but none of your opponents: so 26 cards are visible to you and 26 are hidden. Your best hand is currently a King high, but as you also have a 10, Jack and Queen you are still on for a straight, your other cards are 6 and 8. You look at the visible cards: no 9s or Aces are out.  The chance of you getting a run is 8 in 26 - just over 30%.  Easy - there are just 26 alternatives and we can know intuitively that that figure is accurate!  The challenge of accuracy becomes clearer however when we consider the odds of a run after only 3 cards have been dealt.  \nIf your first 3 cards had been 6, 8 and King then there were several possible straights to assess:\n\t2,3,4,5,6\n\t3,4,5,6,7\n\t4,5,6,7,8\n\nIn short, there would be a very great number of combinations that could give you a straight.\n\nThe next card will be 1 in 44, the next 1 in 38, the next 1 in 32 and the last 1 in 26.In other words 4 in 44*38*32*26 = nearly 1.4m alternatives.  Odds4Poker looks at each of these combinations and assesses its likelihood.  Great care and attention has gone into achieving an excellent degree of accuracy, however, there will be the occassional combination that we will have missed."
    
        let accuracyText2 = "There is a surrogate measure that is simple and fairly effective means of knowing how accurate the results of the Odds4Poker are.\nWhen the odds of the 9 possible hands are calculated they should theoretically add up to 100%. (Each such group of calculations is a single data point.) If they add up to 50% or 150% then you can know that the results are worthless.  However, Odds4Poker results trend to between 99%-101% after several data points are assessed. At Odds4Poker we are committed to improving the level of accuracy to its absolute maximum."
    
    let mainScreenText = "This is where you play a game of 7-Card Poker. \nYou can change the number of players in the game via Settings and also name them.\nYou can see a subset of Odds information for each player - this can be hidden via Settings.  The Odds information is dynamically updated as each card is dealt.\nAs the game finishes - on dealing of the 7th Card - the 2 worst cards are discarded and the best 5 are selected.  The best hand overall moves to the top of the screen."
    
    let sevenCardStudText = ""
    
    let probability7CSText = "Before a card is dealt the odds of a player getting any Poker hand in 7-Card Stud, are the following:\n\n\tStraight Flush: 0.03%\n\tPoker (4 of a kind): 0.17%\n\tFull House: 2.60%\n\tFlush: 3.03%\n\tStraight (aka Run): 4.62%\n\tTrips (three of a kind): 4.83%\n\tTwo Pair: 23.5%\n\tPair: 43.8%\n\tHigh Card: 17.4%\n\nAs soon as the first card is dealt however, the odds change.  Odds4Poker  allows you to see how they change, dynamically, as each card is dealt."
    
    let futureFeaturesText = "Dependent upon interest there may be a version of the Odds4Poker for 5-Card Stud and for Texas Hold'em"
    
    let knownIssuesText = "\nFavourites Table - entries not deleting.\n\nLandscape mode - player anchors lose integrity so disabled for time being.\n\nOddsViewController - disabled Perspective UISwitch\n\nPlayer name not appearing in Odds Pop-up"
    
    let appPrefsText = "Odds can be represented in different formats:\n1. Percentages (the default) - also known as Implied Probability, e.g. 25%\n2. Decimal Odds as used throughout much of Europe e.g. 4.00\n3. Fractional Odds (as used in the UK) e.g. 3 to 1 or 3/1\n4. Moneyline odds, variants of which are used in the US and Asia, e.g. +300\nAll the examples above represent the same probability.\n\nUse the Settings screen to select the number of players you want in your simulated game - you may also name them.\n\nUse the Settings screen to hide/show probability information on the main screen.  This probability info takes into account the cards dealt in-the-hole to each player so if you wish to recreate the actual knowledge you would have about an opponents hand in a real game, you may want to hide this."
    
    let favouriteText = "You may wish to save a particular game - to do so select the Add To Favourites button which appears at the end of each game.  This adds it to a stored list.\n\nYou may replay the game at any time by selecting the Favourites menu item and picking the game from the list.\n\nAs you play it there will be a maroon banner across the bottom of the screen to ensure that anyone viewing the screen is aware that it is a reloaded game\n\nNote: When you reload a game you are starting the game with cards in the same order as they were for the previous game.  If you decide to run it with a different number of players then of course the outcome shall be different"
    
    let appGamePlayText1 = "Odds4Poker is not a game, and is not intended to be used in that manner, but as it does use simulated gameplay to illustrate the real odds of poker it is feasible to use it that way with certain restrictions, for instance:\n- At present there is no way for a player to  fold.\n- Dealing always starts with the player in the top leftmost position\n - Anyone looking at the screen can potentially see summary information that would be private to that player (although there is a Setting to hide this summary info).\n - there is no way to bet through this app.\n\nHowever, if you simply wish to use the app as a substitute for dealing random cards from a deck of cards, there is no reason why you should not."
    
    let oddsViewText = "A Pop-up is displayed showing a grid of the poker hands, from best to worse.  Each row shows the odds of ending the game with each of those hands.\nThe first column are Pre-game odds - i.e. the odds as they would be before a card is dealt.\nThe second column showns the odds at the first betting point, i.e. when the 2 hole cards and first public card are dealt - also known as 3rd Street.\nThe next 3 columns show the odds at the next 3 betting points (4th, 5th and 6th Streets).\nThe example below illustrates how the odds for a flush shift:\nOn 4th St. - with 4 to a flush and 3 cards to go, the odds are 40% of getting a flush.\nBut by 6th St.the odds have fallen back to just over 1 in 4."
    
    let appReplaceCardText = "Odds4Poker allows you to mimic a specific game by replacing the next cards to be dealt.\n\nThe Replaced Card screen lets you select the cards you wish to replace for each player.\n\nYou may only insert cards that have not already been dealt."
    
    let appDeckViewText = "The Deck View allows you to see which cards have been dealt already.\n\nYou may opt to only see cards that have been dealt up, or you may toggle using the Switch Button to see the cards that have been deal in-the-hole also.\n\nThis is useful if you want to see how many of your Target cards have already been dealt."
    
    let appCalculatorText = "Odds4Poker uses a technique from Probability Theory called Hypergeomtric Distribution to calculate the chances of drawing the required cards to make any hand.\n\nA Hypergeomtric calculator is included in this App to allow you to calculate the chances of selecting any number of instances from a known population with any number of trials."
    
    let helpTopics : [String] = ["Main Screen", "Odds Viewer","Replacing Cards", "Deck View", "Calculator","Calculating Odds", "HyperGeometric Distribution", "About this Version", "Accuracy", "Probability of Hands", "Future Features", "Known Issues", "Settings", "Gameplay", "Favourites", "Data Policy", "Navigation", "Rating" ]
    // link to rating screens
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var helpImage: UIImageView!
    
    internal func didSelectMenuItem(withTitle title: String, index: Int) {
        print("In didSelectMenuItem of DeckViewController \(title)")
        if title == "Main Screen" {
            game.userInfo.incAboutMain()
            titleLabel.text = "What you will see on the Main Screen"
            upperTV.text = mainScreenText
         //   lowerTV.alpha = 0
            helpImage.alpha = 1
            newTV.alpha = 0
            helpImage.image = #imageLiteral(resourceName: "MainAnnoted1")
        }
        if title == "Odds Viewer" {
            game.userInfo.incAboutOdds()

            titleLabel.text = "What you will see on the Odds Viewer"
            upperTV.text = oddsViewText
            newTV.alpha = 0
            helpImage.alpha = 1
            helpImage.image = #imageLiteral(resourceName: "Oddsview1")
        }
        if title == "Calculating Odds" {
            game.userInfo.incAboutCalcOdds()

            titleLabel.text = "How to Calculate Odds in 7-Card Stud"
            upperTV.text = calcOddsText
              newTV.alpha = 1
              helpImage.alpha = 0
              newTV.text = appProblemText
        }
        if title == "HyperGeometric Distribution" {
            game.userInfo.incAboutHyperG()

            titleLabel.text = "How does HyperGeometric Distribution help?"
            upperTV.text = hyperGeoTextA
            newTV.alpha = 1
            helpImage.alpha = 0
            newTV.text = hyperGeoTextB
        }
        if title == "About this Version" {
            game.userInfo.incAboutVersion()

            titleLabel.text = title
            upperTV.text = aboutVersionText
            newTV.alpha = 0
            helpImage.alpha = 0
        }
        if title == "Accuracy" {
            game.userInfo.incAboutAccuracy()
            titleLabel.text = "How can we measure Accuracy"
            upperTV.text = accuracyText
            newTV.alpha = 1
            helpImage.alpha = 0
            newTV.text = accuracyText2
            
        }
        if title == "Probability of Hands" {
            game.userInfo.incAboutProbability()

            titleLabel.text = title
            newTV.alpha = 0
            helpImage.alpha = 0
            upperTV.text = probability7CSText
        }
        if title == "Future Features" {
            game.userInfo.incAboutFuture()
            titleLabel.text = title
            newTV.alpha = 0
            helpImage.alpha = 0
            upperTV.text = futureFeaturesText
        }
        if title == "Known Issues" {
            game.userInfo.incAboutIssues()
            titleLabel.text = title
            newTV.alpha = 0
            helpImage.alpha = 0
            upperTV.text = knownIssuesText
        }
        if title == "Settings" {
            game.userInfo.incAboutSettings()

            titleLabel.text = title
            newTV.alpha = 0
            helpImage.alpha = 0
            upperTV.text = appPrefsText
        }
        if title == "Data Policy" {
            game.userInfo.incAboutDataPolicy()

            titleLabel.text = title
            newTV.alpha = 0
            helpImage.alpha = 0
            upperTV.text = dataPolicyText
        }
        if title == "Navigation" {
            game.userInfo.incAboutNavigation()

            titleLabel.text = title
            newTV.alpha = 0
            helpImage.alpha = 0
            upperTV.text = navigationText
        }

        if title == "Gameplay" {
            game.userInfo.incAboutGameplay()

            titleLabel.text = "Can this app be used to have a real game of Poker?"
            upperTV.text = appGamePlayText1
            newTV.alpha = 0
            helpImage.alpha = 0
        }
        if title == "Replacing Cards" {
            game.userInfo.incAboutReplace()

            titleLabel.text = title

            upperTV.text = appReplaceCardText
            helpImage.alpha = 0
            newTV.alpha = 0
        }
        if title == "Deck View" {
            game.userInfo.incAboutDeck()

            titleLabel.text = title
            helpImage.alpha = 0
            newTV.alpha = 0
            upperTV.text = appDeckViewText
        }
        if title == "Favourites" {
            game.userInfo.incAboutFavourites()

            titleLabel.text = title
            helpImage.alpha = 0
            newTV.alpha = 0
            upperTV.text = favouriteText
        }
        if title == "Calculator" {
            game.userInfo.incAboutCalc()

            titleLabel.text = title
            helpImage.alpha = 0
            newTV.alpha = 0
            upperTV.text = appCalculatorText
        }
//        if title == "Application: Odds View" {
//            upperTV.text = appProblemText
//        }
//        if title == "Application: " {
//            upperTV.text = appProblemText
//        }
        if title == "Rating" {
            game.userInfo.incAboutRating()

            performSegue(withIdentifier: "ratingSequeFromAbout", sender: self)
        }
        if title == "Data Policy" {
            game.userInfo.incAboutDataPolicy()
//error?
            titleLabel.text = title

        //    performSegue(withIdentifier: "ratingSequeFromAbout", sender: self)
        }
        /*   if title == "Free-form Odds" {
         unwind(for: ViewController.ffSeque, towardsViewController: ViewController)
         performSegue(withIdentifier: "toSignfromStart", sender: self)
         } */
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: game.mainTitleFont, size: game.mainTitleFontSize+6)
        upperTV.font = UIFont(name: game.normalTitleFont, size: game.normalTitleFontSize)
        newTV.font = UIFont(name: game.bodyFont, size: game.bodyFontSize)
        var iPadMultiplier = 1.0
        if game.portraitWidth > 500 {
            iPadMultiplier = 2.0
        }
    //    DenominatorSV.co
        // Do any additional setup after loading the view.
        let sideMenu = SideMenu(menuWidth: CGFloat(150 * iPadMultiplier), menuItemTitles: helpTopics, parentViewController: self)
            
            //["Calculating Odd", "HyperGeometric Distribution","About this Version","Accuracy","Probability of Hands", "Future Features","Known Issues","Application: Preferences","Application: Gameplay","Application: Replacing Cards","Application: Deck View", "Application: Calculator","Rating"]
        sideMenu.menuDelegate = self
        sideMenu.layer.zPosition = 1
        titleLabel.text = "Odds4Poker - Overview"
        upperTV.text = "Odds4Poker - 7-Card Stud helps you to become a better poker player by appreciating the reality of odds.\n\nSwipe right to see a menu of helpful information."
        newTV.text = "The difference between a good poker player and a great one is recognition of the chances of making any hand. \n\nMost good players  have a sense of probability but it is rarely based on more than a hunch and almost never the result of accurate information.\n\nThis App changes that.\n\nBy running game simulations you will quickly understand the real chances of getting each of the 9 main hands.  You will be surprised how inaccurate your hunches often are!"
        newTV.alpha = 1
        helpImage.alpha = 0
//        UIView.animate(withDuration: 5) {
//            self.lowerTV.text = "\n\nSwipe Right to select a topic from the About Menu"
//        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var DenominatorSV: UIScrollView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
