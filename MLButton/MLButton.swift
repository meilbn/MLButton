//
//  MLButton.swift
//  MLButton
//
//  Created by Meilbn on 3/6/2020.
//  Copyright © 2020 Meilbn. All rights reserved.
//

import UIKit

/**
 *  图片视图的位置，默认为 left。
 *
 *  imageView's position, default is MLBOmniButtonImageViewPositionLeft.
 *
 *
 *  top:
 *
 *  -------------------
 *  |                 |
 *  |    imageView    |
 *  |                 |
 *  |    titleLabel   |
 *  |                 |
 *  -------------------
 *
 *  left：
 *
 *  ------------------------------
 *  |                            |
 *  |    imageView titleLabel    |
 *  |                            |
 *  ------------------------------
 *
 *  bottom:
 *
 *  -------------------
 *  |                 |
 *  |    titleLabel   |
 *  |                 |
 *  |    imageView    |
 *  |                 |
 *  -------------------
 *
 *  right：
 *
 *  ------------------------------
 *  |                            |
 *  |    titleLabel imageView    |
 *  |                            |
 *  ------------------------------
 *
 */

/**
 *  Edge Insets
 *
 *  -----------------------------------
 *  |                                 |
 *  |       Content Edge Insets       |
 *  |                                 |
 *  |    -------------------------    |
 *  |    |                       |    |
 *  |    |   Image Edge Insets   |    |
 *  |    |                       |    |
 *  |    |   -----------------   |    |
 *  |    |   |               |   |    |
 *  |    |   |               |   |    |
 *  |    |   |   imageView   |   |    |
 *  |    |   |               |   |    |
 *  |    |   |               |   |    |
 *  |    |   -----------------   |    |
 *  |    |                       |    |
 *  |    -------------------------    |
 *  |    -------------------------    |
 *  |    |                       |    |
 *  |    |   Title Edge Insets   |    |
 *  |    |                       |    |
 *  |    |   -----------------   |    |
 *  |    |   |               |   |    |
 *  |    |   |               |   |    |
 *  |    |   |   titleLabel  |   |    |
 *  |    |   |               |   |    |
 *  |    |   |               |   |    |
 *  |    |   -----------------   |    |
 *  |    |                       |    |
 *  |    -------------------------    |
 *  |                                 |
 *  |                                 |
 *  -----------------------------------
 *
 */

open class MLButton: UIButton {
    
    public enum ImagePosition {
        case top, left, bottom, right
        
        var stringValue: String {
            switch self {
            case .top:
                return "Top"
            case .left:
                return "Left"
            case .bottom:
                return "Bottom"
            case .right:
                return "Right"
            }
        }
    }
    
    public enum BadgePosition {
        // with Label
        case labelTopLeft, labelTopRight, labelBottomLeft, labelBottomRight
        // with ImageView
        case imageTopLeft, imageTopRight, imageBottomLeft, imageBottomRight
        // with Content
        case contentTopLeft, contentTopRight, contentBottomLeft, contentBottomRight
    }

    // MARK: Properties
    
    public var imagePosition: ImagePosition = .left {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var imageFixedSize: CGSize = .zero { // zero means no restrict
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var badgePosition: BadgePosition = .contentTopRight {
        didSet {
            if nil != badgeView {
                self.setNeedsLayout()
            }
        }
    }
    
    private var currentContentSize: CGSize = .zero
    
    // MARK: UI
    
    private(set) var badgeView: MLBadgeView?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage?, title: String?) {
        self.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.setTitle(title, for: .normal)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        calculate()
    }
    
    private func calculate() {
        // ImageView
        var imageViewSize: CGSize = .zero
        if .zero != imageFixedSize {
            imageViewSize = imageFixedSize
        } else {
            imageViewSize = self.currentImage?.size ?? .zero
        }
        
        // Title
        var titleSize: CGSize = .zero
        if let titleFitSize = self.titleLabel?.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)) {
            titleSize = titleFitSize.ceiled
        }
        
