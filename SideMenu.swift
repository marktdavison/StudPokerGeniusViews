//
//  SideMenu.swift
//  Poker Night
//
//  Created by Mark Davison on 19/11/2016.
//  Copyright © 2016 ll. All rights reserved.
//

import UIKit

protocol SideMenuDelegate {
    func didSelectMenuItem (withTitle title:String, index:Int)
}

class SideMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var menuDelegate:SideMenuDelegate?

    var backgroundView:UIView!
    var menuTable:UITableView!
    var animator:UIDynamicAnimator!
    
    var menuWidth:CGFloat = 0
    
    var menuItemTitles = [String]()
    var dynamicHeight = CGFloat()
    var rheight = CGFloat()
    var parentViewController = UIViewController()
    var iPadMultiplier = 1.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(menuWidth:CGFloat, menuItemTitles:[String], parentViewController:UIViewController) {
        
        if game.portraitWidth > 500 {
            iPadMultiplier = 2.0
        }
        if menuItemTitles.count > 12 {
            rheight = CGFloat(30 * iPadMultiplier)
        } else {
            rheight = CGFloat(50 * iPadMultiplier)
        }
        dynamicHeight = CGFloat(menuItemTitles.count) * rheight
        super.init(frame: CGRect(x: -menuWidth, y: /*50*/30, width: menuWidth, height: dynamicHeight /* parentViewController.view.frame.height  */))
        
        self.menuWidth = menuWidth
        self.menuItemTitles = menuItemTitles
        self.parentViewController = parentViewController
        
        self.backgroundColor = UIColor.darkGray
      //  self
        parentViewController.view.addSubview(self)
    //    insertSubview(self, aboveSubview: parentViewController.view)
     //   parentViewController.view.bringSubview(toFront: parentViewController.view)

        setupMenuView()
        
        
        animator = UIDynamicAnimator(referenceView: parentViewController.view)
        
        let showMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideMenu.handleGestures(recognizer:)))
        
        showMenuRecognizer.direction = .right
        parentViewController.view.addGestureRecognizer(showMenuRecognizer)
        
        let hideMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideMenu.handleGestures(recognizer:)))
        
        hideMenuRecognizer.direction = .left
        parentViewController.view.addGestureRecognizer(hideMenuRecognizer)
        
   //     print("Sidemenu Init: subviews are \(subviews)")
/*        for s in subviews {
            print("Iterating through subviews: \(subviews.debugDescription)")
        } */
    }
    
    
    @objc func handleGestures (recognizer:UISwipeGestureRecognizer) {
        if recognizer.direction == .right {
            toggleMenu(open: true)
        }else{
            toggleMenu(open: false)
        }
        
        
    }
    
    func toggleMenu (open:Bool) {
        animator.removeAllBehaviors()
        // first one is for opening
        let gravityX:CGFloat = open ? 2 : -1
        let pushMagnitude:CGFloat = open ? 2 : -20
        let boundaryX:CGFloat = open ? menuWidth : -menuWidth - 5
        if open {
            for c in game.visibleCards {
                c.isUserInteractionEnabled = false
            }
        } else {
            for c in game.visibleCards {
                c.isUserInteractionEnabled = true
            }
        }
        
        
        let gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [self])
        collision.addBoundary(withIdentifier: 1 as NSCopying, from: CGPoint(x: boundaryX, y:20), to: CGPoint(x: boundaryX, y: parentViewController.view.bounds.height))
        animator.addBehavior(collision)
        
        let push = UIPushBehavior(items: [self], mode: .instantaneous)
        push.magnitude = pushMagnitude
        animator.addBehavior(push)
        
        
        let menuBehaviour = UIDynamicItemBehavior(items: [self])
        menuBehaviour.elasticity = 0.4
        animator.addBehavior(menuBehaviour)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = open ? 0.5 : 0
        }
        
        
        
        
    }
    
    func setupMenuView () {
        backgroundView = UIView(frame: parentViewController.view.bounds)
        backgroundView.backgroundColor = UIColor.darkGray
        backgroundView.alpha = 0
     //   backgroundView.isUserInteractionEnabled = false
        parentViewController.view.insertSubview(backgroundView, belowSubview: self)

        
    //    parentViewController.view.insertSubview(backgroundView, belowSubview: parentViewController.view)
        // belowSubview
        
        menuTable = UITableView(frame: self.bounds, style: .plain)
        menuTable.backgroundColor = UIColor.clear
        menuTable.separatorStyle = .none
        menuTable.isScrollEnabled = false
        menuTable.alpha = 1
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        menuTable.reloadData()
        
        self.addSubview(menuTable)
        
        
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("SMENU: There are \(menuItemTitles.count) rows in this menu")
        return menuItemTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = menuItemTitles[indexPath.row]
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.textLabel?.font = UIFont(name: "Helvetica", size: CGFloat(10 * iPadMultiplier))
        cell?.textLabel?.textAlignment = .center
   //     cell?.layer.zPosition = 1
        cell?.backgroundColor = UIColor.clear
//        cell?.bringSubview(toFront: cell!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rheight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        toggleMenu(open: false)

        if let delegate = menuDelegate {
            delegate.didSelectMenuItem(withTitle: menuItemTitles[indexPath.row], index: indexPath.row)
        }
        
    }
    
}
