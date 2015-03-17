// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var koko = [6...12]
var x = 0


func random() -> Int {
 
    var number = 0
    var limit = 20
    
    while number < limit {
        
        var lol = Int(arc4random_uniform(UInt32(50)))
        
        if lol > limit {
            number = lol
            break
        }
        
        
    }
    
    return number

    
}




































