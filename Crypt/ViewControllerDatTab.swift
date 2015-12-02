//
//  ViewControllerKriptTab.swift
//  Crypt
//
//  Created by Faculty of Organisation and Informatics on 27/11/15.
//  Copyright © 2015 air. All rights reserved.
//

import UIKit
import CryptoModule
import FileModule

class ViewControllerDatTab: UIViewController {
    
   let fileWorker: File = File()
    
    

    @IBOutlet weak var sadrzajDat: UITextView!
    @IBOutlet weak var nazivDat: UITextField!
    
    @IBAction func onSpremiUDatotekuClicked(sender: UIButton) {
        fileWorker.writeToFile(sadrzajDat.text!, filename: nazivDat.text!)
        
    }
    @IBAction func onNazivDatotekeChanged(sender: UITextField) {
        LoadajSadrzaj(sender.text!)
    }
    
    func LoadajSadrzaj(nazivDatoteke: String){
        
        let sadrzaj = fileWorker.returnFileContents(nazivDatoteke)
        if(sadrzaj != ""){
            sadrzajDat.text = sadrzaj
        }
        else {
            sadrzajDat.text = "Nema ništa tu"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.// setup scrollview
        sadrzajDat.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        sadrzajDat.layer.borderWidth = 1.0
        sadrzajDat.layer.cornerRadius = 5
        sadrzajDat!.layer.borderWidth = 1
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
