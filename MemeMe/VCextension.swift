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
        
        //check if path is "asset"
//        if let string = path.rangeOfString("asset", options: nil, range: nil, locale: nil)  {
//            
//            let assetsLibrary = ALAssetsLibrary()
//            let url = NSURL(string: path)
//            
//            assetsLibrary.assetForURL(url, resultBlock: {(asset) -> Void in
//                returnImage = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
//                }, failureBlock: {(error) -> Void in
//                    loadError = error
//                    println("Error: \(loadError!.localizedDescription)")
//            })
//            
//        } else {
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
//        }
        return returnImage!
    }

}