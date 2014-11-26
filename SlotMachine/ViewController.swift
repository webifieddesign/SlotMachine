//
//  ViewController.swift
//  SlotMachine
//
//  Created by Chris Shaughnessy on 11/25/14.
//  Copyright (c) 2014 Webified Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    var titleLabel: UILabel!
    
    // Information Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    // Buttons in fourth container
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    // Slots array
    var slots:[[Slot]] = []
    
    
    // Stats
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    
    // Responsive constants
    let kMarginForView: CGFloat = 10.0
    let kMarginForSlot: CGFloat = 2.0
    
    let kSixth:CGFloat = 1.0/6.0
    let kThird:CGFloat = 1.0/3.0
    let kHalf:CGFloat = 1.0/2.0
    let kEight:CGFloat = 1.0/8.0
    
    // Slot contants
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupContainerViews()
        setupFirstContainer(self.firstContainer)
        setupThirdContainer(self.thirdContainer)
        setupFourthContainer(self.fourthContainer)
        hardReset() //sets up second container with numbers reset
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    IBActions (button presses)
    func resetButtonPressed (button: UIButton) {
        hardReset() //reloads second container with numbers reset
    }
    
    func betOneButtonPressed (button: UIButton) {
        
        if credits <= 0 {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        }
        else {
            if currentBet < 5 {
                currentBet += 1
                credits -= 1
                updateMainView()
            }
            else {
                showAlertWithText(message: "You can only bet 5 credits at a time!")
            }
        }
    }
    
    func betMaxButtonPressed (button: UIButton) {
        
        if credits <= 5 {
            showAlertWithText(header: "Not Enough Credits", message: "Bet Less")
        }
        else {
            if currentBet < 5 {
                var creditsToBetMax = 5 - currentBet
                credits -= creditsToBetMax
                currentBet += creditsToBetMax
                updateMainView()
            }
            else {
                showAlertWithText(message: "You can only bet 5 credits at a time!")
            }
        }
    }
    
    func spinButtonPressed (button: UIButton) {
        removeSlotImageViews()
        slots = Factory.createSlots() //create a new set of slots
        setupSecondContainer(self.secondContainer) //generate new image views
        
        var winningsMultiplier = SlotBrain.computeWinnings(slots)
        winnings = winningsMultiplier * currentBet
        credits += winnings
        currentBet = 0
        updateMainView()
        
        println("**End of turn")
        
    }

//    HELPER FUNCTIONS
    
//    Set up container views (modularizes code)
    func setupContainerViews () {
        
//        Create first container with top box
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.view.addSubview(self.firstContainer)
        
//        Create second container
        secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height, width: view.bounds.width - (kMarginForView * 2), height: view.bounds.height * (3 * kSixth)))
        secondContainer.backgroundColor = UIColor.blackColor()
        view.addSubview(secondContainer)
        
//        Create third container
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.thirdContainer)
        
//        Create fourth container
        fourthContainer = UIView(frame: CGRect(x: view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, width: view.bounds.width - (kMarginForView * 2), height: view.bounds.height * kSixth))
        fourthContainer.backgroundColor = UIColor.whiteColor()
        view.addSubview(fourthContainer)
    }
    
    func setupFirstContainer (containerView: UIView) {
        self.titleLabel = UILabel()  // create instance of UILabel
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Ultralight", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        containerView.addSubview(self.titleLabel)
    }
    
    func setupSecondContainer (containerView: UIView) {
        for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber {
            
            for var slotNumber = 0; slotNumber < kNumberOfSlots; ++slotNumber {
                
                var slot:Slot //create variable named slot, not yet giving value
                var slotImageView = UIImageView()
                
                if slots.count != 0 { //once we've generated slots with spin button
                    let slotContainer = slots[containerNumber] //index into slots array using containerNumber (column 1, 2, or 3) -- outer for loop
                    slot = slotContainer[slotNumber] //index into slot array using slotNumber (row 1, 2, or 3)- inner for loop
                    slotImageView.image = slot.image //access image property for slot instance
                }
                else {
                    slotImageView.image = UIImage(named: "Ace") //if not created yet just load aces
                }
                
                slotImageView.backgroundColor = UIColor.yellowColor()
                slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * kThird), y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumber) * kThird), width: containerView.bounds.width * kThird - kMarginForSlot, height: containerView.bounds.height * kThird - kMarginForSlot)
                containerView.addSubview(slotImageView)
            }
        }
    }
    
    func setupThirdContainer (containerView: UIView) {
        
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
//        self.creditsLabel.textColor = UIColor.redColor()
//        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16) // before sizeToFit
        self.creditsLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.creditsLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird)
        self.creditsLabel.textAlignment = NSTextAlignment.Center
//        self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.creditsLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
//        self.betLabel.textColor = UIColor.redColor()
//        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.betLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPoint(x: containerView.frame.width * (kSixth * 3), y: containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
//        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.betLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
//        self.winnerPaidLabel.textColor = UIColor.redColor()
//        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.winnerPaidLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPoint(x: containerView.frame.width * (kSixth * 5), y: containerView.frame.height * kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
//        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credits"
//        self.creditsTitleLabel.textColor = UIColor.blackColor()
//        self.creditsTitleLabel.font = UIFont(name: "Helvetica", size: 16)
        self.creditsTitleLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.creditsTitleLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * (kThird * 2))
        self.creditsTitleLabel.textAlignment = NSTextAlignment.Center
        containerView.addSubview(self.creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
//        self.betTitleLabel.textColor = UIColor.blackColor()
//        self.betTitleLabel.font = UIFont(name: "Helvetica", size: 16)
        self.betTitleLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.betTitleLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPoint(x: containerView.frame.width * (kSixth * 3), y: containerView.frame.height * (kThird * 2))
        self.betTitleLabel.textAlignment = NSTextAlignment.Center
        containerView.addSubview(self.betTitleLabel)
        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
//        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
//        self.winnerPaidTitleLabel.font = UIFont(name: "Helvetica", size: 16)
        self.winnerPaidTitleLabel.textColor = UIColor(red: 0.65, green: 0.2, blue: 0.2, alpha: 1.0)
        self.winnerPaidTitleLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * (kSixth * 5), y: containerView.frame.height * (kThird * 2))
        self.winnerPaidTitleLabel.textAlignment = NSTextAlignment.Center
        containerView.addSubview(self.winnerPaidTitleLabel)
    }
    
    func setupFourthContainer (containerView: UIView) {
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Highlighted)
        self.resetButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        self.resetButton.layer.cornerRadius = 5
        self.resetButton.layer.borderWidth = 1
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: containerView.frame.width * kEight, y: containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * (3 * kEight), y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * (5 * kEight), y: containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * (7 * kEight), y: containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.spinButton)
    }
    
    func removeSlotImageViews() {
        if self.secondContainer != nil {
            let container: UIView? = self.secondContainer
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true) //we will be adding same amount of slots, so we want to keep memory capacity
        self.setupSecondContainer(self.secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
        
        updateMainView()
    }
    
    func updateMainView() {
        self.creditsLabel.text = "\(credits)"
        self.betLabel.text = "\(currentBet)"
        self.winnerPaidLabel.text = "\(winnings)"
    }
    
    //create alert on screen with Warning title and message parameter
    func showAlertWithText (header: String = "Warning", message: String) {
        // Create alert with Warning: message
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // Option to dismiss alert with title "Ok" and default options
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        // Present alert on screen
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

