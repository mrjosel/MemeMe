//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/12/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var savedMemeImageView: UIImageView!
    var loadedMeme: MemeImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBarItem.enabled = false
//        self.tabBarItem.enabled = false
//        tabBarController?.tabBarItem.enabled = false
        self.savedMemeImageView.image = self.loadedMeme.memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
