//
//  NameViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 07/05/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    @IBOutlet weak var p1Name: UITextField!
    
    @IBOutlet weak var p2Name: UITextField!
    
    @IBOutlet weak var p3Name: UITextField!
    
    @IBOutlet weak var p4Name: UITextField!
    
    @IBOutlet weak var p5Name: UITextField!
    
    @IBOutlet weak var p6Name: UITextField!
    
    @IBAction func saveNames(_ sender: UIButton) {
//        if p1Name.text != "Player 1" {
            game.playerNames[0] = p1Name.text!
            UserDefaults.standard.set(game.playerNames[0], forKey: "p1")
  //      }
    //    if p1Name.text != "Player 2" {
            game.playerNames[1] = p2Name.text!
            UserDefaults.standard.set(game.playerNames[1], forKey: "p2")

      //  }
        //if p1Name.text != "Player 3" {
            game.playerNames[2] = p3Name.text!
            UserDefaults.standard.set(game.playerNames[2], forKey: "p3")

        //}
//        if p1Name.text != "Player 4" {
            game.playerNames[3] = p4Name.text!
            UserDefaults.standard.set(game.playerNames[3], forKey: "p4")

  //      }
    //    if p1Name.text != "Player 5" {
            game.playerNames[4] = p5Name.text!
            UserDefaults.standard.set(game.playerNames[4], forKey: "p5")

      //  }
        //if p1Name.text != "Player 6" {
            game.playerNames[5] = p6Name.text!
            UserDefaults.standard.set(game.playerNames[5], forKey: "p6")

        //}
        UserDefaults.standard.set(game.mainScreenOddsHidden, forKey: "mainScreenOddsHidden")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p1Name.text = game.playerNames[0]
        p2Name.text = game.playerNames[1]
        p3Name.text = game.playerNames[2]
        p4Name.text = game.playerNames[3]
        p5Name.text = game.playerNames[4]
        p6Name.text = game.playerNames[5]

        if game.players == 2 {
            p1Name.alpha = 1
            p2Name.alpha = 1
            p3Name.alpha = 0
            p4Name.alpha = 0
            p5Name.alpha = 0
            p6Name.alpha = 0

        } else if game.players == 3 {
            p1Name.alpha = 1
            p2Name.alpha = 1
            p3Name.alpha = 1
            p4Name.alpha = 0
            p5Name.alpha = 0
            p6Name.alpha = 0
        } else if game.players == 4 {
            p1Name.alpha = 1
            p2Name.alpha = 1
            p3Name.alpha = 1
            p4Name.alpha = 1
            p5Name.alpha = 0
            p6Name.alpha = 0
        } else if game.players == 5 {
            p1Name.alpha = 1
            p2Name.alpha = 1
            p3Name.alpha = 1
            p4Name.alpha = 1
            p5Name.alpha = 1
            p6Name.alpha = 0
        } else if game.players == 6 {
            p1Name.alpha = 1
            p2Name.alpha = 1
            p3Name.alpha = 1
            p4Name.alpha = 1
            p5Name.alpha = 1
            p6Name.alpha = 1
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
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
