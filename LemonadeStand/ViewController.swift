//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Don Noray on 11/11/14.
//  Copyright (c) 2014 Don Noray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amtOfMoneyTextField: UILabel!
    @IBOutlet weak var numOfLemonsTextField: UILabel!
    @IBOutlet weak var numOfIceCubesTextField: UILabel!
    @IBOutlet weak var purchasedLemonsTextField: UILabel!
    @IBOutlet weak var purchasedIceCubesTextField: UILabel!
    @IBOutlet weak var mixLemonsTextField: UILabel!
    @IBOutlet weak var mixIceCubesTextField: UILabel!
    
    var playerInventory = Supplies(amtOfMoney: 10, lemons: 1, iceCubes: 1)
    let price = Price()
    
    var purchasedLemons = 0
    var purchasedIceCubes = 0
    var mixedLemons = 0
    var mixedIceCubes = 0
    
    var weatherArray:[[Int]] = [[-10, -9, -5, -7], [5, 8, 10, 9], [22, 25, 27, 23]]
    var weatherToday:[Int] = [0, 0, 0, 0]
    var weatherImageView:UIImageView = UIImageView(frame: CGRect(x: 20, y: 70, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(weatherImageView)
        
        simulateWeatherToday()
        updateMainView()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func purchaseLemonButtonPressed(sender: AnyObject) {
        self.purchaseLemons()
    }
    
    @IBAction func returnPurchasedLemonButtonPressed(sender: AnyObject) {
        self.returnLemons()
    }
   
    @IBAction func purchaseIceCubeButtonPressed(sender: AnyObject) {
        self.purchaseIceCubes()
    }
    
    @IBAction func returnPurchasedIceCubeButtonPressed(sender: AnyObject) {
        self.returnIceCubes()
    }
    
    @IBAction func mixLemonButtonPressed(sender: AnyObject) {
        self.mixLemons()
    }

    @IBAction func unmixLemonButtonPressed(sender: AnyObject) {
        self.returnMixedLemons()
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: AnyObject) {
        self.mixIceCubes()
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: AnyObject) {
        returnMixedIceCubes()
    }
    
    
    @IBAction func startDayButtonPressed(sender: AnyObject) {
        
        let average = findAverage(weatherToday)
        let customers = Int(arc4random_uniform(UInt32(abs(average))))
        
        if mixedLemons == 0 || mixedIceCubes == 0 {
            showAlertWithText(message: "You need to add at least 1 lemon and 1 ice cube.")
        }
        else {
            
            var lemonadeRatio:Double = Double(mixedLemons)
            
            if mixedIceCubes != 0 {
                lemonadeRatio = Double(mixedLemons) / Double(mixedIceCubes)
            }
        
        
            for i in 0...customers {
                let randomPreference = Double(arc4random_uniform(UInt32(101))) / 100
            
                if randomPreference < 0.4 && lemonadeRatio > 1 {
                    playerInventory.amtOfMoney += 1
                    println("Paid")
                }
                else if randomPreference > 0.0 && lemonadeRatio < 1 {
                    playerInventory.amtOfMoney += 1
                    println("Paid")
                }
                else if randomPreference <= 0.6 && randomPreference >= 0.4 && lemonadeRatio == 1 {
                    playerInventory.amtOfMoney += 1
                    println("Paid")
                }
                else {
                    println("Statement evaluating...")
                }
            }
          
            purchasedLemons = 0
            purchasedIceCubes = 0
            
            mixedLemons = 0
            mixedIceCubes = 0
            
            simulateWeatherToday()
            updateMainView()
        }
    }
    
    func purchaseLemons() {
        if playerInventory.amtOfMoney >= price.lemon {
            self.purchasedLemons += 1
            playerInventory.amtOfMoney -= price.lemon
            playerInventory.lemons += 1
            updateMainView()
            
        } else {
            showAlertWithText(message: "Not Enough Money")
        }
    }
    
    func returnLemons() {
        if purchasedLemons > 0 {
            self.purchasedLemons -= 1
            self.playerInventory.lemons += 1
            self.playerInventory.amtOfMoney += price.lemon
            updateMainView()
        }
        else {
            showAlertWithText(header: "Error!", message: "There are no more lemons to return")
        }
    }
    
    func purchaseIceCubes() {
        if playerInventory.amtOfMoney >= price.iceCube {
            self.playerInventory.iceCubes += 1
            self.purchasedIceCubes += 1
            playerInventory.amtOfMoney -= price.iceCube
            updateMainView()
            
        } else {
            showAlertWithText(message: "Not Enough Money")
        }
    }
    
    func returnIceCubes() {
        if purchasedIceCubes > 0 {
            self.purchasedIceCubes -= 1
            self.playerInventory.iceCubes += 1
            self.playerInventory.amtOfMoney += price.iceCube
            updateMainView()
        }
        else {
            showAlertWithText(header: "Error!", message: "There are no more ice cubes to return")
        }
    }
    
    func mixLemons() {
        if playerInventory.lemons > 0 {
            self.purchasedLemons = 0
            playerInventory.lemons -= 1
            self.mixedLemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "Your supply of lemons has ran out.")
        }
    }
    
    func returnMixedLemons() {
        if mixedLemons > 1 {
            self.purchasedLemons = 1
            self.mixedLemons -= 1
            playerInventory.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "There are no more lemons to unmix.")
        }
    }
    
    func mixIceCubes() {
        if playerInventory.iceCubes > 0 {
            self.purchasedIceCubes = 0
            playerInventory.iceCubes -= 1
            self.mixedIceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "Your supply of ice cubes has ran out.")
        }
    }
    
    func returnMixedIceCubes() {
        if mixedIceCubes > 0 {
            self.purchasedIceCubes = 0
            self.mixedIceCubes -= 1
            playerInventory.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "There are no more ice cubes to unmix.")
        }
    }
    
    
    func updateMainView() {
        self.amtOfMoneyTextField.text = "$\(playerInventory.amtOfMoney)"
        self.numOfLemonsTextField.text = "\(playerInventory.lemons) Lemons"
        self.numOfIceCubesTextField.text = "\(playerInventory.iceCubes) Ice Cubes"
        
        self.purchasedLemonsTextField.text = "\(purchasedLemons)"
        self.purchasedIceCubesTextField.text = "\(purchasedIceCubes)"
        
        self.mixLemonsTextField.text = "\(mixedLemons)"
        self.mixIceCubesTextField.text = "\(mixedIceCubes)"
        
    }
    
    
    func showAlertWithText (header : String = "Warning!", message : String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func simulateWeatherToday() {
        let index = Int(arc4random_uniform((UInt32(weatherArray.count))))
        weatherToday = weatherArray[index]
        
        switch index {
        case 0: weatherImageView.image = UIImage(named: "Cold")
        case 1: weatherImageView.image = UIImage(named: "Mild")
        case 2: weatherImageView.image = UIImage(named: "Warm")
        default: weatherImageView.image = UIImage(named: "Warm")
        }
    }
    
    func findAverage(data:[Int]) -> Int {
        var sum = 0
        
        for x in data {
            sum += x
        }
        
        var average:Double = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        
        return rounded
    }
    

}

