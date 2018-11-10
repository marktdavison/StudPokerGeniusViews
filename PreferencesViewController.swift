//
//  PreferencesViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 17/09/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit

// var oddsFormat : String = "IP"

class PreferencesViewController: UIViewController {
    
    
    @IBOutlet weak var flagView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var example: UILabel!
    @IBAction func namePlayers(_ sender: Any) {
        game.userInfo.incSettingsAttemptName()
        //disable
        if game.currentSubscriber {
            game.userInfo.incSettingsName()

            performSegue(withIdentifier: "namesSequeFromPrefs", sender: self)
        } else {
            presentSubscriptionAlert(functionality: "Naming Players")
        }
    }
    
    @IBOutlet weak var outletMainScreenOdds: UISwitch!
    
    
    
    @IBAction func switchMainScreenOdds(_ sender: Any) {
        game.userInfo.incSettingsAttemptHide()
        //disable
        if game.currentSubscriber {
                game.userInfo.incSettingsHideShow()

                if outletMainScreenOdds.isOn == true {
                    game.mainScreenOddsHidden = false
                } else {
                    game.mainScreenOddsHidden = true
                }
                UserDefaults.standard.set(game.mainScreenOddsHidden, forKey: "mainScreenOddsHidden")
            } else {
                outletMainScreenOdds.setOn(true, animated: true)
                presentSubscriptionAlert(functionality: "Hiding On-Screen Odds")
            }
        }

    
        @IBAction public func formatSlider(_ sender: UISlider) {
            game.userInfo.incSettingsAttemptFormat()
    // disable
            if game.currentSubscriber {
            game.userInfo.incSettingsFormat()

            if sender.value < 13 {
                name.text = "Implied Probability"
                example.text = "e.g. 25%"
                game.oddsFormat = "IP"
                sender.setValue(0, animated: true)
                flagView.image = #imageLiteral(resourceName: "percentage21600")
            } else if sender.value >= 13 && sender.value <= 37 {
                name.text = "Decimal Odds"
                example.text = "e.g. 4.00"
                game.oddsFormat = "Dec"
                sender.setValue(25, animated: true)
                flagView.image = #imageLiteral(resourceName: "euro@1x")

            } else if sender.value > 37 && sender.value <= 62 {
                name.text = "Fractional Odds"
                example.text = "e.g. 3/1"
                game.oddsFormat = "Fra"
                sender.setValue(50, animated: true)
                flagView.image = #imageLiteral(resourceName: "uj@1x")

            } else if sender.value >= 63 {
                name.text = "Moneyline Odds"
                example.text = "e.g. +300"
                game.oddsFormat = "Mon"
                sender.setValue(75, animated: true)
                flagView.image = #imageLiteral(resourceName: "us@1x")

            }
            UserDefaults.standard.set(game.oddsFormat, forKey: "format")
        } else {
                sender.setValue(0, animated: true)

                presentSubscriptionAlert(functionality: "Changing Odds Format")
        }
    }
    
    @IBOutlet weak var playerNoOutlet: UILabel!
    
    @IBOutlet weak var playerSliderOutlet: UISlider!
    
    
    @IBAction func playerNoSlide(_ sender: UISlider) {
        game.userInfo.incSettingsAttemptPlayers()
//disable
        game.userInfo.incSettingsPlayers()

        if sender.value < 2.5 {
            sender.setValue(2, animated: true)
            game.players = 2
            
        } else if sender.value < 3.5 {
            sender.setValue(3, animated: true)
            game.players = 3

        } else if sender.value < 4.5 {
            sender.setValue(4, animated: true)
            game.players = 4

        } else if sender.value < 5.5 {
            sender.setValue(5, animated: true)
            game.players = 5

        } else if sender.value < 6.5 {
            sender.setValue(6, animated: true)
            game.players = 6

        } else {
            sender.setValue(7, animated: true)
            game.players = 7

        }
        playerNoOutlet.text = String(format: "%.f", sender.value)
        UserDefaults.standard.set(game.players, forKey: "players")

    }
    
