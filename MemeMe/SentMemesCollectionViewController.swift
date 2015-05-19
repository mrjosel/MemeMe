//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    //array of saved memes
    var memes : [MemeImage]!
    
    override func viewWillAppear(animated: Bool) {
        //load memes array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        self.collectionView!.reloadData()   //repopulates cells
    }
    
    override func viewDidAppear(animated: Bool) {
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
        //gets size of collection
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.loadedMeme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
        
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        let memeCellTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 10)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        //image to display
        cell.memeCellImageView.image = meme.origImage
        
        //text overlay on images
        cell.cellTopTextField.defaultTextAttributes = memeCellTextAttributes
        cell.cellBottomTextField.defaultTextAttributes = memeCellTextAttributes
        
        cell.cellTopTextField.textAlignment = NSTextAlignment.Center
        cell.cellBottomTextField.textAlignment = NSTextAlignment.Center
        
        cell.cellTopTextField.text = meme.topText
        cell.cellBottomTextField.text = meme.bottomText
        
        
        return cell
    }
    
    
    
}
