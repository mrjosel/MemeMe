//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 4/29/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tabBarSpacingItemL: UIBarButtonItem! //not set in VC, default behavior is desired behavior
    @IBOutlet weak var tabBarSpacingItemR: UIBarButtonItem! //not set in VC, default behavior is desired behavior
    @IBOutlet weak var directionsLabel: UILabel!
    
    //ability to know if editing an existing meme or not
    var editMode: Bool!
    var index: Int?
    
    //testField delegates
    let topTextFieldDelegate = MemeTextDelegate()
    let bottomTextFieldDelegate = MemeTextDelegate()
    
    //memeImage object
    var meme: Meme?
    
    //memeImage image path attributes, get from memeImage, or store for constructing a new memeImage
    var origImagePath: String?
    var memedImagePath: String?
    
    //set textField attributes (font, size, etc)
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
        
    override func viewWillAppear(animated: Bool) {
        //get memes count to disable cancel button or not
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.cancelButton.enabled = appDelegate.memes.count == 0 ? false : true
        
        //limits camera button in simulator, only allows on HW where camera is suported
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //subscribe to keyboard notifications to allow for resizing view when needed
        self.subscribeToKeyboardNotifications()
        
        //if meme is present, then editMode must be true, set the following params to allow editing
        if let meme = self.meme {
            self.editMode = true
            self.shareButton.enabled = true
            self.imageView.image = UIImage(contentsOfFile: meme.origImagePath)
            self.topTextField.hidden = false
            self.topTextField.text = meme.topText
            self.bottomTextField.hidden = false
            self.bottomTextField.text = meme.bottomText
            self.directionsLabel.hidden = true
        } else {
            //if meme optional is nil, then its a new meme and editMode is false
            self.editMode = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications() //remove keyboard notification subscriptions from other views
    }
    
    func setDefaultParams() {   //various params that change depending on user activity, method allows user to restore defaults
        self.imageView.image = UIImage()    //blank image
        self.directionsLabel.hidden = false
        
        //default text, hidden prior to image selection
        self.topTextField.text = "TOP"
        self.topTextField.hidden = true
        self.bottomTextField.text = "BOTTOM"
        self.bottomTextField.hidden = true
        
        //original button settings, camera button initial view set if present or not
        self.albumButton.enabled = true
        self.shareButton.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //set background color and image scaling aspect
        self.view.backgroundColor = UIColor.blackColor()
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        //set default params, see method above
        self.setDefaultParams()
        //Set Delegates
        self.topTextField.delegate = self.topTextFieldDelegate
        self.bottomTextField.delegate = self.bottomTextFieldDelegate

        //assign attributes to textFields, set background color to translucent
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes

        //Set individual fields delegate properties for TOP and BOTTOM
        self.topTextFieldDelegate.position = .Top
        self.bottomTextFieldDelegate.position = .Bottom

        //Set Text Allignment
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {    //saves new memeImage and presents sharing activities to user
        
        //create meme object from view
        let memedImage = self.generateMemedImage()
        
        //create meme object - TODO: Need memedImagePath!
        self.meme = Meme(userTopText: self.topTextField.text, userBottomText: self.bottomTextField.text, origImagePath: self.origImagePath!, memedImagePath: self.memedImagePath!)
        
        //share MemeImages across all ViewControllers
        //if new meme, add to array.  if editing, overwrite that index
        if !editMode {
            self.meme!.sharedMemesArray("add", index: nil)  //index ignored in method during "add"
        } else {
            self.meme!.sharedMemesArray("edit", index: self.index!)
        }

        //create instance of UIActivityViewController, exclude various sharing activities
        let activityVC : UIActivityViewController = UIActivityViewController(activityItems: [UIImage(contentsOfFile: self.memedImagePath!)!/*self.memeImage!.memedImage*/], applicationActivities: nil)  //need to fix applicationActivities
        activityVC.excludedActivityTypes = [UIActivityTypePostToVimeo, UIActivityTypePostToWeibo,
                                            UIActivityTypePostToTencentWeibo, UIActivityTypeAddToReadingList,
                                            UIActivityTypeAirDrop, UIActivityTypeAssignToContact]
        
        //dismisses activityVC and shows SentMemesTableViewController upon activity finish
        activityVC.completionWithItemsHandler = {activity, completed, items, error in
            if completed {
                activityVC.dismissViewControllerAnimated(true, completion: nil)
                self.setDefaultParams() //make defaults
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        //present view controller
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {  //creates new memeImage from view
        //remove keyboard if still visible
        self.view.endEditing(true)
        
        //remove toolbar and navbar
        self.navBar.hidden = true
        self.toolbar.hidden = true
        
        //finish editing both textFields
        self.topTextField.resignFirstResponder()
        self.bottomTextField.resignFirstResponder()
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //restore toolbar and navbar
        self.navBar.hidden = false
        self.toolbar.hidden = false
        
        return memedImage
    }
    
    //-----Following methods all related to resizing view when keyboard appeara/dissappers-------------------------
    func subscribeToKeyboardNotifications() {
        //Keyboard show/hide notifications - func called in viewWillAppear
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        //removing keyboard show/hide notifications - func called in viewWillDisappear
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //shrink view by size of keyboard to not obscure bottom field
        if bottomTextField.editing {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //resize view to original
        if bottomTextField.editing {
            self.view.frame.origin.y += self.getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //gets size of keyboard to be used in resizing the view
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    //------------------------------End of view resizing methods--------------------------------------------------
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //presents chosen image to view, reveals textFeilds for editing
//        println(info)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            var imageUrl: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            self.origImagePath = imageUrl.absoluteString //info[UIImagePickerControllerReferenceURL] as? String ?? "no imagePath"
            println(self.origImagePath)
            self.directionsLabel.hidden = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)   //dismisses pickerController
        //reveals textFields and shareButton for editing
        self.topTextField.hidden = false
        self.bottomTextField.hidden = false
        self.shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismisses view back to initial toolbar view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        self.setDefaultParams()     //returns default params
        self.view.endEditing(true)  //removes keyboard from view
        
        //transitions to SentMemesTableViewController as per criteria
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func launchAlbum(sender: UIBarButtonItem) {
        //presents UIImagePickerController
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func useCamera(sender: UIBarButtonItem) {
        //presents Camera to user
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(cameraController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

