//
//  ViewController.swift
//  Larek
//
//  Created by Denis Aganin on 17.03.15.
//  Copyright (c) 2015 Denis Aganin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tutorial: UIView!
    @IBOutlet weak var cigPacksLabel: UILabel!
    @IBOutlet weak var beerBottlesLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var armyLabel: UILabel!
    @IBOutlet weak var consoleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dangerLabel: UILabel!
    @IBOutlet weak var dayImage: UIImageView!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    
    var larek = Larek()
    var day = Day()
    var price = Price()
    var gopniks = 0
    var dayCount = 1
    var policeInTown = false
    var bank = false
    var bankSum = 0
    
    var timer = NSTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        timerEvents()
        refreshStats()
    }

    // Buttons
    
    @IBAction func buyCigs(sender: AnyObject) {
        
        buyCigs()
    }
    
    @IBAction func buyBeer(sender: AnyObject) {
        
        buyBeers()
    }
    
    @IBAction func buyFiveCigs(sender: AnyObject) {
        
        for i in 0 ..< 5 {
            buyCigs()
        }
    }
    
    @IBAction func buyFiveBeers(sender: AnyObject) {
        
        for i in 0 ..< 5 {
            buyBeers()
        }
    }
    
    @IBAction func payProtection(sender: AnyObject) {
        
        if larek.cash >= price.armyPrice {
            larek.cash -= price.armyPrice
            larek.army++
        } else {
            presentAlertWithText(header: "В кармане ветер", message: "... на душе печаль. Мало денег.")
        }
        refreshStats()
        
        
    }
    
    @IBAction func startSelling(sender: AnyObject) {
        
        sellCigs()
        sellBeers()
        gopAttack()
        changeTime()
        policeInTownFunc()
        bankDeposit()

        refreshStats()
        
        if larek.cash < 0 {
        gameOver()
        }
        
    }
    
    @IBAction func takeMoney(sender: AnyObject) {
        
        larek.cash += bankSum
        bankSum = 0
        refreshStats()
    }
    
    
    // Helpers
    
    func refreshStats() {

        cigPacksLabel.text = String(larek.cigPacks)
        beerBottlesLabel.text = String(larek.beerBottles)
        cashLabel.text = String(larek.cash)
        armyLabel.text = String(larek.army)
        timeLabel.text = String(day.time.showTime()) + " : 00"
        dayImage.image = day.time.showImage()
        dangerLabel.text = day.danger.dangerName()
        dayCountLabel.text = "День \(dayCount)"
        bankLabel.text = String(bankSum)
        
    }
    
    func changeTime() {
        
        switch day.time {
        case .Morning:
            day.time = .Day
            day.danger = .Normal
            dangerLabel.textColor = UIColor.orangeColor()
        case .Day:
            day.time = .Evening
            day.danger = .Normal
            dangerLabel.textColor = UIColor.orangeColor()
        case .Evening:
            day.time = .Night
            day.danger = .High
            dangerLabel.textColor = UIColor.redColor()
        case .Night:
            day.time = .Morning
            day.danger = .Low
            dangerLabel.textColor = UIColor.greenColor()
            dayCount++
            if dayCount >= 3 {
                bank = true
                presentAlertWithText(header: "Банк открылся", message: "... ларёк укрепился. Бизнесс в гору.")
            }
        }
    }
    
    func policeInTownFunc() {
        if policeInTown {
        policeInTown = false
        } else {
            if Int(arc4random_uniform(UInt32(101))) < 10 {
                policeInTown = true
                presentAlertWithText(header: "Менты в городе", message: "... гопы по кустам. Бизнесс в гору.")
            }
        }
    }
    
    func bankDeposit() {
        if bank == true {
            bankSum += (larek.cash * 10 / 100)
        }
    }
    
    // Sellers & Buyers
    
    func buyCigs() {
        if larek.cash >= price.cigPrice {
            larek.cash -= price.cigPrice
            larek.cigPacks++
        } else {
            presentAlertWithText(header: "В кармане ветер", message: "... на душе печаль. Мало денег.")
        }
        refreshStats()
    }
    
    func buyBeers() {
        if larek.cash >= price.beerPrice {
            larek.cash -= price.beerPrice
            larek.beerBottles++
        } else {
            presentAlertWithText(header: "В кармане ветер", message: "... на душе печаль. Мало денег.")
        }
        refreshStats()
    }
    
    func sellCigs() {
        let buyers = generateBuyers()
        println("\(buyers) cigsBuyers")
        var tempCigs = larek.cigPacks
        if larek.cigPacks == buyers {
            larek.cash += (larek.cigPacks * price.cigSellPrice)
            larek.cigPacks -= buyers
        } else if larek.cigPacks > buyers {
            larek.cash += (buyers * price.cigSellPrice)
            larek.cigPacks -= buyers
        } else {
            larek.cash += (tempCigs * price.cigSellPrice)
            larek.cigPacks -= tempCigs
        }
    }
    
    func sellBeers() {
        let buyers = generateBuyers()
        println("\(buyers) beersBuyers")
        var tempBeers = larek.beerBottles
        if larek.beerBottles == buyers {
            larek.cash += (larek.beerBottles * price.beerSellPrice)
            larek.beerBottles -= buyers
        } else if larek.beerBottles > buyers {
            larek.cash += (buyers * price.beerSellPrice)
            larek.beerBottles -= buyers
        } else {
            larek.cash += (tempBeers * price.beerSellPrice)
            larek.beerBottles -= tempBeers
        }
    }

    
    // Attacks
    
    func gopAttack() {
        if policeInTown {
            consoleLabel.text = "Несколько спокойных часов всегда хорошо для бизнесса. Но менты уезжают, гопы просыпаются..."
            return
        }
        let gopniks = generateGopniks()
        let deadBratki = Int(arc4random_uniform(UInt32(larek.army))) + 1
        let percentOfStolen = Int(Double(larek.cash) * 0.01)
        let stolenMoney = ((price.gopRaidPrice + percentOfStolen) * (gopniks - larek.army))
        println("\(gopniks) gops")
        if gopniks < larek.army && gopniks != 0  && larek.army != 0 {
            if Int(arc4random_uniform(UInt32(101))) < 90 {
            consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. Никто кроме них не пострадал."
            } else {
                larek.army -= deadBratki
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. В бою погибло \(deadBratki) братанов."
            }
            reviveArmy()
            return
        }
        if gopniks == larek.army && gopniks != 0 && larek.army != 0 {
            if Int(arc4random_uniform(UInt32(101))) < 65 {
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. Никто кроме них не пострадал."
            } else {
                larek.army -= deadBratki
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. В бою погибло \(deadBratki) братанов."
            }
            reviveArmy()
            return
        }
        if gopniks > larek.army && gopniks != 0 && larek.army == 1 {
            if Int(arc4random_uniform(UInt32(101))) < 20 {
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. Никто кроме них не пострадал. Выжившие гопы успели стырить у вас \(stolenMoney) деревянных."
                larek.cash -= stolenMoney
            } else {
                if Int(arc4random_uniform(UInt32(101))) < 50 {
                larek.army -= 1
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, и ваш бравй браток пал в бою защищая ларёк. Гопы стырили у вас \(stolenMoney) деревянных."
                larek.cash -= stolenMoney
                } else {
                    consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваш бравый браток сумел уцелеть. Гопы стырили у вас \(stolenMoney) деревянных."
                    larek.cash -= stolenMoney
                }
            }
            reviveArmy()
            return
        }
        if gopniks > larek.army && gopniks != 0 && larek.army != 0 {
            if Int(arc4random_uniform(UInt32(101))) < 20 {
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. Никто кроме них не пострадал. Выжившие гопы успели стырить у вас \(stolenMoney) деревянных."
                larek.cash -= stolenMoney
            } else {
                larek.army -= deadBratki
                consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников, но ваша крыша их завалила. В бою погибло \(deadBratki) братанов. Выжившие гопы успели стырить у вас \(stolenMoney) деревянных."
                larek.cash -= stolenMoney
            }
            reviveArmy()
            return
        }
        if larek.army == 0 && gopniks != 0 {
            consoleLabel.text = "Ваш ларёк атаковала банда из \(gopniks) гопников. Гопы стырили у вас \(stolenMoney) деревянных. Братков бы сюда..."
            larek.cash -= stolenMoney
            reviveArmy()
            return
        }
    }
    
    
    
    // Generators
    
    func generateBuyers() -> Int {
        
        var numberOfCustomers = 0
        let limit = day.time.minCustomerLimit()
        
        while numberOfCustomers < limit {
            var randomizer = Int(arc4random_uniform(UInt32(day.time.customerLimit())))
    
            if randomizer > limit {
                numberOfCustomers = randomizer
                break
            }
        }
        return numberOfCustomers
    }
    
    
    func generateGopniks() -> Int {
        
        var numberOfGopniks = 0
        let limit = day.danger.minGopnikLimit() + larek.army
        
        while numberOfGopniks < limit {
            var randomizer = Int(arc4random_uniform(UInt32(day.danger.maxGopnikLimit() + larek.army)))
            
            if randomizer > limit {
                numberOfGopniks = randomizer
                break
            }
        }
        return numberOfGopniks
    }
    
    // Game Over
    
    func presentAlertWithText(header: String = "Пацан к успеху шёл", message: String = "... но не дошёл. Вы проиграли.") {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "О'Кей", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func gameOver() {
        presentAlertWithText()
        larek = Larek()
        day = Day()
        gopniks = 0
        dayCount = 1
        policeInTown = false
        bank = false
        bankSum = 0
        consoleLabel.text = ""
        refreshStats()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        tutorial.hidden = true
    }
    
    func reviveArmy() {
        if larek.army < 0 {
            larek.army = 0
        }
    }
    
    
    // Timer Events
    
    func startTimer() {
        timer = NSTimer(timeInterval: 30, target: self, selector: "timerEvents", userInfo: nil, repeats: true)
    }
    
    func timerEvents() {
        if Int(arc4random_uniform(UInt32(101))) < 15 {
            if Int(arc4random_uniform(UInt32(101))) < 30 {
                larek.cash -= 200
                consoleLabel.text = "Прижали менты, пришлось раскошелиться на взятку. Минус 200 из кармана..."
                refreshStats()
            } else {
                larek.cash -= 500
                consoleLabel.text = "Эффективная торговля творит чудеса. Лишняя пятисотка в карман."
                refreshStats()
            }
        }
    }

}

