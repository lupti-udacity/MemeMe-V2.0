//
//  MemeDetailViewController.swift
//  MemeMe-V2.0
//
//  Created by Lupti on 8/18/15.
//  Copyright (c) 2015 lupti. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var image: UIImageView!
    
    var meme: Meme!
    
    var allMemes: [Meme]!
    var memesIndex: Int! = -1
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        allMemes = applicationDelegate.memes
        println("All memes array count is \(allMemes.count)")
        println("Passed in memes array index is \(memesIndex)")
        if memesIndex >= 0 {
            meme = allMemes[memesIndex]
            self.image.image = meme.memedImage
        }
        else {
            let tableHandle: SentMemeTableViewController!
            tableHandle = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemeTableViewController") as! SentMemeTableViewController
            tableHandle.memesIndex = -1
            presentViewController(tableHandle, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func editMeme(sender: AnyObject) {
        let addHandle: EditViewController!
        addHandle = self.storyboard?.instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
        addHandle.memesIndex = self.memesIndex
        self.presentViewController(addHandle, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

}
