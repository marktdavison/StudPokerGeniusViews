//
//  FreeFormViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 11/09/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit

class FreeFormViewController: UIViewController {

    
    internal func didSelectMenuItem(withTitle title: String, index: Int) {
        print("In didSelectMenuItem of Free-Form ViewController \(title)")
        if title == "Preferences" {
            performSegue(withIdentifier: "toSettingsfromStart", sender: self)
        }
        if title == "Current Deck" {
            performSegue(withIdentifier: "deckSequeFromFF", sender: self)
        }
     /*   if title == "Free-form Odds" {
            unwind(for: ViewController.ffSeque, towardsViewController: ViewController)
             performSegue(withIdentifier: "toSignfromStart", sender: self)
        } */
 
    }
    @IBOutlet weak var logTV: UITextView!
    
    @IBOutlet weak var draws: UITextField!
    
    @IBOutlet weak var outs: UITextField!
    
    @IBOutlet weak var deckSize: UITextField!
    
    @IBOutlet weak var matchesReqd: UITextField!
    
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var calcOddsOutlet: UIButton!
    
    
    @IBOutlet weak var newLog: UITextView!
    
    @IBOutlet weak var matchesNeeded: UILabel!
    var resultLine: String = ""

    
    @IBAction func calcOdds(_ sender: UIButton) {
        var r1DrawsLTNeeded : Bool = false
        var r2DrawsMTPop : Bool = false
        var r3OutsMTPop : Bool = false
        var r4OutsLTNeeded : Bool = false
        var r5PopLTNeeded : Bool = false
        var r6DrawsIsZero : Bool = false
        var r7OutsIsZero : Bool = false
        var r8PopIsZero : Bool = false
        var r9NeededIsZero : Bool = false

        let sizeOftrial = Int(draws.text!)
        let succInPop = Int(outs.text!)
        let sizeOfPop = Int(deckSize.text!)
        let succReqd = Int(matchesReqd.text!)
        
        var ruleBreaks : Int = 0
        var rulesString = String()
        game.userInfo.incCalcButton()
        
        if sizeOftrial! < succReqd! {
            ruleBreaks += 1
            r1DrawsLTNeeded = true
            rulesString += String(ruleBreaks) + ": Not enough draws left.\n"
        }
        
        if sizeOftrial! > sizeOfPop! {
            ruleBreaks += 1
            r2DrawsMTPop = true
            rulesString += String(ruleBreaks) + ": More draws than cards in deck.\n"
        }
        
        if succInPop! > sizeOfPop! {
            ruleBreaks += 1
            r3OutsMTPop = true
            rulesString += String(ruleBreaks) + ": Number of Outs more than cards in deck.\n"
        }
        
        if succInPop! < succReqd! {
            ruleBreaks += 1
            r4OutsLTNeeded = true
            rulesString += String(ruleBreaks) + ": Not enough Outs to satisfy need.\n"

        }
        
        if sizeOfPop! < succReqd! {
            ruleBreaks += 1
            r5PopLTNeeded = true
            rulesString += String(ruleBreaks) + ": Not enough cards left to satisfy need.\n"

        }
        if sizeOftrial! == 0 {
            ruleBreaks += 1
            r6DrawsIsZero = true
            rulesString += String(ruleBreaks) + ": Draws cannot be zero.\n"
            
        }
        if succInPop! == 0 {
            ruleBreaks += 1
            r7OutsIsZero = true
            rulesString += String(ruleBreaks) + ": Outs cannot be zero.\n"
            
        }
        if sizeOfPop! == 0 {
            ruleBreaks += 1
            r8PopIsZero = true
            rulesString += String(ruleBreaks) + ": Remaining deck size cannot be zero.\n"
            
        }
//        if succReqd! == 0 {
//            ruleBreaks += 1
//            r9NeededIsZero = true
//            rulesString += String(ruleBreaks) + ": Cards needed cannot be zero.\n"
//            
//        }
        
        
        if ruleBreaks > 0 {
            var startString = "There is a problem with the data!"
            if ruleBreaks > 1 {
                startString = "There are \(ruleBreaks) problems with the data!"
            }
            let alert = UIAlertController(title: startString, message: rulesString, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
                print("FFVC: returning now")
               // return
            }
            alert.addAction(actionCancel)
            return
        }
        let chance2 = Hypergeometric(numberOfTrials: sizeOftrial!, successesInPopulation: succInPop!, population: sizeOfPop!)
        
        let prob = chance2.probability(of: succReqd!)
        //  let odds = 1/prob
        result.text = String(format: "%.1f", prob*100) + "%"
        
        game.calcResults = draws.text! + "     " + outs.text! + "     " + deckSize.text! + "     " + matchesReqd.text! + "     " + result.text! + "\n" + game.calcResults
        newLog.text = game.calcResults
     //   result.text = prob
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newLog.layer.cornerRadius = 10.0
        newLog.text = game.calcResults
        calcOddsOutlet.layer.cornerRadius = 10.0
        result.layer.cornerRadius = 10.0
   //     let sideMenu = SideMenu(menuWidth: 150, menuItemTitles: ["Preferences", "Current Deck"], parentViewController: self)
   //     sideMenu.menuDelegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
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
