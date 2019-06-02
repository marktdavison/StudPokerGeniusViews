//
//  FavouritesViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 11/03/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit
import RealmSwift
// import SwipeCellKit



class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SideMenuDelegate {
    
    var selectedWinningHand = String()
    var selectedHandTime = String()
    
    @IBOutlet weak var outletLoad: UIButton!
    
    @IBAction func actionLoad(_ sender: UIButton) {
   
        if game.currentSubscriber {
            var textField = "Load Favourite"
            if game.state == "underway" {
                textField = "Abort and Load Favourite"
            }
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
            let alert = UIAlertController(title: "\(textField): \(selectedWinningHand)?", message: "Saved on \(selectedHandTime)", preferredStyle: .alert)
            
            let actionLoad = UIAlertAction(title: "Load", style: .destructive) { (action) in
                game.userInfo.incFavLoad()
                game.myDeckOfCards.copyOver(replacementDeck: self.newDeck)
                game.state = "loadingFavourite"
                game.runningFavourite = true
                print("Fave: Saving over the existing deck!!!")
                game.userInfo.incFavesReloaded()
                self.outletLoad.alpha = 0
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
                print("Fave: Doing Nowt!")
                
            }
            alert.addAction(actionLoad)
            alert.addAction(actionCancel)
            
            present(alert, animated: true, completion: nil)
        } else {
            presentSubscriptionAlert(functionality: "Loading Saved Favourites")
        }
        

    }
    
    let realm = try! Realm()
    public var newDeck: [Card] = [] // array of Cards

    public var fCellContents : Results<Data2>?
    @IBOutlet weak var favouritesTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fCellContents?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "FCell")
        let title = fCellContents?[indexPath.row].winningHand ?? "No Favourites Yet"
        let time = fCellContents?[indexPath.row].handTime ?? ""
        fCell.textLabel?.text = title
        
     //   fCell.detailTextLabel?.text = arg2
        fCell.textLabel?.textColor = UIColor.white
        fCell.textLabel?.font = UIFont(name:game.bodyFont, size:game.bodyFontSize)
        fCell.backgroundColor = UIColor.clear
        fCell.detailTextLabel?.text = time
        fCell.detailTextLabel?.font = UIFont(name:"Avenir", size:14)

        return fCell
    }
    
    func didSelectMenuItem(withTitle title: String, index: Int) {

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenDeck = fCellContents?[indexPath.row].faveDeck
        print("NewDeck 1 = \(newDeck)")
        selectedWinningHand = (fCellContents?[indexPath.row].winningHand)!
        selectedHandTime = (fCellContents?[indexPath.row].handTime)!

        for f in chosenDeck! {
            newDeck.append(Card(face: game.myDeckOfCards.faces[f % 13], suit: game.myDeckOfCards.suits[f / 13], order: f))
        }
        outletLoad.alpha = 1

        print("NewDeck 2 = \(newDeck)")

    }

    @IBOutlet weak var outletStoredFavourites: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outletStoredFavourites.font = UIFont(name: game.mainTitleFont, size: game.mainTitleFontSize)
        fCellContents = realm.objects(Data2.self)
        game.userInfo.setFavesStored(numFavesStored: (fCellContents?.count)!)
        favouritesTable.separatorStyle = .singleLine
        outletLoad.alpha = 0
        outletLoad.titleLabel?.font = UIFont(name: game.minorTitleFont, size: game.minorTitleFontSize)

//        if let faves = UserDefaults.standard.object(forKey: "favourites")  as? [[Card]] {
//
//            fCellContents = faves
//            print("The number of elements in faves is \(fCellContents.count)")
//            print(fCellContents.count)
//
//            }
        favouritesTable.reloadData()
        }

    
    
    
    internal func presentSubscriptionAlert(functionality: String) {
        let alert = UIAlertController(title: "Sorry but \(functionality) is available only to Pro users. ", message: "You may access a host of features when you go Pro:\n\n\tPerspective Switch\n\tChange to your favoured Odds format\n\tChange upcoming cards\n\tSave & reload games\n\tName Players\n\tHide odds on main screen.\n\nGo to the subscription screen to see your status?", preferredStyle: .alert)
        
        let actionLoad = UIAlertAction(title: "Go", style: .default) { (action) in
            print("Pref alert selected Go")
            self.performSegue(withIdentifier: "favToSubSeque", sender: self)
            
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func createDeckFromFave(orders : [Int]) {
        for o in orders {

            newDeck.append(Card(face: game.myDeckOfCards.faces[o % 13], suit: game.myDeckOfCards.suits[o / 13], order: o))
        }
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
