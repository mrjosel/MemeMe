//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDataSource {
    
    //add meme button
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    //shared array of memes
    var memes : [MemeImage]!
    
    override func viewWillAppear(animated: Bool) {
        //load shared meme array each time view will appear
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        self.tableView.reloadData() //repopulates cells
    }
    
    override func viewDidAppear(animated: Bool) {
        //present Meme Editor if no memes in array, else do nothing
        if self.memes.count == 0 {
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
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //sets cell based on meme in array
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.origImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //displays meme image for viewing
        var detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.loadedMeme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
