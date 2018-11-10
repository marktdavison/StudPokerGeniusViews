//
//  SystemViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 26/05/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class SystemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sysinfoTable: UITableView!
    public var sCellTitles : [String] = ["Device Name", "Operating System", "Device Type", "Model", "Screen Size", "Country", "First Use", "Latest Use", "UUID", "Application Version", "Application Build", "Release Date", "App Opens", "Games Played", "Data Points", "Accuracy Level", "Subscription Start", "Subscription End", "Favourites Stored", "Favourites Reloaded", "Facebook", "Twitter"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sCellTitles.count
    }
    
//    @IBOutlet weak var sCell: UITableViewCell!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var answer = String()
        let sCell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "SICell")
        sCell.textLabel?.lineBreakMode = .byWordWrapping
        sCell.textLabel?.numberOfLines = 0
        sCell.detailTextLabel?.numberOfLines = 0
        sCell.detailTextLabel?.lineBreakMode = .byWordWrapping
        let title = sCellTitles[indexPath.row]
        switch title {
        case "Device Name":
            answer = game.userInfo.deviceName
        case "Operating System":
            answer = game.userInfo.deviceVersion
        case "Device Type":
            answer = game.userInfo.deviceSystemName
        case "Model":
            answer = game.userInfo.deviceModel
        case "Screen Size":
            answer = game.userInfo.screenSize
        case "Country":
            answer = game.userInfo.country
        case "First Use":
            answer = String("\(game.userInfo.firstUse)")
        case "Latest Use":
            answer = String("\(game.userInfo.latestUse)")
        case "UUID":
            answer = game.userInfo.uuid
        case "Application Version":
            if game.userInfo.appVersion == "po7cs" {
                answer = "Odds4Poker for 7 Card Stud"
            } else {
                answer = "Odds4Poker"
            }
        case "Application Build":
            answer = game.userInfo.appBuild
        case "Release Date":
            answer = game.userInfo.appReleaseDate
        case "App Opens":
            answer = String("\(game.userInfo.appOpens)")
        case "Games Played":
            answer = String("\(game.userInfo.gamesPlayed)")
        case "Data Points":
            answer = String("\(game.userInfo.dataPoints)")
            sCell.accessoryType = .detailButton
        case "Accuracy Level":
            answer = String("\(game.userInfo.accuracyLevel)")
            sCell.accessoryType = .detailButton
        case "Subscription Start":
            answer = String("\(game.userInfo.subscriptionStart)")
        case "Subscription End":
            answer = String("\(game.userInfo.subscriptionEnd)")
        case "Favourites Stored":
            answer = String("\(game.userInfo.favouritesStored)")
        case "Favourites Reloaded":
            answer = String("\(game.userInfo.favouritesReloaded)")
        case "Rate":
            if game.userInfo.rate == 1 {
                answer = "Unhappy"
            } else if game.userInfo.rate == 2 {
                answer = "Confused"
            } else if game.userInfo.rate == 3 {
                answer = "Happy"
            } else {
                answer = "Not rated yet"
            }
            
        case "Facebook":
            answer = String("\(game.userInfo.facebookPosts)")
        case "Twitter":
            answer = String("\(game.userInfo.tweetstwatted)")
        default:
            answer = "Error"
        }
        sCell.textLabel?.text = title
        sCell.detailTextLabel?.text = answer
//        sCell.textLabel?.textColor = UIColor.white
//        sCell.textLabel?.font = UIFont(name:"Avenir", size:16)
//        sCell.backgroundColor? = UIColor.clear
//        sCell.detailTextLabel?.font = UIFont(name:"Avenir", size:14)
        return sCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sysinfoTable.separatorStyle = .singleLine
        sysinfoTable.layer.cornerRadius = 5
        
        sysinfoTable.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func accuracyAlert() {
        let alert = UIAlertController(title: "Odds4Poker is nearly perfect... but not quite!", message: "If the probability calculations were  correct, the total of the odds for each possible hand (Flush, Trips, Pair etc.) would add up to 100%.  Odds4Poker gets very close to this but it is not perfect - the accuracy metric shows how close it gets.\nSelect the About menu item for more info on Accuracy.", preferredStyle: .alert)
        
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(actionCancel)
        game.userInfo.incSysinfoAccuracyLevel()
        present(alert, animated: true, completion: nil)
    }
    
    public func dataPointsAlert() {
        let alert = UIAlertController(title: "Data Points", message: "A Data point for the accuracy metric is created each time Odds4Poker calculates the odds for a player at each betting point except on the 7th card - so at the 3rd, 4th, 5th and 6th cards.  If there are 4 players in a game there would be 16 odds calculations and therefore 16 data points.", preferredStyle: .alert)
        
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(actionCancel)
        game.userInfo.incSysinfoDataPoints()

        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("SysInfo: Accuracy accessory detail button tapped")
        
        if sCellTitles[indexPath.row] == "Accuracy Level" {
            accuracyAlert()
        }
        if sCellTitles[indexPath.row] == "Data Points" {
            dataPointsAlert()
        }
       
    }

    /*
    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("will: Dimensions of this screen: Height \(self.view.bounds.height), Width \(self.view.bounds.width). )")
        
        if newCollection.verticalSizeClass == .compact {
            print("SystemVC: orientation is Landscape")
            game.inPortrait = false
            let anchorsL = placeScreenObjects(port: false)
            moveScreenObjectsToLandscape(anchors: anchorsL)
            
        } else {
            print("SystemVC: orientation is \(newCollection.verticalSizeClass)")
            game.inPortrait = true
            let anchorsP = placeScreenObjects(port: true)
            moveScreenObjectsToPortrait(anchors: anchorsP)
        }
    }
*/
}
