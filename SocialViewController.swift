//
//  SocialViewController.swift
//  DeckOfCards
//
//  Created by Mark Davison on 03/06/2018.
//  Copyright © 2018 lifeline. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UIWebViewDelegate {

  //  @IBOutlet weak var actInd: UIActivityIndicatorView!
    
  //  @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    var sentData : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SVC : in viewdidload")
        newTitle.text = sentData

        var url = NSURL()
        switch sentData {
        case "Facebook":
            url = NSURL(string: "https://www.facebook.com")!
        case "Twitter":
            url = NSURL(string: "https://twitter.com")!
        case "Google+":
            url = NSURL(string: "https://plus.google.com/discover")!
        case "LinkedIn":
            url = NSURL(string: "https://www.linkedin.com")!
        case "YouTube":
                url = NSURL(string: "https://www.youtube.com")!
        case "PokerOdds Website":
            url = NSURL(string: "https://www.odds4poker.com")!
        case "Instagram":
            url = NSURL(string: "https://www.instagram.com")!
        case "SnapChat":
            url = NSURL(string: "https://scan.snapchat.com")!
        default:
            url = NSURL(string: "www.google.com")!
        }
     //   url = NSURL(string: "http://www.google.com")!
        let request = URLRequest(url: url as URL)
        webview.loadRequest(request)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
      //  actInd.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
    //    actInd.stopAnimating()
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
