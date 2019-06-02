//
//  ContactViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 30/04/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var upperLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperLabel.layer.cornerRadius = 10
        contactButton.layer.cornerRadius = 10
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

}
