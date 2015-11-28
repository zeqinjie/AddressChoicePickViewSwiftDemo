//
//  ViewController.swift
//  AddressChoicePickViewSwiftDemo
//
//  Created by zhengzeqin on 15/9/11.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }


    @IBAction func touch(sender: UITapGestureRecognizer) {
        let addressPickerView:AddressChoicePickerView = AddressChoicePickerView.creatAddressChoicePickView();
        addressPickerView.show();
        addressPickerView.block = {
            (view:AddressChoicePickerView,obj:AreaObject) in
            self.label.text = "";
            self.label.text = obj.region!+" "+obj.province!+" "+obj.city!+" "+obj.area!;
            return Void()
            
        };
    }
    
    

}

