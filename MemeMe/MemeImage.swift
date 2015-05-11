//
//  MemeImage.swift
//  MemeMe
//
//  Created by Brian Josel on 5/11/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

struct MemeImage {
    //struct for an image that is Meme'ed
    //Struct has optional top and bottom UITextField from user input that are used in conjunction with UIImge to render new image with UITextFields superimposed on UIImage.  Method exists in MemeMeViewController
    
    //all variables of MemeImage struct
    //Top and bottom strings, one or more could be optional
    var topText: String?
    var bottomText: String?
    
    //Image from user, required from user
    var origImage: UIImage!
    
    //output image from method 'createMeme'
    var memedImage: UIImage?
    
    
    //Initializers
    init(userTopText: String?, userBottomText: String?, userImage: UIImage?) {
        //if user entered text for top and bottom strings, set the appropriate variables, else set to empty strings
        //memedImage is still not defined until MemeMeViewController creates memedImage
        
        //top text
        if let topString = userTopText {
            self.topText = topString
        } else {
            self.topText = ""
        }
        //bottom text
        if let bottomString = userBottomText {
            self.bottomText = bottomString
        } else {
            self.bottomText = ""
        }
        //user image
        self.origImage = userImage
    }
    
        //Initialize with no params, should not ever need this
    init () {
        self.topText = ""
        self.bottomText = ""
        self.origImage = UIImage()
        self.memedImage = UIImage()
    }
}