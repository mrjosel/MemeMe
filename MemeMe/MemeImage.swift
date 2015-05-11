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
    //Struct has optional top and bottom UITextField from user input that are used in conjunction with UIImge to render new image with UITextFields superimposed on UIImage using method createMeme
    
    //Top and bottom strings, one or more could be optional
    var topText: String?
    var bottomText: String?
    //Image for MemeImage is required
    var origImage: UIImage!
    
    //output image from method 'createMeme'
    var memeImage: UIImage!
    
    func createMeme(topText: String, bottomText: String, image: UIImage) -> UIImage {
        //add code to create new image
        return memeImage
    }
}