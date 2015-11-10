//
//  FileWorker.swift
//  OSprojektHhrvoic
//
//  Created by Faculty of Organisation and Informatics on 05/11/15.
//  Copyright © 2015 air. All rights reserved.
//

import Foundation

public class File{
    let urla: NSURL
    
    
    public init (){ 
        urla = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    }
    public func writeToFile(content: String, filename:String){
        let fileDestinationUrl: NSURL = urla.URLByAppendingPathComponent(filename)
        do{  //error handling, do - try - catch (try je unutar do wrappera)
            // writing to disk
            try content.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding)
            // saving was successful. any code posterior code goes here
        } catch let error as NSError {
            print("error writing to url \(fileDestinationUrl)")
            print(error.localizedDescription)
        }
    }
    public func returnFileContents(filename: String)->String{
        let fileDestinationUrl: NSURL = urla.URLByAppendingPathComponent(filename)
        var fileContent: String?
        do {
            fileContent = try String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding)
            
        } catch let error as NSError {
            print("error loading from url \(fileDestinationUrl)")
            print(error.localizedDescription)
        }
        return fileContent! //vraca stringove iz dat ili null
    }
}
   