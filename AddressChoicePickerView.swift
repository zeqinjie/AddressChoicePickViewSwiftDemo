//
//  AddressChoicePickerView.swift
//  AddressChoicePickViewSwiftDemo
//
//  Created by zhengzeqin on 15/9/11.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//

import UIKit

class AddressChoicePickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    typealias AddressChoicePickerViewBlock = (view:AddressChoicePickerView,obj:AreaObject)->()
    @IBOutlet weak var contentViewHegithCons: NSLayoutConstraint!
    
    @IBOutlet weak var pickView: UIPickerView!
    
    var locate:AreaObject? = AreaObject()
    //区域 数组
    var  regionArr: NSArray?
    //省 数组
    var  provinceArr: NSArray?
    //城市 数组
    var  cityArr: NSArray?
    //区县 数组
    var  areaArr: NSArray?
    
    
    var block:AddressChoicePickerViewBlock?
    
    //这里有待修改
    
    class func creatAddressChoicePickView()->AddressChoicePickerView{
        let v :AddressChoicePickerView =  (NSBundle.mainBundle().loadNibNamed("AddressChoicePickerView", owner: nil, options: nil).first as? AddressChoicePickerView)!;
        v.frame = UIScreen.mainScreen().bounds
        v.pickView.delegate = v;
        v.pickView.dataSource = v;
        v.regionArr = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("AreaPlist.plist", ofType: nil)!)
        v.provinceArr = v.regionArr!.firstObject!.objectForKey("provinces") as? NSArray;
        v.cityArr = v.provinceArr!.firstObject!.objectForKey("cities") as? NSArray;
        v.areaArr = v.cityArr!.firstObject!.objectForKey("areas") as? NSArray;
        v.locate!.region = v.regionArr!.firstObject!.objectForKey("region") as? String;
        v.locate!.province = v.provinceArr!.firstObject!.objectForKey("province") as? String;
        v.locate!.city = v.cityArr!.firstObject!.objectForKey("city") as? String;
        if (v.areaArr!.count > 0) {
            v.locate!.area = v.areaArr?.firstObject as? String;
        }else{
            v.locate!.area = "";
        }
        v.customView();
        
        return v;
    }

    
    func customView(){
        self.contentViewHegithCons.constant = 0;
        self.layoutIfNeeded();
    }
    
    
    //MARK: - action
    @IBAction func finishAction(sender: UIButton) {
        if(self.block != nil){
            self.block!(view: self,obj: self.locate!);
        }
        self.hide()
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.hide()
    }
    
    //MARK: - function
    func show(){
        let w:UIWindow? = UIApplication.sharedApplication().keyWindow;
        let topView:UIView? = w!.subviews.first;
        topView!.addSubview(self);
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.contentViewHegithCons.constant = 250.0;
            self.layoutIfNeeded();
        });
        
    }
    
    func hide(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0;
            self.contentViewHegithCons.constant = 0;
            self.layoutIfNeeded();
        }) { (Bool yes) -> Void in
            if yes{
                self.removeFromSuperview();
            }
        };
        
    }
    
    //MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 4;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch (component) {
            case 0:
                return self.regionArr!.count;
                
            case 1:
                return self.provinceArr!.count;
                
            case 2:
                return self.cityArr!.count;
           
            case 3:
                return self.areaArr!.count;
            default:
                return 0;
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch (component) {
        case 0:
            return self.regionArr!.objectAtIndex(row).objectForKey("region") as? String;
            
        case 1:
            return self.provinceArr!.objectAtIndex(row).objectForKey("province") as? String;
        case 2:
            return self.cityArr!.objectAtIndex(row).objectForKey("city") as? String;
        case 3:
            return self.areaArr!.objectAtIndex(row) as? String;
            
        default:
            return  "";

        }
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var l:UILabel? = view as? UILabel;
        if(l == nil ){
            l = UILabel();
            l?.minimumScaleFactor = 8.0;
            l?.textAlignment = .Center;
            l?.backgroundColor = UIColor.clearColor();
            l?.font = UIFont.systemFontOfSize(15);
            l?.adjustsFontSizeToFitWidth = true;
        }
        l?.text = self.pickerView(pickView, titleForRow: row, forComponent: component);
        return l!;
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(component == 0){
            
            self.provinceArr = self.regionArr!.objectAtIndex(row).objectForKey("provinces") as? NSArray;
            self.pickView.reloadComponent(1);
            self.pickView.selectRow(0, inComponent: 1, animated: true);
            self.cityArr = self.provinceArr!.objectAtIndex(0).objectForKey("cities") as? NSArray;
            self.pickView.reloadComponent(2);
            self.pickView.selectRow(0, inComponent: 2, animated: true);
            self.areaArr = self.cityArr?.objectAtIndex(0).objectForKey("areas") as? NSArray;
            self.pickView.reloadComponent(3);
            self.pickView.selectRow(0, inComponent: 3, animated: true);
            self.locate!.region = self.regionArr!.objectAtIndex(row).objectForKey("region") as? String;
            self.locate!.province = self.provinceArr!.objectAtIndex(row).objectForKey("province") as? String;
            self.locate!.city = self.cityArr?.objectAtIndex(0).objectForKey("city") as? String;
            
            if(self.areaArr!.count > 0){
                self.locate!.area = self.areaArr?.firstObject as? String;
            }else{
                self.locate!.area = "";
            }
            
        }else if(component == 1){
            self.cityArr = self.provinceArr!.objectAtIndex(row).objectForKey("cities") as? NSArray;
            self.pickView.reloadComponent(2);
            self.pickView.selectRow(0, inComponent: 2, animated: true);
            self.areaArr = self.cityArr!.objectAtIndex(0).objectForKey("areas") as? NSArray;
            self.pickView.reloadComponent(3);
            self.pickView.selectRow(0, inComponent: 3, animated: true);
            self.locate!.province = self.provinceArr?.objectAtIndex(row).objectForKey("province") as? String;
            self.locate!.city = self.cityArr!.objectAtIndex(0).objectForKey("city") as? String;
            if(self.areaArr!.count > 0){
                self.locate!.area = self.areaArr!.firstObject as? String;
            }else{
                self.locate!.area = "";
            }
            
        }else if(component == 2){
             self.areaArr = self.cityArr!.objectAtIndex(row).objectForKey("areas") as? NSArray;
            self.pickView.reloadComponent(3);
            self.pickView.selectRow(0, inComponent: 3, animated: true);
            self.locate!.city = self.cityArr?.objectAtIndex(0).objectForKey("city") as? String;
            if(self.areaArr!.count > 0){
                self.locate!.area = self.areaArr!.firstObject as? String;
            }else{
                self.locate!.area = "";
            }
            
        }else if(component == 3){
            if(self.areaArr!.count > 0){
                self.locate!.area = self.areaArr!.firstObject as? String;
            }else{
                self.locate!.area = "";
            }
        }
    }

}
















