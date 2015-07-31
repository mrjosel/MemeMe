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
    
    //loaded meme for display and further sharing/editing
    var loadedMeme: Meme!
    var memeIndex: Int!     //index of meme from memes array
    
    override func viewWillAppear(animated: Bool) {
        //display image everytime in case image was edited
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.loadedMeme = appDelegate.memes[memeIndex]
        self.savedMemeImageView.image = UIImage(contentsOfFile: self.loadedMeme.memedImagePath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")
        navigationItem.rightBarButtonItem = editButton
        
        //hide tabBar from view
        self.tabBarController?.tabBar.hidden = true
        
        //set image aspect view
        self.savedMemeImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func editMeme() {
        //present MemeEditVC
        var memeEditVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
        memeEditVC.meme = self.loadedMeme
        memeEditVC.index = self.memeIndex
        self.navigationController?.presentViewController(memeEditVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
