//
//  Meme.swift
//  MemeMe
//
//  Created by Brian Josel on 8/6/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

extension Meme: Printable {
    //Allows MemeImage to be Printable for debug
    
    var description: String {
        get {
            return "toptext = \(topText) \n bottomText = \(bottomText) \n origImage = \(origImagePath) \n memedImage = \(memedImagePath)"
        }
    }
}

struct Meme {
    //class for an image that is Meme'ed
    //class has optional top and bottom UITextField from user input that are used in conjunction with UIImge to render new image with UITextFields superimposed on UIImage.  Method exists in MemeEditVC
    
    //all variables of MemeImage struct
    //Top and bottom strings, one or more could be optional
    var topText: String
    var bottomText: String
    
    //Image from user, required from user, struct can't be instanced until image is present
    var origImagePath: String   //path string used for CoreData
    
    //output image from method 'createMeme'
    var memedImagePath: String  //path string used for CoreData
    
    
    //Initializers
    init(userTopText: String, userBottomText: String, origImagePath: String, memedImagePath: String) {
        //if user entered text for top and bottom strings, set the appropriate variables, else set to empty strings
        //memedImage is still not defined until MemeMeViewController creates memedImage
        self.topText = userTopText
        self.bottomText = userBottomText
        self.origImagePath = origImagePath
        self.memedImagePath = memedImagePath
    }
    
    //Initialize with no params, should not ever need this
    init () {
        self.topText = ""
        self.bottomText = ""
        self.origImagePath = "" //UIImage()  //already implicitly unwrapped
        self.memedImagePath = "" //UIImage()
    }
}