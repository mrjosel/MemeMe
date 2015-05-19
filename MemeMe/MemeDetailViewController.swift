//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/12/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var savedMemeImageView: UIImageView!
    
    //loaded meme for display and further sharing
    var loadedMeme: MemeImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //hide tabBar from view
        tabBarController?.tabBar.hidden = true
        
        //display memedImage
        self.savedMemeImageView.image = self.loadedMeme.memedImage
        self.savedMemeImageView.contentMode = UIViewContentMode.ScaleAspectFit

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