        // Content Size
        var contentSize: CGSize = .zero
        switch imagePosition {
        case .top, .bottom:
            contentSize.width += self.contentEdgeInsets.left
            contentSize.height += self.contentEdgeInsets.top
            if nil != self.imageView && nil != self.titleLabel {
                contentSize.width += max(self.imageEdgeInsets.left + imageViewSize.width + self.imageEdgeInsets.right, self.titleEdgeInsets.left + titleSize.width + self.titleEdgeInsets.right)
                contentSize.height += self.imageEdgeInsets.top + imageViewSize.height + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top + titleSize.height + self.titleEdgeInsets.bottom
            } else if nil != self.imageView {
                contentSize.width += self.imageEdgeInsets.left + imageViewSize.width + self.imageEdgeInsets.right
                contentSize.height += self.imageEdgeInsets.top + imageViewSize.height + self.imageEdgeInsets.bottom
            } else if nil != self.titleLabel {
                contentSize.width += self.titleEdgeInsets.left + titleSize.width + self.titleEdgeInsets.right
                contentSize.height += self.titleEdgeInsets.top + titleSize.height + self.titleEdgeInsets.bottom
            }
            contentSize.width += self.contentEdgeInsets.right
            contentSize.height += self.contentEdgeInsets.bottom
        case .left, .right:
            contentSize.width += self.contentEdgeInsets.left
            contentSize.height += self.contentEdgeInsets.top
            if nil != self.imageView && nil != self.titleLabel {
                contentSize.width += self.imageEdgeInsets.left + imageViewSize.width + self.imageEdgeInsets.right + self.titleEdgeInsets.left + titleSize.width + self.titleEdgeInsets.right
                contentSize.height += max(self.imageEdgeInsets.top + imageViewSize.height + self.imageEdgeInsets.bottom, self.titleEdgeInsets.top + titleSize.height + self.titleEdgeInsets.bottom)
            } else if nil != self.imageView {
                contentSize.width += self.imageEdgeInsets.left + imageViewSize.width + self.imageEdgeInsets.right
                contentSize.height += self.imageEdgeInsets.top + imageViewSize.height + self.imageEdgeInsets.bottom
            } else if nil != self.titleLabel {
                contentSize.width += self.titleEdgeInsets.left + titleSize.width + self.titleEdgeInsets.right
                contentSize.height += self.titleEdgeInsets.top + titleSize.height + self.titleEdgeInsets.bottom
            }
            contentSize.width += self.contentEdgeInsets.right
            contentSize.height += self.contentEdgeInsets.bottom
        }
        
        debugPrint("self.bounds.size = \(self.bounds.size), contentSize = \(contentSize), position = \(imagePosition.stringValue)")
        
