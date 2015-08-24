//
//  SentMemeTableViewController.swift
//  MemeMe-V2.0
//
//  Created by Lupti on 8/18/15.
//  Copyright (c) 2015 lupti. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController, UITableViewDataSource, UINavigationControllerDelegate {
    // memesIndex keeps track of the current image that was picked from the memes array. It will be used to pass along to the next Edit VC.
    var memesIndex: Int! = -1
    var allMemes: [Meme]!

    @IBOutlet weak var addMeme: UIBarButtonItem!
    
    @IBAction func add(sender: AnyObject) {
        var addHandle: EditViewController
        addHandle = storyboard?.instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
        addHandle.memesIndex = -1  // Mark the new Meme
        presentViewController(addHandle, animated: true, completion: nil)
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        allMemes = applicationDelegate.memes
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Transition to Edit View if the SentMemes is empty as it begins.
        if allMemes.count == 0 {
            add(self)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return allMemes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as! UITableViewCell
        let memed = allMemes[indexPath.row]
        memesIndex = indexPath.row
        // The following two fields are table view cell default properties you can populate.
        cell.textLabel?.text = memed.memedText()
        cell.imageView?.image = memed.image
        println("table cell: \(cell.textLabel?.text)")

        return cell
    }
    
    // Select an item and push it to detail view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetail = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetail.meme = allMemes[indexPath.row]
        memeDetail.memesIndex = indexPath.row
        println("From Table View, the index path is \(memeDetail.memesIndex)")
        navigationController?.pushViewController(memeDetail, animated: true)
        
    }
    

}
