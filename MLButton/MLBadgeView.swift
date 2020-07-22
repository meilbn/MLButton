//
//  MLBadgeView.swift
//  MLButton
//
//  Created by Meilbn on 3/6/2020.
//  Copyright © 2020 Meilbn. All rights reserved.
//

import UIKit

open class MLBadgeView: UIView {

    // MARK: Properties
    
    public var badgeBackgroundColor = UIColor(red: 1.0, green: 56 / 255.0, blue: 36 / 255.0, alpha: 1.0) {
        didSet {
            shapeLayer.fillColor = badgeBackgroundColor.cgColor
        }
    }
    
    public var badgeBorderColor: UIColor = .white {
        didSet {
            shapeLayer.strokeColor = badgeBorderColor.cgColor
        }
    }
    
    public var badgeBorderWidth: CGFloat = 0.0 {
        didSet {
            shapeLayer.lineWidth = badgeBorderWidth
        }
    }
    
    public var value: String? = nil {
        didSet {
            badgeLabel.text = value
            badgeLabel.isHidden = nil == value || "" == value
            self.setNeedsLayout()
        }
    }
    
    public var textColor: UIColor = .white {
        didSet {
            badgeLabel.textColor = textColor
        }
    }
    
    public var font = UIFont.systemFont(ofSize: 13) {
        didSet {
            badgeLabel.font = font
        }
    }
    
    public var maxWidth: CGFloat = 0 { // less than or equals to 0 means no restrict
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: UI
    
    private var shapeLayer: CAShapeLayer!
    
    private var badgeLabel: UILabel!
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        badgeLabel.sizeToFit()
        var textSize = badgeLabel.bounds.size
        textSize = CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        let height = textSize.height + 2
        let width = max(textSize.width + 5 * 2, height)
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: maxWidth > 0 ? min(width, maxWidth) : width, height: height))
        badgeLabel.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        shapeLayer.frame = self.bounds
        redrawShape()
    }
    
    // MARK: Private Methods
    
    private func setupViews() {
        self.isUserInteractionEnabled = false
        
        shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.lineWidth = badgeBorderWidth
        shapeLayer.fillColor = badgeBackgroundColor.cgColor
        shapeLayer.strokeColor = badgeBorderColor.cgColor
        self.layer.addSublayer(shapeLayer)
        
        badgeLabel = UILabel()
        badgeLabel.textColor = textColor
        badgeLabel.font = font
        badgeLabel.textAlignment = .center
        self.addSubview(badgeLabel)
    }
    
    private func redrawShape() {
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2.0).cgPath
    }

}

//class MLBadgeBackground: UIView {
//
//    // MARK: Properties
//
//
//
//    // MARK: UI
//
//
//
//    // MARK: Lifecycle
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: Private Methods
//
//    private func setupViews() {
//        self.isUserInteractionEnabled = false
//    }
//
//    // MARK: Actions
//
//
//
//
//}