    @IBOutlet weak var formatSliderOutlet: UISlider!
    
/*    @IBOutlet weak var gameTypeOutlet: UILabel!
    
    @IBAction func gameType(_ sender: UISlider) {
        if sender.value < 1.5 {
            sender.setValue(1, animated: true)
            gameTypeOutlet.text = "5-Card Stud"
        } else if sender.value < 2.5 {
            sender.setValue(2, animated: true)
            gameTypeOutlet.text = "Texas Hold'em"
        } else if sender.value < 3.5 {
            sender.setValue(3, animated: true)
            gameTypeOutlet.text = "7-Card Stud"
        } else {
            sender.setValue(4, animated: true)
            gameTypeOutlet.text = "7-Card No-Look"
        }
        
     //   gameTypeOutlet.text = String(format: "%.f", sender.value)
    } */

    
    
    
    internal func didSelectMenuItem(withTitle title: String, index: Int) {
        print("In didSelectMenuItem of Free-Form ViewController \(title)")
        if title == "Preferences" {
            performSegue(withIdentifier: "toSettingsfromStart", sender: self)
        }
        if title == "Current Deck" {
            performSegue(withIdentifier: "deckSequeFromFF", sender: self)
        }
           if title == "Free-form Odds" {
         performSegue(withIdentifier: "toSignfromStart", sender: self)
         }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if game.mainScreenOddsHidden {
            outletMainScreenOdds.isOn = false
        } else {
            outletMainScreenOdds.isOn = true

        }
        // somethign to say if game.state = 'Underway" then cant change no of players.
        flagView.layer.cornerRadius = 5.0
        let formatObject = UserDefaults.standard.object(forKey: "format")
        if let format = formatObject as? String {
            print("PVC: Stored value of format is \(format)")
            game.oddsFormat = format
        } else {
            print("PVC: format not previouslys stored")
            
        }
        let playersObject = UserDefaults.standard.object(forKey: "players")
        if let players = playersObject as? Int {
            print("PVC: Stored value of number of players is \(players)")
            game.players = players
            playerSliderOutlet.value = Float(players)

        } else {
            print("PVC: players not previouslys stored")

        }
        playerNoOutlet.text = String(game.players)

        switch game.oddsFormat {
        case "IP":
            //formatSlider.value = 75
            name.text = "Implied Probability"
            example.text = "e.g. 25%"
            flagView.image = #imageLiteral(resourceName: "percentage21600")
            formatSliderOutlet.value = 0
        case "Fra":
            name.text = "Fractional Odds"
            example.text = "e.g. 3/1"
            flagView.image = #imageLiteral(resourceName: "uj@1x")
            formatSliderOutlet.value = 50

        case "Dec":
            example.text = "e.g. 4.00"
            game.oddsFormat = "Dec"
            flagView.image = #imageLiteral(resourceName: "euro@1x")
            formatSliderOutlet.value = 25

        case "Mon":
            name.text = "Moneyline Odds"
            example.text = "e.g. +300"
            flagView.image = #imageLiteral(resourceName: "us@1x")
            formatSliderOutlet.value = 75

        default:
            name.text = "Implied Probability"
            example.text = "e.g. 25%"
            flagView.image = #imageLiteral(resourceName: "percentage21600")
            formatSliderOutlet.value = 0

        }
      //  let sideMenu = SideMenu(menuWidth: 150, menuItemTitles: ["Preferences", "Current Deck"], parentViewController: self)
    //    sideMenu.menuDelegate = self
        flagView.layer.cornerRadius = 5.0
        if game.state == "underway" {
            playerSliderOutlet.isUserInteractionEnabled = false
            playerSliderOutlet.layer.opacity = 0.5
            playerNoOutlet.textColor = UIColor.gray
            playerNoOutlet.text =  playerNoOutlet.text! + " GAME ON"
        }
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

    
    internal func presentSubscriptionAlert(functionality: String) {
        let alert = UIAlertController(title: "Sorry but \(functionality) is available only to Pro users. ", message: "You may access a host of features when you go Pro:\n\n\tPerspective Switch\n\tChange to your favoured Odds format\n\tChange upcoming cards\n\tSave & reload games\n\tName Players\n\tHide odds on main screen.\n\nGo to the subscription screen to see your status?", preferredStyle: .alert)
        
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
    
}
