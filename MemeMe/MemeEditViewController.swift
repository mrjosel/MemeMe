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
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    
    //testField delegates
    let topTextFieldDelegate = MemeTextDelegate()
    let bottomTextFieldDelegate = MemeTextDelegate()
    
    //memeImage object
    var memeImage = MemeImage()
    
    //set textField attributes (font, size, etc)
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    //TODO
    //      - center pick/camera buttons, add icons instead of text
    //      - blurry image after rendering?
    //      - CODE CLEANUP


    
    override func viewWillAppear(animated: Bool) {
        
        //limits camera button in simulator, only allows on HW where camera is suported
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //subscribe to keyboard notifications to allow for resizing view when needed
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications() //remove keyboard notification subscriptions from other views
    }
    
    func setDefaultParams() {   //various params that change depending on user activity, method allows user to restore defaults

        //empty meme object and empty UIImageView
        self.memeImage = MemeImage()        //already set empty by class declaration, added here so user an restore defaults later
        self.imageView.image = UIImage()    //blank image
        
        //default text, hidden prior to image selection
        self.topTextField.text = "TOP"
        self.topTextField.hidden = true
        self.bottomTextField.text = "BOTTOM"
        self.bottomTextField.hidden = true
        
        //original button settings, camera button initial view set if present or not
        self.pickButton.enabled = true
        self.shareButton.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        self.memeImage = MemeImage(userTopText: self.topTextField.text, userBottomText: self.bottomTextField.text, userImage: self.imageView.image!, memedImage: self.generateMemedImage())
        
        //share MemeImages across all ViewControllers
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(self.memeImage)

        //create instance of UIActivityViewController, exclude various sharing activities
        let activityVC : UIActivityViewController = UIActivityViewController(activityItems: [self.memeImage.memedImage], applicationActivities: nil)  //need to fix applicationActivities
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.memeImage.origImage = image
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
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
    
    
    @IBAction func imagePicker(sender: UIBarButtonItem) {
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

