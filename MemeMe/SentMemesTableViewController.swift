//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 5/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    var memes : [MemeImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
    }
    
    @IBAction func returnToMemeEditor(sender: UIBarButtonItem) {
        //dissmiss VC and return to MemeEditVC
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.loadedMeme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
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
