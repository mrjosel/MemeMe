//
//  MemeMeViewController.swift
//  MemeMe
//
//  Created by Brian Josel on 4/29/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var saveMemeImageButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //testField delegates
    let topTextFieldDelegate = MemeTextDelegate()
    let bottomTextFieldDelegate = MemeTextDelegate()
    
    //memeImage object
    var memeImage = MemeImage()
    
    //TODO  
    //      - implement default/toggle default method
    //          -perhaps switch argument depending on button?
    //      - hide pick button while editing text????
    //      - center pick/camera buttons, add icons instead of text
    //      - render new memeImage
    //      - save/share functions
    
    override func viewWillAppear(animated: Bool) {
        //limits camera button in simulator, only allows on HW where camera is suported
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //subscribe to keyboard notifications to allow for resizing view when needed
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications() //remove keyboard notification subscriptions from other views
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set Delegates
        self.topTextField.delegate = self.topTextFieldDelegate
        self.bottomTextField.delegate = self.bottomTextFieldDelegate
        
        //set textField attributes (font, size, etc)
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 3.0
        ]
        
        //assign attributes to textFields
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
        
        //Set default text
        //TODO - Implement in delegate class later
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"

        
        //hide textFields from view until image is picked
        if self.imageView.image == nil {
            self.topTextField.hidden = true
            self.bottomTextField.hidden = true
            self.saveMemeImageButton.enabled = false
            self.cancelButton.enabled = false
        } else {    //reveal textfields and save button if image is selected THIS IS BACKUP, DOES NOT WORK, CAN BE DELETED
            self.topTextField.hidden = false
            self.bottomTextField.hidden = false
            self.saveMemeImageButton.enabled = true
            self.cancelButton.enabled = false
        }
    }
    
    @IBAction func saveMemeImage(sender: UIBarButtonItem) {
        self.memeImage = MemeImage(userTopText: self.topTextField.text, userBottomText: self.bottomTextField.text, userImage: self.imageView.image!, memedImage: self.generateMemedImage())
        println(self.memeImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.navigationBarHidden = true
        self.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.navigationController?.navigationBarHidden = false
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
        self.memeImage = MemeImage()        //clears out memeImage content
        self.imageView.image = UIImage()    //blank image
        //restores default text
        self.topTextField.text = "TOP"
        self.topTextField.hidden = true
        self.bottomTextField.text = "BOTTOM"
        self.bottomTextField.hidden = true
        //returns buttons back to original settings
        self.pickButton.enabled = true
        self.saveMemeImageButton.enabled = false
        self.cancelButton.enabled = false
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

