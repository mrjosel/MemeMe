//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    //array of saved memes
    var memes : [MemeImage]!
    
    override func viewWillAppear(animated: Bool) {
        //load memes array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
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
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //gets size of collection
        println(self.memes.count)
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.loadedMeme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
        
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("cellForRowAtIndexPath")

        //let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeCellImageView.image = meme.memedImage
        
        return cell
    }
    
    
    
}
