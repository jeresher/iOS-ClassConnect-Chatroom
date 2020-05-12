//
//  Utilities.swift
//  ChatroomApp
//
//  Created by Jere Sher on 11/13/17.
//  Copyright © 2017 Pegasus. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    let bannedWords = ["anal","anus","arse","ass","ballsack","balls","bastard","bitch","biatch","bloody","blowjob","blow job","bollock","bollok","boner","boob","bugger","bum","butt","buttplug","clitoris","cock","coon","crap","cunt","damn","dick","dildo","dyke","fag","feck","fellate","fellatio","felching","fuck","fudgepacker","flange","Goddamn","hell","homo","jerk","jizz","knobend","knobend","labia","muff","nigger","nigga","omg","penis","piss","poop","prick","pube","pussy","queer","scrotum","sex","shit","sh1t","slut","smegma","spunk","tit","tosser","turd","twat","vagina","wank","whore","wtf"]
    
    let redColor = UIColor(red: 232.0/255.0, green: 86.0/255.0, blue: 52.0/255.0, alpha: 1)
    let blueColor = UIColor(red: 0.0/255.0, green: 118.0/255.0, blue: 255.0/255.0, alpha: 1)
    let grayColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1)

    
    func errorAlert(message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: "ClassConnect", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func displayNameChecker(_ name: String) -> Bool {
        let name = name.lowercased()
        // If the name is greater than 20 digits.
        if name.count > 20 || name.count < 3 {
            return false
        }
        // If there are any special characters: return false.
        let specialCharacters = CharacterSet(charactersIn: " !#$%&'()*+,-./:;<=>?@[]^_`{|}~")
        if name.rangeOfCharacter(from: specialCharacters) != nil {
            return false
        }
        
        // If there are any banned words present: return false.
        for i in bannedWords {
            if name.range(of: i) != nil {
                return false
            }
        }
        return true
    }
    
    // Converts firebase chatroomValue to List.
    func chatroomStringToListConverter(_ string: String) -> [String] {
        
        var newList: [String] = []
        
        var chatroom = ""
        
        for i in string {
            if i == "," {
                newList.append(chatroom)
                chatroom = ""
            } else {
                chatroom += String(i)
            }
        }
        
        return newList
    }
    
    func chatroomListToStringConverter (_ list: [String]) -> String {
        let string = list.joined(separator: ",")
        let newString = string + ","
        return newString
    }
    
    func convertTimestamp(_ time: Any) -> String {
        let unixToDouble = Double(String(describing: time) + ".0")
        let x = unixToDouble! / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: date as Date)
    }
    
    func chatroomIDcreator(text: String, addedByUser: String) -> String {
        let newText = String(text.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-")) != nil })
        let randomValue = arc4random_uniform(1000)
        let final = ("\(newText):\(addedByUser):\(randomValue)")
        return final
    }
    
    func chatroomIDChecker(_ text: String) -> Bool {
        
        let specialCharacters = CharacterSet(charactersIn: " !#$%&'()*+,./:;<=>?@[]^_`{|}~")
        if text.rangeOfCharacter(from: specialCharacters) != nil {
            return false
            
        } else if text == ""{
            return false
        } else {
            return true
        }
    }
}
