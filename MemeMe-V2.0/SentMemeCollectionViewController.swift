//
//  SentMemeCollectionViewController.swift
//  MemeMe-V2.0
//
//  Created by Lupti on 8/18/15.
//  Copyright (c) 2015 lupti. All rights reserved.
//

import UIKit


class SentMemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    var memes: [Meme]!
    var memesIndex: Int! = -1
    
    @IBOutlet var sentMemeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBAction func addMeme(sender: AnyObject) {
        var addHandle: EditViewController
        addHandle = self.storyboard?.instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
        addHandle.memesIndex = -1  // New Meme
        presentViewController(addHandle, animated: true, completion: nil)
        
    }
  
    // Invoke a singleton Application Delegate ans share the memes array.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        self.memes = applicationDelegate.memes
        sentMemeCollectionView.reloadData()
        println("View Will Appear Memes Count \(self.memes.count)")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the collection view flow layout properties
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        println("collection count = \(self.memes.count)")
        return self.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        let cell: SentMemeCollectionViewCell!
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemedImageCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        
        // Configure the cell
        let meme = memes[indexPath.item]
        cell.memedImageView.image = meme.memedImage
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.item]
        detailController.memesIndex = indexPath.item
        // Use pushView instead of presentView to have view slides from right to left. Otherwise it will slide from bottom to top.
        self.navigationController?.pushViewController(detailController, animated: true)
    }

}
