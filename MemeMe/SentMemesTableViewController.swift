//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import Foundation
import AssetsLibrary

class MyCustomCell: UITableViewCell {
    
    var test = NSLayoutAttribute.TrailingMargin
    var tester = NSLayoutRelation.Equal
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 112.5, height: 75)    //approx landscape image dimensions
        self.imageView?.backgroundColor = UIColor.grayColor()                   //portrait images have grey background color
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
}

class SentMemesTableViewController: UITableViewController, UITableViewDataSource {
    
    //add meme button
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    //shared array of memes
    var memes : [Meme]?

    override func viewWillAppear(animated: Bool) {
        //keep tabBar in view
        self.tabBarController?.tabBar.hidden = false
        
        //load shared meme array each time view will appear
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        self.tableView.reloadData() //repopulates cells

    }
    
    override func viewDidAppear(animated: Bool) {
        //present Meme Editor if no memes in array, and load "No Saved Memes" to user, else do nothing
        if self.memes?.count == 0 {
            var editVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
            self.navigationController?.presentViewController(editVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnToMemeEditor(sender: UIBarButtonItem) {
        //dissmiss VC and return to MemeEditVC
        var editVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewController") as! MemeEditViewController
        self.navigationController?.presentViewController(editVC, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns size of memes array to populate table
        return memes!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //sets cell based on meme in array
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! MyCustomCell
        let meme = self.memes![indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        
        cell.imageView?.image = self.getImageFromPath(meme.memedImagePath)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //displays meme image for viewing
        var detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeIndex = indexPath.row  //MemeDetailVC loads meme objects directly from index
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memes![indexPath.row]
        println("origPath = \(/*self.memes![indexPath.row]*/meme.origImagePath)")
        println("memePath = \(/*self.memes![indexPath.row]*/meme.memedImagePath)")
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteMemeImages(/*self.memes![indexPath.row]*/meme){ success, error in
                if success {
                    /*self.memes![indexPath.row]*/meme.sharedMemesArray("delete", index: indexPath.row)
                    self.memes?.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.returnToMemeEditor(self.addMemeButton) //returns to MemeEditVC
                } else {
                    //TODO: find out why I can't delete things
                    println("Error: \(error!.localizedDescription)")
//                    println("origPath = \(/*self.memes![indexPath.row]*/meme.origImagePath)")
//                    println("memePath = \(/*self.memes![indexPath.row]*/meme.memedImagePath)")
//                    let alertVC = UIAlertController(title: "Error Deleting", message: "Failed to Delete one or more Images", preferredStyle: UIAlertControllerStyle.Alert)
//                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action in
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    })
//                    alertVC.addAction(okButton)
//                    self.presentViewController(alertVC, animated: true, completion: nil)
                    self.displayAlert(self)
                    tableView.editing = false
                }
            }
//            self.memes?[indexPath.row].sharedMemesArray("delete", index: indexPath.row)
//            self.memes?.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//            self.returnToMemeEditor(self.addMemeButton) //returns to MemeEditVC
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
