//
//  ImageSelectViewController.swift
//  TestUIIMagePicker
//
//  Created by Brian Josel on 4/29/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //memeImage object
    var memeImage = MemeImage()
    
    //TODO  - incorporate textDelegates
    //      - save all info to memeImage
    //      - implement save and cancel buttons
    //      - hid pick button while editing text????
    //      - center pick/camera buttons, add icons instead of text
    
    override func viewWillAppear(animated: Bool) {
        //limits camera button in simulator, only allows on HW where camera is suported
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //hide textFields from view until image is picked
        if self.imageView.image == nil {
            self.topTextField.hidden = true
            self.bottomTextField.hidden = true
        } else {    //reveal textfields if image is selected THIS IS BACKUP, DOES NOT WORK, CAN BE DELETED
            self.topTextField.hidden = false
            self.bottomTextField.hidden = false
        }
    }
    
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
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismisses view back to initial toolbar view
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

