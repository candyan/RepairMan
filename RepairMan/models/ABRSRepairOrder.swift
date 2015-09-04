//
//  ABRSRepairOrder.swift
//  
//
//  Created by liuyan on 9/2/15.
//
//

import UIKit

enum ABRSRepairType: Int {
    case General = 0, Hardware, Software
    
    var stringValue: String {
        switch(self) {
        case .General:
            return "行政维修类（门锁、空调、桌椅等）"

        case .Hardware:
            return "办公设备类（打印机、复印机、传真机等）"

        case .Software:
            return "系统软件类"
        }
    }
}

enum ABRSRepairStatus: Int {
    case Waiting = 0, Repairing, Finished

    var stringValue: String {
        switch(self) {
        case .Waiting:
            return "等待维修"

        case .Repairing:
            return "维修中"

        case .Finished:
            return "已完成"
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

    func troubleImageFiles() -> [AVFile]? {
        return self["troubleImageFiles"] as? [AVFile]
    }

    func setTroubleImages(newImages: [UIImage]?) {
        self.removeObjectForKey("troubleImageFiles")
        if newImages != nil {
            var imageFiles = [AVFile]()
            for image in newImages! {
                let imageData = UIImageJPEGRepresentation(image, 0.6)
                var file = AVFile.fileWithName("\(imageData.md5()).jpg", data: imageData) as! AVFile
                file.save()
                imageFiles.append(file)
            }
            self.addObjectsFromArray(imageFiles, forKey: "troubleImageFiles")
        }
    }

    func repairType() -> ABRSRepairType {
        return ABRSRepairType(rawValue: self["repairType"] as! Int)!
    }

    func setRepairType(newType: ABRSRepairType) {
        self["repairType"] = newType.rawValue
    }

    func poster() -> AVUser {
        return (self["poster"] as! AVUser).fetchIfNeeded() as! AVUser
    }

    func setPoster(newPoster: AVUser) {
        self["poster"] = newPoster
    }

    func troubleDescription() -> String {
        let desc = self["troubleDescription"] as? String
        return (desc == nil) ? "" : desc!
    }

    func setTroubleDescription(newDesc: String) {
        self["troubleDescription"] = newDesc
    }

    func address() -> String? {
        let address = self["address"] as? String
        return (address == nil) ? "" : address!
    }

    func setAddress(newAddress: String) {
        self["address"] = newAddress
    }

    func troubleLevel() -> ABRSRepairTroubleLevel {
        return ABRSRepairTroubleLevel(rawValue: self["troubleLevel"] as! Int)!
    }

    func setTroubleLevel(newLevel: ABRSRepairTroubleLevel) {
        self["troubleLevel"] = newLevel.rawValue
    }
    
    class func parseClassName() -> String! {
        return "ABRSRepairOrder"
    }
    
    func serviceman() -> AVUser {
        return (self["serviceman"] as! AVUser).fetchIfNeeded() as! AVUser
    }

    func setServiceman(newServiceman: AVUser) {
        self["serviceman"] = newServiceman
    }

    func repairStatus() -> ABRSRepairStatus {
        return ABRSRepairStatus(rawValue: self["repairStatus"] as! Int)!
    }

    func setRepairStatus(newStatus: ABRSRepairStatus) {
        self["repairStatus"] = newStatus.rawValue
    }

}
