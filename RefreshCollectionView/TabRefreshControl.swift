//
//  TabRefreshControl.swift
//  RefreshCollectionView
//
//  Created by i9400506 on 2021/3/18.
//  Copyright © 2021 i9400506. All rights reserved.
//

import UIKit

internal final class TabRefreshControl: UIRefreshControl {
    
    private lazy var titleLabel: UILabel = {
        return self.getLabel()
    }()
    
    private var pointlabels: [UILabel] = []
    
    private lazy var activity: UIActivityIndicatorView = {
        let actView = UIActivityIndicatorView()
        actView.hidesWhenStopped = false
        actView.startAnimating()
        actView.translatesAutoresizingMaskIntoConstraints = false
        return actView
    }()
    
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    }()
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private final func setup() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.createCustomUI()
        self.setupAnimation()
    }
    
    private final func createCustomUI() {
        self.addSubview(self.activity)
        
        self.titleLabel.text = "資料更新中"
        self.addSubview(self.titleLabel)
        
        for _ in 0..<3 {
            let label = self.getLabel()
            label.text = "."
            self.pointlabels.append(label)
            self.addSubview(label)
        }
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            self.activity.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activity.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -5),
            self.pointlabels[0].centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.pointlabels[0].leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.pointlabels[0].widthAnchor.constraint(equalToConstant: 10),
            
            self.pointlabels[1].centerYAnchor.constraint(equalTo: self.pointlabels[0].centerYAnchor),
            self.pointlabels[1].leadingAnchor.constraint(equalTo: self.pointlabels[0].trailingAnchor, constant: 5),
            self.pointlabels[1].widthAnchor.constraint(equalToConstant: 10),
            
            self.pointlabels[2].centerYAnchor.constraint(equalTo: self.pointlabels[1].centerYAnchor),
            self.pointlabels[2].leadingAnchor.constraint(equalTo: self.pointlabels[1].trailingAnchor, constant: 5),
            self.pointlabels[2].widthAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    private final func setupAnimation() {
        for row in pointlabels.enumerated() {
            animator.addAnimations({
                row.element.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/4))
            }, delayFactor: CGFloat(row.offset) * 1)
            animator.addAnimations({
                row.element.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/4))
            }, delayFactor: CGFloat(row.offset + 1) * 1.5)
        }
    }
    
    private final func getLabel() -> UILabel {
        let label = UILabel()
        label.tintColor = .black
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        self.animator.startAnimation()
    }
    
    override func endRefreshing() {
        self.animator.stopAnimation(true)
        super.endRefreshing()
    }
}
