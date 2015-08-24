//
//  Meme.swift
//  MemeMe-V2.0
//
//  Created by Lupti on 8/18/15.
//  Copyright (c) 2015 lupti. All rights reserved.
//

import UIKit

// Create a Meme Struct object 

struct Meme {
    let top: String
    let bottom: String
    let image: UIImage
    let memedImage: UIImage
    
    func memedText() -> String {
        var temp = top + " " + bottom
        println("\(temp)")
        return temp
    }
}