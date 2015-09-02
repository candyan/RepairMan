//
//  ItemPhotosEditorView.swift
//  
//
//  Created by liuyan on 9/2/15.
//
//

import UIKit

class ItemPhotosEditorView: UIView {
    
    private var itemPhotos = NSMutableArray(capacity: 8)
    private var photoButtons = NSMutableArray(capacity: 8)
    private weak var addButton: UIButton?
    private weak var draggingButton: UIButton?
    
    private var imageButtonSize: CGFloat {
        return (self.bounds.width - 10 * 2 - 3 * 7) / 4.0
    }
    
    var photos: NSArray! {
        return NSArray(array: itemPhotos)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadSubviews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addItemPhoto(photo: UIImage!) {
        
    }
    
    func photoButtonTouchUpInsideHandler(sender: UIButton?) {
        
    }
    
    func addButtonTouchUpInsideHandler(sender: UIButton?) {
        
    }
    
    func photoPanGestureRecognizedHandler(gr: UIPanGestureRecognizer?) {
        if gr?.state == .Began {
            draggingButton = gr?.view as? UIButton
            if draggingButton != nil {
                self.bringSubviewToFront(draggingButton!)
            }
        }
        
        if gr?.state == .Changed {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addButton?.hidden = (self.itemPhotos.count >= 8)
        self.bringSubviewToFront(self.addButton!)
        
        for (index, photoButton) in enumerate(photoButtons) {
            let photoPosition = index.photoPosition
            
            let originX = (13 + photoPosition.y * (self.imageButtonSize + 13))
            let originY = (10 + photoPosition.x * (self.imageButtonSize + 7))
            
            photoButton.setFrameSize(CGSize(width: self.imageButtonSize, height: self.imageButtonSize))
            if self.draggingButton != photoButton as? UIButton {
                photoButton.setFrameOriginPoint(CGPoint(x: originX, y: originY))
            }
            
            if index == self.itemPhotos.count {
                self.addButton?.frame = CGRect(x: originX, y: originY,
                    width: self.imageButtonSize, height: self.imageButtonSize)
            }
            
        }
    }
}

extension ItemPhotosEditorView {
    private func loadSubviews() {
        for _ in 1...8 {
            let button = UIButton.photoImageButton()
            button?.addTarget(self, action: "photoButtonTouchUpInsideHandler", forControlEvents: .TouchUpInside)
            
            let panGR = UIPanGestureRecognizer(target: self, action: "photoPanGestureRecognizedHandler")
            panGR.maximumNumberOfTouches = 1
            panGR.delegate = self
            
            button?.addGestureRecognizer(panGR)
            
            self.addSubview(button!)
        }
        
        addButton = UIButton(frame: CGRectZero)
        self.addSubview(addButton!)
        
        addButton!.setImage(UIImage(name: "ItemAddImage"), forState: .Normal)
        addButton!.backgroundColor = UIColor(hex: 0x4A90E2)
        addButton!.addTarget(self, action: "addButtonTouchUpInsideHandler", forControlEvents: .TouchUpInside)
    }
}

extension ItemPhotosEditorView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let view = gestureRecognizer.view
        
        if view == nil {
            return false
        }
        
        let viewIndex = photoButtons.indexOfObject(view!)
        
        return viewIndex < itemPhotos.count
    }
}

extension Int {
    private var photoPosition: CGPoint {
        return CGPoint(x: self % 4, y: self / 4)
    }
}

extension CGPoint {
    
    private func photoIndexForViewSize(size: CGSize) -> Int {
        let row = self.y < (size.height / 2.0) ? 0 : 1 as Int
        let col = Int(floor(self.x / (size.width / 4.0)))
        
        return row * 4 + col
    }
}

extension UIButton {
    private static func photoImageButton() -> UIButton? {
        let button = UIButton(frame: CGRectZero)
        button.backgroundColor = UIColor(hex: 0xEEEEEE)
        return button
    }
}