//
//  ViewController.swift
//  MLButton
//
//  Created by Meilbn on 3/6/2020.
//  Copyright © 2020 Meilbn. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: Properties
    
    // MARK: UI
    
    private var homeButton: MLButton!
    
    private var button: UIButton!
    
    private var topButton: MLButton!
    private var leftButton: MLButton!
    private var bottomButton: MLButton!
    private var rightButton: MLButton!
    private var bigButton: MLButton!
    
    // MARK: Lifecycle
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        setupViews()
    }
    
    // MARK: Private Methods
    
    private func setupViews() {
        homeButton = MLButton(type: .system)
        homeButton.setImage(UIImage(named: "icon_arrow_down_15")?.withRenderingMode(.alwaysTemplate), for: .normal)
        homeButton.setTitle("My Home My Home My Home My Home My Home My Home My Home", for: .normal)
        homeButton.setTitleColor(UIColor(white: 51 / 255.0, alpha: 1.0), for: .normal)
        homeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        homeButton.titleLabel?.preferredMaxLayoutWidth = self.view.bounds.width - 25 * 2
        homeButton.titleLabel?.lineBreakMode = .byTruncatingTail
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        homeButton.tintColor = UIColor(white: 51 / 255.0, alpha: 1.0)
        homeButton.imagePosition = .right
        homeButton.preferredMaxLayoutWidth = self.view.bounds.width - 25 * 2
//        homeButton.addTarget(self, action: #selector(switchHomeAction), for: .touchUpInside)
//        homeButton.sizeToFit()
//        homeButton.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.screenWidth - 25 * 2).isActive = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeButton)
        
        button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        button.setImage(UIImage(named: "icon_praised"), for: .normal)
        button.setTitle("点赞", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1.0 / UIScreen.main.scale
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        topButton = MLButton()
        topButton.imagePosition = .top
        topButton.setImage(UIImage(named: "icon_praised"), for: .normal)
        topButton.setTitle("点赞", for: .normal)
        topButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(topButton)
        topButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).offset(-15)
        }

        leftButton = MLButton()
        leftButton.setImage(UIImage(named: "icon_praised"), for: .normal)
        leftButton.setTitle("点赞", for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(15)
            make.right.equalTo(button.snp.left).offset(-15)
        }

        bottomButton = MLButton()
        bottomButton.imagePosition = .bottom
        bottomButton.setImage(UIImage(named: "icon_praised"), for: .normal)
        bottomButton.setTitle("点赞", for: .normal)
        bottomButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(15)
        }

        rightButton = MLButton()
        rightButton.imagePosition = .right
        rightButton.setImage(UIImage(named: "icon_praised"), for: .normal)
        rightButton.setTitle("点赞", for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(button.snp.right).offset(15)
        }
        
        bigButton = MLButton()
        bigButton.imagePosition = .right
        bigButton.setImage(UIImage(named: "icon_praised"), for: .normal)
        bigButton.setTitle("点赞", for: .normal)
        bigButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(bigButton)
        bigButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(bottomButton.snp.bottom).offset(20)
        }
        
        bigButton.setBadgeValue("10", at: .imageTopRight)
        
        let frameButton = MLButton(frame: CGRect(x: 50, y: 50, width: 80, height: 80))
        frameButton.imagePosition = .right
        frameButton.setImage(UIImage(named: "icon_praised"), for: .normal)
        frameButton.setTitle("点赞", for: .normal)
        frameButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(frameButton)
    }
    
    // MARK: Actions
    
    



}

