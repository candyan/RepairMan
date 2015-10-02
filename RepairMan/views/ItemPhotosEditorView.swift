//
//  ItemPhotosEditorView.swift
//  
//
//  Created by Cherry on 9/2/15.
//
//

import UIKit

class ItemPhotosEditorView: UIView {
    
    private var itemPhotos = NSMutableArray(capacity: 8)
    private var photoButtons = NSMutableArray(capacity: 8)
    private var addButton: UIButton?
    private weak var draggingButton: UIButton?

    var addButtonDidTouchUpInsideBlock: (()->())?
    var photoButtonDidTouchUpInsideBlock: ((photo: UIImage, index: Int)->())?
    
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
        self.itemPhotos.addObject(photo)

        let button = self.photoButtons.objectAtIndex(self.itemPhotos.count - 1) as! UIButton
        button.setImage(photo, forState: .Normal)

        self.setNeedsLayout()
    }

    func removeItemPhotoAtIndex(index: Int) {
        if index < self.itemPhotos.count {
            self.itemPhotos.removeObjectAtIndex(index)
        }

        for (buttonIndex, button) in enumerate(self.photoButtons) {
            if buttonIndex < self.itemPhotos.count {
                let image = self.itemPhotos[buttonIndex] as! UIImage
                button.setImage(image, forState: .Normal)
            } else {
                button.setImage(nil, forState: .Normal)
            }
        }
        self.setNeedsLayout()
    }

    func removeItemPhoto(photo: UIImage!) {
        let index = self.itemPhotos.indexOfObject(photo)
        if index != NSNotFound {
            self.removeItemPhotoAtIndex(index)
        }
    }

    func showInTableView(tableView: UITableView!) {
        self.setFrameWidth(tableView.bounds.width)

        let height = self.imageButtonSize * 2 + 13 * 3
        self.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        tableView.tableHeaderView = self

        self.setNeedsLayout()
    }
    
    func photoButtonTouchUpInsideHandler(sender: UIButton?) {
        if self.photoButtonDidTouchUpInsideBlock != nil {
            let index = self.photoButtons.indexOfObject(sender!)
            let photo = self.itemPhotos.objectAtIndex(index) as! UIImage
            self.photoButtonDidTouchUpInsideBlock!(photo: photo, index: index)
        }
    }
    
    func addButtonTouchUpInsideHandler(sender: UIButton?) {
        if self.addButtonDidTouchUpInsideBlock != nil {
            self.addButtonDidTouchUpInsideBlock!()
        }
    }
    
    func photoPanGestureRecognizedHandler(gr: UIPanGestureRecognizer?) {
        if gr?.state == .Began {
            draggingButton = gr?.view as? UIButton
            if draggingButton != nil {
                self.bringSubviewToFront(draggingButton!)
            }
        }
        
        if gr?.state == .Changed {
            let grButton = gr?.view as! UIButton
            let currentButtonIndex = self.photoButtons.indexOfObject(grButton)

            let translationPosition = gr?.translationInView(self)
            let frame = CGRect(x: grButton.frame.origin.x + translationPosition!.x,
                y: grButton.frame.origin.y + translationPosition!.y,
                width: grButton.frame.width, height: grButton.frame.height)

            if frame.maxY >= self.bounds.height || frame.maxY < 0 {
                gr?.enabled = false
                gr?.enabled = true
                return
            }

            grButton.setFrameOriginPoint(frame.origin)
            gr?.setTranslation(CGPointZero, inView: self)

            let panToButtonIndex = frame.origin.photoIndexForViewSize(self.bounds.size)

            if currentButtonIndex != panToButtonIndex && panToButtonIndex < self.itemPhotos.count {
                let photo = self.itemPhotos.objectAtIndex(currentButtonIndex) as! UIImage
                self.itemPhotos.removeObjectAtIndex(currentButtonIndex)
                self.itemPhotos.insertObject(photo, atIndex: panToButtonIndex)

                let photoButton = self.photoButtons.objectAtIndex(currentButtonIndex) as! UIButton
                self.photoButtons.removeObjectAtIndex(currentButtonIndex)
                self.photoButtons.insertObject(photoButton, atIndex: panToButtonIndex)

                self.setNeedsLayout()
                UIView.animateWithDuration(0.3,
                    delay: 0,
                    usingSpringWithDamping: 4,
                    initialSpringVelocity: 10,
                    options: .CurveEaseInOut,
                    animations: { () -> Void in
                        self.layoutIfNeeded()
                    }, completion: nil)
            }
        }

        if gr?.state == .Cancelled || gr?.state == .Ended || gr?.state == .Failed {
            self.draggingButton = nil
            self.setNeedsLayout()
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 4,
                initialSpringVelocity: 10,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addButton?.hidden = (self.itemPhotos.count >= 8)
        self.bringSubviewToFront(self.addButton!)

        for (index, photoButton) in enumerate(self.photoButtons) {
            let photoPosition = index.photoPosition
            
            let originY = (13 + photoPosition.y * (self.imageButtonSize + 13))
            let originX = (10 + photoPosition.x * (self.imageButtonSize + 7))
            
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
            self.photoButtons.addObject(button!)

            button?.addTarget(self, action: "photoButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
            
            let panGR = UIPanGestureRecognizer(target: self, action: "photoPanGestureRecognizedHandler:")
            panGR.maximumNumberOfTouches = 1
            panGR.delegate = self
            
            button?.addGestureRecognizer(panGR)
            
            self.addSubview(button!)
        }
        
        addButton = UIButton(frame: CGRectZero)
        self.addSubview(addButton!)
        
        addButton!.setImage(UIImage(named: "ItemAddImage"), forState: .Normal)
        addButton!.backgroundColor = UIColor(hex: 0x4A90E2)
        addButton!.addTarget(self, action: "addButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)

        let bottomSL = YASeparatorLine(frame: CGRectZero, lineColor: UIColor(hex: 0x000000, alpha: 0.2), lineWidth: 1)
        self.addSubview(bottomSL)
        bottomSL.mas_makeConstraints { (maker) -> Void in
            maker.bottom.equalTo()(self)
            maker.leading.equalTo()(self).offset()(10)
            maker.trailing.equalTo()(self).offset()(-0)
            maker.height.mas_equalTo()(0.5)
        }
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
    private class func photoImageButton() -> UIButton? {
        let button = UIButton(frame: CGRectZero)
        button.backgroundColor = UIColor(hex: 0xEEEEEE)
        return button
    }
}