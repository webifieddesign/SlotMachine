//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Chris Shaughnessy on 11/26/14.
//  Copyright (c) 2014 Webified Design. All rights reserved.
//

import Foundation

class SlotBrain {
    
    class func unpackSlotsIntoSlotRows (slots: [[Slot]]) -> [[Slot]] {
        
        var slotRow1: [Slot] = []
        var slotRow2: [Slot] = []
        var slotRow3: [Slot] = []
        var slotRow4: [Slot] = []
        
        for slotArray in slots {
            for var index = 0; index < slotArray.count; index++ {
                let slot = slotArray[index]
                if index == 0 {
                    slotRow1.append(slot)
                }
                else if index == 1 {
                    slotRow2.append(slot)
                }
                else if index == 2 {
                    slotRow3.append(slot)
                }
                else if index == 3 {
                    slotRow4.append(slot)
                }
                else {
                    println("Error")
                }
            }
        }
        var slotsInRows: [[Slot]] = [slotRow1, slotRow2, slotRow3, slotRow4]
        
        return slotsInRows
    }
    
    class func computeWinnings (slots: [[Slot]]) -> Int {
        
        var slotsInRows = unpackSlotsIntoSlotRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var fourOfAKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            
            if checkFlush(slotRow) == true {
                println("flush")
                winnings += 1
                flushWinCount += 1
            }
            
            if checkFourInARow(slotRow) == true {
                println("Four in a row")
                winnings += 1
                straightWinCount += 1
            }
            
            if checkFourOfAKind(slotRow) == true {
                println("Four of a kind")
                winnings += 3
                fourOfAKindWinCount += 1
            }
            
        }
        
        if flushWinCount == 4 {
            println("Royal Flush")
            winnings += 15
        }
        
        if straightWinCount == 4 {
            println("Epic Straight")
            winnings += 1000
        }
        
        if fourOfAKindWinCount == 4 {
            println("Fours all around")
            winnings += 50
        }
        
        return winnings
    }
    
    class func checkFlush (slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        let slot4 = slotRow[3]
        
        if slot1.isRed == true && slot2.isRed == true && slot3.isRed == true {
            return true && slot4.isRed
        }
        else if slot1.isRed == false && slot2.isRed == false && slot3.isRed == false && slot4.isRed {
            return true
        }
        else {
            return false
        }
    }
    
    class func checkFourInARow (slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        let slot4 = slotRow[3]
        
        if slot1.value == slot2.value - 1 && slot1.value == slot3.value - 2 && slot1.value == slot4.value - 3 {
            return true
        }
        else if slot1.value == slot2.value + 1 && slot1.value == slot3.value + 2 && slot1.value == slot4.value + 3 {
            return true
        }
        else {
            return false
        }
    }
    
    class func checkFourOfAKind (slotRow: [Slot]) -> Bool {
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        let slot4 = slotRow[3]
        
        if slot1.value == slot2.value && slot1.value == slot3.value && slot1.value == slot4.value {
        return true
        }
        else {
            return false
        }
    }
}