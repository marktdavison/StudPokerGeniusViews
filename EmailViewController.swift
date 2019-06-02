//
//  EmailViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 02/06/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var sendEmailOutlet: UIButton!
    @IBAction func sendEmailButton(_ sender: UIButton) {
        
        let mc : MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        let recipients = ["mark.davison@royalmail.com"]
        if MFMailComposeViewController.canSendMail() {
            mc.setToRecipients(recipients)
            mc.setSubject(name.text! + " - my app")
            mc.setMessageBody("""
                Name: \(name.text!)
                Email: \(email.text!)
                Message: \(message.text!)
                """, isHTML: false)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            print("Email Error: \(mc.mailComposeDelegate)")
        }

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendEmailOutlet.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
    
    self.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
            
            textView.resignFirstResponder()
            return false
            
        }
        
        return true
    }
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