        // Layout
        switch imagePosition {
        case .top:
            self.imageView?.frame = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + self.imageEdgeInsets.left, y: self.contentEdgeInsets.top + self.imageEdgeInsets.top), size: imageViewSize)
            var titleTop: CGFloat = 0
            if let iv = self.imageView {
                titleTop += iv.frame.maxY + self.imageEdgeInsets.bottom
            } else {
                titleTop += self.contentEdgeInsets.top
            }
            self.titleLabel?.frame = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + self.titleEdgeInsets.left, y: titleTop + self.titleEdgeInsets.top), size: titleSize)
        case .left:
            self.imageView?.frame = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + self.imageEdgeInsets.left, y: self.contentEdgeInsets.top + self.imageEdgeInsets.top), size: imageViewSize)
            var titleLeft: CGFloat = 0
            if let iv = self.imageView {
                titleLeft += iv.frame.maxX + self.imageEdgeInsets.right
            } else {
                titleLeft += self.contentEdgeInsets.left
            }
            self.titleLabel?.frame = CGRect(origin: CGPoint(x: titleLeft + self.titleEdgeInsets.left, y: self.contentEdgeInsets.top + self.titleEdgeInsets.top), size: titleSize)
        case .bottom:
            self.titleLabel?.frame = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + self.titleEdgeInsets.left, y: self.contentEdgeInsets.top + self.titleEdgeInsets.top), size: titleSize)
            var imageTop: CGFloat = 0
            if let l = self.titleLabel {
                imageTop += l.frame.maxY + self.titleEdgeInsets.bottom
            } else {
                imageTop += self.contentEdgeInsets.top
            }
            self.imageView?.frame = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + self.imageEdgeInsets.left, y: imageTop + self.imageEdgeInsets.top), size: imageViewSize)
        case .right:
            self.titleLabel?.frame = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + self.titleEdgeInsets.left, y: self.contentEdgeInsets.top + self.titleEdgeInsets.top), size: titleSize)
            var imageLeft: CGFloat = 0
            if let l = self.titleLabel {
                imageLeft += l.frame.maxX + self.titleEdgeInsets.right
            } else {
                imageLeft += self.contentEdgeInsets.left
            }
            self.imageView?.frame = CGRect(origin: CGPoint(x: imageLeft + self.imageEdgeInsets.left, y: self.contentEdgeInsets.top + self.imageEdgeInsets.top), size: imageViewSize)
        }
        
        switch imagePosition {
        case .top, .bottom:
            switch self.contentHorizontalAlignment {
            case .left, .leading: break
            case .right, .trailing:
                if imageViewSize.width > titleSize.width {
                    if var frame = self.titleLabel?.frame {
                        frame.origin.x = contentSize.width - self.contentEdgeInsets.right - self.titleEdgeInsets.right - titleSize.width
                        self.titleLabel?.frame = frame
                    }
                } else {
                    if var frame = self.imageView?.frame {
                        frame.origin.x = contentSize.width - self.contentEdgeInsets.right - self.imageEdgeInsets.right - imageViewSize.width
                        self.imageView?.frame = frame
                    }
                }
            case .center:
                if imageViewSize.width > titleSize.width {
                    if var frame = self.titleLabel?.frame {
                        frame.origin.x = (contentSize.width - titleSize.width) / 2.0
                        self.titleLabel?.frame = frame
                    }
                } else {
                    if var frame = self.imageView?.frame {
                        frame.origin.x = (contentSize.width - imageViewSize.width) / 2.0
                        self.imageView?.frame = frame
                    }
                }
            case .fill:
                let maxWidth = max(imageViewSize.width, titleSize.width)
                if imageViewSize.width > titleSize.width {
                    if var frame = self.titleLabel?.frame {
                        frame.size.width = maxWidth
                        self.titleLabel?.frame = frame
                    }
                } else {
                    if var frame = self.imageView?.frame {
                        frame.size.width = maxWidth
                        self.imageView?.frame = frame
                    }
                }
            default: break
            }
            
        case .left, .right:
            switch self.contentVerticalAlignment {
            case .top: break
            case .center:
                if imageViewSize.height > titleSize.height {
                    let diff = imageViewSize.height - titleSize.height
                    if var frame = self.titleLabel?.frame {
                        frame.origin.y += diff / 2.0
                        self.titleLabel?.frame = frame
                    }
                } else {
                    let diff = titleSize.height - imageViewSize.height
                    if var frame = self.imageView?.frame {
                        frame.origin.y += diff / 2.0
                        self.imageView?.frame = frame
                    }
                }
            case .bottom:
                if imageViewSize.height > titleSize.height {
                    let diff = imageViewSize.height - titleSize.height
                    if var frame = self.titleLabel?.frame {
                        frame.origin.y += diff
                        self.titleLabel?.frame = frame
                    }
                } else {
                    let diff = titleSize.height - imageViewSize.height
                    if var frame = self.imageView?.frame {
                        frame.origin.y += diff
                        self.imageView?.frame = frame
                    }
                }
            case .fill:
                if imageViewSize.height > titleSize.height {
                    let diff = imageViewSize.height - titleSize.height
                    if var frame = self.titleLabel?.frame {
                        frame.size.height += diff
                        self.titleLabel?.frame = frame
                    }
                } else {
                    let diff = titleSize.height - imageViewSize.height
                    if var frame = self.imageView?.frame {
                        frame.size.height += diff
                        self.imageView?.frame = frame
                    }
                }
            default: break
            }
        }
        
        // Horizontal
        switch self.contentHorizontalAlignment {
        case .left, .leading: break
        case .right, .trailing:
             break
        case .center:
            if self.frame.width > contentSize.width {
                let diff = self.frame.width - contentSize.width
                if var frame = self.imageView?.frame {
                    frame.origin.x += diff / 2.0
                    self.imageView?.frame = frame
                }
                if var frame = self.titleLabel?.frame {
                    frame.origin.x += diff / 2.0
                    self.titleLabel?.frame = frame
                }
            }
        case .fill:
             break
        default: break
        }
        
        // Vertical
        switch self.contentVerticalAlignment {
        case .top: break
        case .center:
            if self.frame.height > contentSize.height {
                let diff = self.frame.height - contentSize.height
                if var frame = self.imageView?.frame {
                    frame.origin.y += diff / 2.0
                    self.imageView?.frame = frame
                }
                if var frame = self.titleLabel?.frame {
                    frame.origin.y += diff / 2.0
                    self.titleLabel?.frame = frame
                }
            }
        case .bottom: break
        case .fill: break
        default: break
        }
        
        // BadgeView
        if let badgeView = self.badgeView {
            badgeView.setNeedsLayout()
            badgeView.layoutIfNeeded()
            
            self.bringSubviewToFront(badgeView)
            
            var badgeCenter: CGPoint = .zero
            
            switch badgePosition {
            case .labelTopLeft:
                badgeCenter = self.titleLabel?.frame.origin ?? .zero
            case .labelTopRight:
                badgeCenter = CGPoint(x: self.titleLabel?.frame.maxX ?? 0, y: self.titleLabel?.frame.minY ?? 0)
            case .labelBottomLeft:
                badgeCenter = CGPoint(x: self.titleLabel?.frame.minX ?? 0, y: self.titleLabel?.frame.maxY ?? 0)
            case .labelBottomRight:
                badgeCenter = CGPoint(x: self.titleLabel?.frame.maxX ?? 0, y: self.titleLabel?.frame.maxY ?? 0)
                
            case .imageTopLeft:
                badgeCenter = self.imageView?.frame.origin ?? .zero
            case .imageTopRight:
                badgeCenter = CGPoint(x: self.imageView?.frame.maxX ?? 0, y: self.imageView?.frame.minY ?? 0)
            case .imageBottomLeft:
                badgeCenter = CGPoint(x: self.imageView?.frame.minX ?? 0, y: self.imageView?.frame.maxY ?? 0)
            case .imageBottomRight:
                badgeCenter = CGPoint(x: self.imageView?.frame.maxX ?? 0, y: self.imageView?.frame.maxY ?? 0)
                
            case .contentTopLeft:
                badgeCenter = CGPoint(x: badgeView.frame.width / 2.0, y: badgeView.frame.height / 2.0)
            case .contentTopRight:
                badgeCenter = CGPoint(x: self.bounds.width - badgeView.frame.width / 2.0, y: badgeView.frame.height / 2.0)
            case .contentBottomLeft:
                badgeCenter = CGPoint(x: badgeView.frame.width / 2.0, y: self.bounds.height - badgeView.frame.height / 2.0)
            case .contentBottomRight:
                badgeCenter = CGPoint(x: self.bounds.width - badgeView.frame.width / 2.0, y: self.bounds.height - badgeView.frame.height / 2.0)
            }
            
            // Edge Cases
            switch badgePosition {
            case .labelTopLeft, .labelBottomLeft, .imageTopLeft, .imageBottomLeft:
                let beyondX = badgeCenter.x - badgeView.frame.width / 2.0
                if beyondX < 0 {
                    badgeCenter.x += abs(beyondX)
                }
            case .labelTopRight, .labelBottomRight, .imageTopRight, .imageBottomRight:
                let beyondX = badgeCenter.x + badgeView.frame.width / 2.0 - self.frame.width
                if beyondX > 0 {
                    badgeCenter.x -= beyondX
                }
            default: break
            }
            
            switch badgePosition {
            case .labelTopLeft, .labelTopRight, .imageTopLeft, .imageTopRight:
                let beyondY = badgeCenter.y - badgeView.frame.height / 2.0
                if beyondY < 0 {
                    badgeCenter.y += abs(beyondY)
                }
            case .labelBottomLeft, .labelBottomRight, .imageBottomLeft, .imageBottomRight:
                let beyondY = badgeCenter.y + badgeView.frame.height / 2.0 - self.frame.height
                if beyondY > 0 {
                    badgeCenter.y -= beyondY
                }
            default: break
            }
            
            badgeView.center = badgeCenter
        }
        
        currentContentSize = contentSize
        
        invalidateIntrinsicContentSize()
    }
    
    // MARK: Private Methods
    
    private func _setup() {
        
    }
    
    // MARK: Public Methods
    
    public func setBadgeValue(_ badge: String?, at position: BadgePosition) {
        if nil == badge || "" == badge {
            badgeView?.removeFromSuperview()
            badgeView = nil
        } else {
            if nil == badgeView {
                badgeView = MLBadgeView()
                self.addSubview(badgeView!)
            }
            
            badgeView?.value = badge
        }
        
        badgePosition = position
    }
    
    // MARK: Parent Methods
    
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        self.setNeedsLayout()
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.setNeedsLayout()
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        debugPrint("MLButton super intrinsicContentSize = \(size), currentContentSize = \(currentContentSize)")
        if .zero != currentContentSize {
            return currentContentSize
        }
        return size
    }

}

extension CGSize {
    
    fileprivate var ceiled: CGSize {
        return CGSize(width: ceil(self.width), height: ceil(self.height))
    }
    
    fileprivate func addEdgeInsets(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: insets.left + self.width + insets.right, height: insets.top + self.height + insets.bottom)
    }
    
    fileprivate func subtractEdgeInsets(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: self.width - insets.left - insets.right, height: self.height - insets.top - insets.bottom)
    }
    
}
