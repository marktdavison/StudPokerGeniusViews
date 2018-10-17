//
//  SocialTableViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 02/06/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class SocialTableViewController: UITableViewController, UIWebViewDelegate {
    

    
    @IBOutlet var socialTable: UITableView!
    
    var imageList = ["SocialIcon1","SocialIcon2","SocialIcon3","SocialIcon4","SocialIcon5","socialicon7"]
    
    var titleList = ["Facebook","Twitter","Google+","LinkedIn","YouTube","Instagram"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "newbackground"))
        socialTable.rowHeight = 50
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell

        
        cell.socialImage.image = UIImage(named: imageList[indexPath.row])
        cell.socialLabel.text = titleList[indexPath.row]
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("STVC: in prepareforsegue - ID = \(String(describing: segue.identifier)), sender = \(String(describing: sender))")
        if (segue.identifier == "socialSequeTest") {
            let dest = segue.destination as! SocialViewController
            if let indexpath = self.tableView.indexPathForSelectedRow {
                dest.sentData = titleList[indexpath.row] as String
            print("STVC: in prepareforsegue - selection = \(titleList[indexpath.row])")
            }
        }
        
    }
 

}
