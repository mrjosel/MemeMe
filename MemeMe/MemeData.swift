//
//  MemeData.swift
//  MemeMe
//
//  Created by Brian Josel on 8/6/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

class MemeData: AnyObject {
    
    //array of all memes made
    var memes: [Meme] = []

    //singleton for using Memes across app
    class func sharedInstance() -> MemeData {
        struct Singleton {
            static var sharedInstance = MemeData()
        }
        return Singleton.sharedInstance
    }
    
    func sharedMemesArray(meme: Meme, action: String, index: Int?) {
        //method for adding new memes, deleting memes, or editing memes in the shared meme array
        //method is called in MemeEditVC and used for deletion in SentMemesTableVC
        
        //switch action based on delete, add, or edit
        switch action {
        case "delete":
            //delete
            MemeData.sharedInstance().memes.removeAtIndex(index!)
        case "add":
            //add
            MemeData.sharedInstance().memes.append(meme)
        case "edit":
            MemeData.sharedInstance().memes[index!] = meme
        default:
            //error
            println("invalid action")
        }
    }
}