//
//  DebugViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/12/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {
    
    @IBOutlet weak var debugImageView: UIImageView!
    var testMemeImage: MemeImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.debugImageView.image = testMemeImage.memedImage
        println(self.testMemeImage)
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
