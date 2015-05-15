//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Jason Hoffman on 5/13/15.
//  Copyright (c) 2015 JHM. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {
    
    var filePathURL: NSURL!
    var title: String!
    
    // Initializer with the two variables 
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}
