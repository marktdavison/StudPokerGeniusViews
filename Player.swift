//
//  Player.swift
//  DeckOfCards
//
//  Created by Mark Davison on 18/06/2017.
//  Copyright © 2017 lifeline. All rights reserved.
//

import UIKit

class Player {

    public var playerHand: Hands
    public var playerName: String
    private var playerNumber: Int
    
    
    init(playerHand: Hands, playerName: String, playerNumber: Int) {
        self.playerHand = playerHand
        self.playerName = playerName
        self.playerNumber = playerNumber
    }

}
