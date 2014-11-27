//
//  Factory.swift
//  SlotMachine
//
//  Created by Chris Shaughnessy on 11/26/14.
//  Copyright (c) 2014 Webified Design. All rights reserved.
//

import Foundation
import UIKit

class Factory {
    class func createSlots() -> [[Slot]] {
        
        let kNumberOfSlots = 3
        let kNumberOfContainers = 4
        var slots: [[Slot]] = [] //create array of arrays
        
        // slots = [  [slot1, slot2, slot3],  [slot4, slot5, slot6],  [slot7, slot8, slot9]  ]
        // mySlotArray = slot[0] >> gives us '[slot1, slot2]'
        // slot = mySlotArray [1] >> gives us 'slot2'
        
        for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber { //run 3 times
            var slotArray: [Slot] = []
            
            for var slotNumber = 0; slotNumber < kNumberOfSlots; ++slotNumber { //run 3 times
                var slot = Factory.createSlot(slotArray) //create 3 slot instances
                slotArray.append(slot) //add 3 'slot' to our slotArray array
            }
            slots.append(slotArray) //add 3 'slotArrays' to our slots array
            
        }
        
        return slots //return the full slot array
    }
    
    class func createSlot(currentCards: [Slot]) -> Slot { //create a slot instance
        var currentCardValues:[Int] = []  //create array with card values for each slot
        
        for slot in currentCards { //cycle through 3 slot instances into currentCards
            currentCardValues.append(slot.value) //get value of slot and add to currentCardValues array
        }
        
        // Create loop to make assign random number and make sure number is not duplicated
        var randomNumber = Int(arc4random_uniform(UInt32(13))) //create random number 0-13
        while contains(currentCardValues, randomNumber + 1) { //check if currentCardValues contains that number, then add 1
            randomNumber = Int(arc4random_uniform(UInt32(13))) //updates random number until it finds a number that hasn't been used
        }
        
        var slot:Slot //create slot instance
        
        switch randomNumber { //if slot is case... create slot instance
        case 0:
            slot = Slot(value: 1, image: UIImage(named: "Ace"), isRed: true)
        case 1:
            slot = Slot(value: 2, image: UIImage(named: "Two"), isRed: true)
        case 2:
            slot = Slot(value: 3, image: UIImage(named: "Three"), isRed: true)
        case 3:
            slot = Slot(value: 4, image: UIImage(named: "Four"), isRed: true)
        case 4:
            slot = Slot(value: 5, image: UIImage(named: "Five"), isRed: false)
        case 5:
            slot = Slot(value: 6, image: UIImage(named: "Six"), isRed: false)
        case 6:
            slot = Slot(value: 7, image: UIImage(named: "Seven"), isRed: true)
        case 7:
            slot = Slot(value: 8, image: UIImage(named: "Eight"), isRed: false)
        case 8:
            slot = Slot(value: 9, image: UIImage(named: "Nine"), isRed: false)
        case 9:
            slot = Slot(value: 10, image: UIImage(named: "Ten"), isRed: true)
        case 10:
            slot = Slot(value: 11, image: UIImage(named: "Jack"), isRed: false)
        case 11:
            slot = Slot(value: 12, image: UIImage(named: "Queen"), isRed: false)
        case 12:
            slot = Slot(value: 13, image: UIImage(named: "King"), isRed: true)
        default:
            slot = Slot(value: 0, image: UIImage(named: "Ace"), isRed: true)
        }
        return slot
    }
    
}