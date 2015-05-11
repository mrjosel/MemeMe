//
//  MemeMeViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 4/29/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController {
    //ViewController first allows user to take picture with Camera (if available), or select an image from memory
    //After UIImage is selected, user is prompted with two UITextFields for editing
    //Resulting UIImage and two UITextFields are rendered into a new MemeImage struct and saved to memory
    //App allows for all Meme'ed images to be recalled at any time
    //App allows user to share meme'ed images with friends

    var testMemeImage: MemeImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

