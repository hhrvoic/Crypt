//
//  AES.swift
//  Crypt
//
//  Created by Faculty of Organisation and Informatics on 09/11/15.
//  Copyright © 2015 air. All rights reserved.
//

import Foundation
import CryptoSwift
public extension String {
    public func aesEncrypt(key: String, iv: String) throws -> String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    public func aesDecrypt(key: String, iv: String) throws -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        if let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        {
            return result as String
        }
        else {
            return "Fuljali ste" 
        }
    }
}