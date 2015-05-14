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
    @IBOutlet weak var saveMemeImageButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    
    
    //testField delegates
    let topTextFieldDelegate = MemeTextDelegate()
    let bottomTextFieldDelegate = MemeTextDelegate()
    
    //memeImage object
    var memeImage = MemeImage()
    
    //set textField attributes (font, size, etc)
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 3.0
    ]
    
    //TODO
    //      - save/share functions
    //      - center pick/camera buttons, add icons instead of text
    //      - implement default/toggle default method
    //          -perhaps switch argument depending on button?
    //      - hide pick button while editing text????
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
        self.saveMemeImageButton.enabled = false
        self.cancelButton.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set Delegates
        self.topTextField.delegate = self.topTextFieldDelegate
        self.bottomTextField.delegate = self.bottomTextFieldDelegate
        
        //assign attributes to textFields, set background color to translucent
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //Set individual fields delegate properties for TOP and BOTTOM
        self.topTextFieldDelegate.position = .Top
        self.bottomTextFieldDelegate.position = .Bottom
        
        //Make Clear buttons hidden unless delegate displays them
        //REMOVED FOR NOW, MAY IMPLEMENT IN FINAL VERSION
        //        topTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        //        topTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        //Set Text Allignment
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        
        //set default params, see method above
        self.setDefaultParams()
    }
    
    @IBAction func shareMeme(sender: UIButton) {
        self.memeImage = MemeImage(userTopText: self.topTextField.text, userBottomText: self.bottomTextField.text, userImage: self.imageView.image!, memedImage: self.generateMemedImage())
        let activityVC = UIActivityViewController(activityItems: [self.memeImage], applicationActivities: nil) as UIActivityViewController  //need to fix applicationActivities
        self.navigationController?.presentViewController(activityVC, animated: true, completion: nil)
        //what to do after passing memeObhect to activityVC?
    }
    
    
//    @IBAction func saveMemeImage(sender: UIBarButtonItem) { //creates memeImage object, segues to MemeDetailViewController
//        self.memeImage = MemeImage(userTopText: self.topTextField.text, userBottomText: self.bottomTextField.text, userImage: self.imageView.image!, memedImage: self.generateMemedImage())
//        self.performSegueWithIdentifier("memeDetail", sender: self)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {   //loads memeImage into next view, then segues
        if segue.identifier == "memeDetail" {
            let memeDetailVC: MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            memeDetailVC.loadedMeme = self.memeImage
        }
    }
    
    func generateMemedImage() -> UIImage {  //creates new memeImage from view
        //remove keyboard if still visible
        self.view.endEditing(true)
        
        //remove toolbar and navbar
        self.navigationController?.navigationBar.hidden = true
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
        self.navigationController?.navigationBar.hidden = false
        self.toolbar.hidden = false
        
        return memedImage
    }
    
    //-----Following methods all related to resizing view when keyboard appeara/dissappers
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
    //-----End of view resizing methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //presents chosen image to view, reveals textFeilds for editing
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.memeImage.origImage = image
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        self.dismissViewControllerAnimated(true, completion: nil)   //dismisses pickerController
        //reveals textFields for editing
        self.topTextField.hidden = false
        self.bottomTextField.hidden = false
        //enables saveMemeImageButton, disable pickButton unless canceled is selected
        self.saveMemeImageButton.enabled = true
        self.pickButton.enabled = false
        self.cancelButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismisses view back to initial toolbar view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        self.setDefaultParams()     //returns default params
        self.view.endEditing(true)  //removes keyboard from view
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

