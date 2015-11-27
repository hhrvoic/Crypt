//
//  RSA.swift
//  OSprojektHhrvoic
//
//  Created by Faculty of Organisation and Informatics on 05/11/15.
//  Copyright © 2015 air. All rights reserved.
//
//
import Foundation
import Heimdall //koristi se za RSA i digitalni potpis
//
public class RSASign {
    public var heimdallObj: Heimdall?
    public init (){
        heimdallObj = Heimdall(tagPrefix: "cryptoOS")
    }
    public func encryptRSA(textToEncrypt: String)->String{
        return  heimdallObj!.encrypt(textToEncrypt)!
    }
    public func decryptRSA(textToDecrypt: String) -> String
    {
//        if let decryptedString = heimdallObj!.decrypt(textToDecrypt)                  {
//            print(decryptedString) // "This is a test string"
//            return decryptedString
//        }
       return heimdallObj!.decrypt(textToDecrypt)!
    }
    public func sign(textToSign: String)-> String{
        let signature: String?
        signature=heimdallObj!.sign(textToSign)
            print(signature)
        return signature!
    }
    public func Verify (textToVerify: String, signature: String) -> Bool{
        // Signatures/Verification
         let verified=heimdallObj!.verify(textToVerify, signatureBase64: signature)
                print(verified)
                return verified
    }
    public func getPrivateKey() -> String{
        let privateKeyData = heimdallObj!.privateKeyDataX509() //tipa NSData
        return (privateKeyData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
    }
    public func getPublicKey() -> String{
        let publicKeyData = heimdallObj!.publicKeyDataX509()
        return (publicKeyData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
    }
}