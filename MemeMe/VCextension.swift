//
//  VCextension.swift
//  MemeMe
//
//  Created by Brian Josel on 8/4/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

extension UIViewController {
    func getImageFromPath(path: String) -> UIImage {
        //return image
        var returnImage: UIImage?
        
        // error for loading image from memory
        var loadError: NSError?
        
            //make URLs from paths
            if let imageURL = NSURL(string: path) {
                //made URL
                if let imageData = NSData(contentsOfURL: imageURL) {
                    //made image Data
                    if let image = UIImage(data: imageData) {
                        //made image
                        returnImage = image
                    } else {
                        //image failed
                        println("Error: failed to make image from data")
                        return UIImage()
                    }
                } else {
                    println("Error: failed to get data from URL")
                    return UIImage()
                }
            } else {
                println("Error: failed to make url from path")
                return UIImage()
            }
        return returnImage!
    }
    
    func displayAlert(hostViewController: UIViewController) {
        let alertVC = UIAlertController(title: "Error Deleting", message: "Failed to Delete one or more Images", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVC.addAction(okButton)
        hostViewController.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func deleteMemeImages(meme: Meme, completionHandler:(success: Bool, error: NSError?) -> Void) {
        
        //optional error
        var error: NSError?
        
        //get paths for meme images
        let origImagePath = meme.origImagePath
        let memedImagePath = meme.memedImagePath
        
        //attempt delete
        let origResult = NSFileManager.defaultManager().removeItemAtPath(origImagePath, error: &error)
        let memedResult = NSFileManager.defaultManager().removeItemAtPath(memedImagePath, error: &error)
        
        if (origResult && memedResult) {
            completionHandler(success: true, error: nil)
        } else {
            completionHandler(success: false, error: error)
        }
    }

}