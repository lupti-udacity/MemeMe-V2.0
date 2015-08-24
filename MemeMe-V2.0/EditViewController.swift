//
//  EditViewController.swift
//  MemeMe-V2.0
//
//  Created by Lupti on 8/18/15.
//  Copyright (c) 2015 lupti. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //Initial states
    var cameraExisted: Bool!
    var albumExisted: Bool!
    var memesArraySize: Int!
    // Declarea memes array to store each Meme picked.
    var memes: [Meme]!
    var memeObject: Meme!
    var memesIndex: Int! = -1
    

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        println("the array size is \(memesArraySize)")
        if save() {
            println("Start Activity Controller")
            let activity = UIActivityViewController(activityItems: [memeObject.memedImage], applicationActivities: nil)
            println("Pick your action from the modal sliding up.")
            // Activate the completionWithItemsHandler closure
            activity.completionWithItemsHandler = {
                (activity, completed, items, error) in
                if (completed) {
                    println("CompleteWithItemHandler is completed...")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                println("completionWithItemsHandler closure is done with Activity \(activity)")
            }
            // Show the Share modal
            println("Sliding up the Activity Modal, pick your choice...but the response is very slow. Just need to wait till the simulator complete the initialization of the modal. :(")
            self.presentViewController(activity, animated: true, completion: nil)
        } else {
                println("Problem of storing the edited Meme. Share action skipped. Bail out")
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        // Assign text field delgate to all text fields
        top.delegate = self
        bottom.delegate = self
        

        // set custom text field attributes
        setTextAttrinutes()
        
        // Initialize top and botton 
        if memesIndex < 0 {
            top.text = "TOP"
            bottom.text = "BOTTOM"
        } else {
            // Clear the old texts from the previous edits.
            top.clearsOnBeginEditing = true
            bottom.clearsOnBeginEditing = true
        }
        // Set image to be see through if the top and bottom are overlayed by the image
        image.opaque = false
        
        top.textAlignment = NSTextAlignment.Center
        bottom.textAlignment = NSTextAlignment.Center
        
    }

    /* Beginning of the text field customizations */
    // Define meme text field dictionary
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        // Don't forget the unwrap optional UIFont return value. It is new.
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    // Assign text field dictionary to each top and bottom field.
    func setTextAttrinutes() {
        top.defaultTextAttributes = memeTextAttributes
        bottom.defaultTextAttributes = memeTextAttributes
    }

    // Set up the keyboard show and hide characters through subscibed and unsubscribed notification center and allowed notificiation name
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // Generic way to figure out the keyboard height according to the userInfo of the device.
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }

    func keyboardWillShow(notification: NSNotification) {
        println("Bottom Text is \(bottom.editing.boolValue)")
        println("Clear the text")
        
        if bottom.editing.boolValue {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        } else if top.editing.boolValue {
           
        }
        top.clearsOnBeginEditing = true
        bottom.clearsOnBeginEditing = true
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottom.editing.boolValue {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    

    // When the Return key is pressed, the soft keyboard should be retracked.
    // This is one of the builtin textField delegte optional function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.text = textField == top ? "TOP" : "BOTTOM"
        }
        setTextAttrinutes()
        self.view.endEditing(true)
        return false
    }
    
    // This is another optional function built in the textField delegate
    // Be careful the ternary statement that the conditional ? is separate to the
    // variable, otherwise, it will think it is an optional operator to the variable.
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.clearsOnBeginEditing = true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Showing up in viewWillAppear")
        println("The memes index is \(memesIndex)")
        // Check the data souce for the Sent Memes array in appDelegate
        // Invoke a singleton Application Delegate and make memes shared.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memesArraySize = appDelegate.memes.count
        println("memes array size is \(memesArraySize)")
        
        if (memesIndex >= 0 && memesArraySize > 0) {
        
            println("Retrieve the archive Meme.")
            memeObject = appDelegate.memes[memesIndex]
            image.image = memeObject.image
            top.text = memeObject.top
            bottom.text = memeObject.bottom
            println("Populate the Edit view from the appDelegate memes store")
    
            // Enable the keyboard notification
            self.subscribeToKeyboardNotifications()
            
        } else {
        // New Meme Request
        println("New Meme Request")
        // Quick check if the camera and photo album are available to display on the tool bar.
        cameraExisted = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        camera.enabled = cameraExisted
        albumExisted = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        album.enabled = albumExisted
        top.text = "TOP"
        bottom.text = "BOTTOM"
        top.clearsOnBeginEditing = true
        bottom.clearsOnBeginEditing = true
        image.clearsContextBeforeDrawing = true
        share.enabled = true
        top.hidden = false
        bottom.hidden = false
            // Diable the text fields if image is nil
            if let hasImage = image.image {
                println("It has image")
                top.enabled = true
                bottom.enabled = true
            } else {
                println("It has no image, both text fields are disabled.")
                top.enabled = false
                bottom.enabled = false
            }
        }
        
        if memesArraySize <= 0 {
            // disable Cancel button. 
            cancel.enabled = false
        }
        
        if let hasImage = image.image {
            cancel.enabled = true
        }
        
        // Enable the keyboard notification
        self.subscribeToKeyboardNotifications()
        
    }

    // View Controller to manage view dismissing
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    
    
    // Album picks
    @IBAction func pickAlbumPicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Dismiss image, one of the UIImagePickerController delegate function
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            // An image is picked.
            image.image = imagePicked
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // Camera functions
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Compose an UIImage with an overlay of top and bottom texts to the selected image
    func memedImage() -> UIImage{
        println("in the memedImage () call")
        // TODO: Hide toolbar and navbar
        toolBar.hidden = true
        navigationBar.hidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        toolBar.hidden = false
        navigationBar.hidden = false
        return memedImage
    }
    
    // Save UI image
    func save() -> Bool{
        println("Beginning saving meme to memedImage array")
        // Given basic data from the editor view, compose a memed image
        if let imageHasPicked = image.image {
            
            memeObject = Meme(top: self.top.text, bottom: self.bottom.text, image: self.image.image!, memedImage: memedImage())
            
            
            // Invoke a singleton Application Delegate and make memes shared.
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            // debug:
            appDelegate.memes.append(memeObject)
            memesArraySize = appDelegate.memes.count
            memesIndex = memesArraySize-1
            println("SAVE function is called and memes array size is \(memesArraySize)")
            return true
        }
        else {
            println("Image not picked")
            
            return false
        }
    }

}
