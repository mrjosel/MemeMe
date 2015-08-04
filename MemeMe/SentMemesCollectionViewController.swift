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
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        self.collectionView!.reloadData()   //repopulates cells
    }
    
    override func viewDidAppear(animated: Bool) {
        //present Meme Editor if no memes in array, else do nothing
        //SHOULD NEVER ARRIVE HERE
        //TABLE VC IS INITIAL VC
        //THIS IS HERE FOR SAFETY
        if self.memes.count == 0 {
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
    
//    func getImageFromPath(path: String) -> (UIImage) {
//        
//        //make URLs from paths
//        let imageURL = NSURL(string: path)
//        
//        //get data for images
//        let imageData = NSData(contentsOfURL: imageURL!)
//        
//        //make UIImages from data
//        let image = UIImage(data: imageData!)
//        
//        return image!
//    }
    
//    func getImageFromPath(path: String) -> UIImage {
//        //return image
//        var returnImage: UIImage?
//        
//        // error for loading image from memory
//        var loadError: NSError?
//        
//        //check if path is "asset"
//        if let string = path.rangeOfString("asset", options: nil, range: nil, locale: nil)  {
//            println("has asset in path")
//            let assetsLibrary = ALAssetsLibrary()
//            let url = NSURL(string: path)
//            
//            assetsLibrary.assetForURL(url!, resultBlock: {(asset) -> Void in
//                println("in positive results block")
//                returnImage = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
//                println(returnImage)
//                }, failureBlock: {(error) -> Void in
//                    loadError = error
//                    println("Error: \(loadError!.localizedDescription)")
//            })
//            println("finished assetsLibrary")
//            //TODO: copy asset to documents directory, user may delete photo, need local copy for app
//        } else {
//            println("no asset in filepath")
//            //make URLs from paths
//            if let imageURL = NSURL(string: path) {
//                //made URL
//                if let imageData = NSData(contentsOfURL: imageURL) {
//                    //made image Data
//                    if let image = UIImage(data: imageData) {
//                        //made image
//                        returnImage = image
//                    } else {
//                        //image failed
//                        println("Error: failed to make image from data")
//                        return UIImage()
//                    }
//                } else {
//                    println("Error: failed to get data from URL")
//                    return UIImage()
//                }
//            } else {
//                println("Error: failed to make url from path")
//                return UIImage()
//            }
//        }
//        return returnImage!
//    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //returns size of memes array to populate collection
        return self.memes.count
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
        let meme = self.memes[indexPath.row]
        
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
