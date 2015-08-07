//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import Foundation
import AssetsLibrary


class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeCellImageView: UIImageView!
    @IBOutlet weak var cellTopTextField: UITextField!
    @IBOutlet weak var cellBottomTextField: UITextField!
}

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    //add meme button
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    //shared array of memes
    var memes : [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        //keep tabBar in view
        self.tabBarController?.tabBar.hidden = false
        
        //load shared meme array each time view will appear
//        self.memes = MemeData.sharedInstance().memes
        self.collectionView!.reloadData()   //repopulates cells
    }
    
    override func viewDidAppear(animated: Bool) {
        //present Meme Editor if no memes in array, else do nothing
        //SHOULD NEVER ARRIVE HERE
        //TABLE VC IS INITIAL VC
        //THIS IS HERE FOR SAFETY
        if /*self.memes.count*/ MemeData.sharedInstance().memes.count == 0 {
            var editVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
            self.navigationController?.presentViewController(editVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToMemeEditor(sender: UIBarButtonItem) {
        //dissmiss VC and return to MemeEditVC
        var editVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
        self.navigationController?.presentViewController(editVC, animated: true, completion: nil)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //returns size of memes array to populate collection
        return /*self.memes.count*/MemeData.sharedInstance().memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        //displays meme image for viewing
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeIndex = indexPath.row  //MemeDetailVC loads meme objects directly from index
        self.navigationController?.pushViewController(detailController, animated: true)
    }
        
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //sets cell based on meme in array
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = /*self.memes*/MemeData.sharedInstance().memes[indexPath.row]
        
        //textField attributes
        let memeCellTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 10)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        //text overlay on images
        //text attributes similar to Meme Editor Text Fields
        cell.cellTopTextField.defaultTextAttributes = memeCellTextAttributes
        cell.cellBottomTextField.defaultTextAttributes = memeCellTextAttributes
        
        //Center allignment
        cell.cellTopTextField.textAlignment = NSTextAlignment.Center
        cell.cellBottomTextField.textAlignment = NSTextAlignment.Center
        
        //Lock fields so they can't be edited
        cell.cellTopTextField.enabled = false
        cell.cellBottomTextField.enabled = false
        
        //display text on top of original image for cleaner presentation
        cell.cellTopTextField.text = meme.topText
        cell.cellBottomTextField.text = meme.bottomText
        cell.memeCellImageView.image = self.getImageFromPath(meme.origImagePath)
        
        return cell
    }
    
}
