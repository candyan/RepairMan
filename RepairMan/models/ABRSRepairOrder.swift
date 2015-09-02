//
//  ABRSRepairOrder.swift
//  
//
//  Created by liuyan on 9/2/15.
//
//

import UIKit

enum ABRSRepairType: Int {
    case General = 1
    
    var stringValue: String {
        switch(self) {
        case .General:
            return "一般行政维修"
        }
    }
}

enum ABRSRepairTroubleLevel: Int {
    case NotUrgent = 0, Urgent, VeryUrgent
    
    var stringValue: String {
        switch(self) {
        case .NotUrgent:
            return "不紧急"
            
        case .Urgent:
            return "紧急"
            
        case .VeryUrgent:
            return "非常紧急"
        }
    }
}

class ABRSRepairOrder: AVObject, AVSubclassing {
    
    var troubleImageURLs: [NSURL]? {
        get {
            var imageURLs = [NSURL]()
            let imageURLStrs = self["trouble_image_urls"] as? [String]
            if imageURLStrs != nil {
                for urlStr in imageURLStrs! {
                    imageURLs.append(NSURL(string: urlStr)!)
                }
            }
            return imageURLs
        }
        set(newImageURLs) {
            self.removeObjectForKey("trouble_image_urls")
            if newImageURLs != nil {
                var imageURLStrs = [String]()
                for imageURL in newImageURLs! {
                    imageURLStrs.append(imageURL.absoluteString!)
                }
                self.addObjectsFromArray(imageURLStrs, forKey: "trouble_image_urls")
            }
        }
    }
    
    var repairType: ABRSRepairType {
        get {
            return ABRSRepairType(rawValue: self["repair_type"] as! Int)!
        }
        set(newType) {
            self["repair_type"] = newType.rawValue
        }
    }
    
    var poster: AVUser {
        get {
            return (self["poster"] as! AVUser).fetchIfNeeded() as! AVUser
        }
        set(newUser) {
            self["poster"] = newUser
        }
    }
    
    var troubleDescription: String {
        get {
            return self["trouble_description"] as! String
        }
        set(newDesc) {
            self["trouble_description"] = newDesc
        }
    }
    
    var address: String {
        get {
            return self["address"] as! String
        }
        set(newAddress) {
            self["address"] = newAddress
        }
    }
    
    var troubleLevel: ABRSRepairTroubleLevel {
        get {
            return ABRSRepairTroubleLevel(rawValue: self["trouble_level"] as! Int)!
        }
        set(newLevel) {
            self["trouble_level"] = newLevel.rawValue
        }
    }
    
    static func parseClassName() -> String! {
        return NSStringFromClass(self)
    }
   
}
