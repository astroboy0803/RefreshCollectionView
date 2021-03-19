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
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private final func setup() {
        self.removeNativeSubviews()
        self.createCustomUI()
    }
    
    private final func createCustomUI() {
        self.addSubview(self.activity)
        
        self.titleLabel.text = "資料更新中"
        self.addSubview(self.titleLabel)
        
        for _ in 0..<3 {
            let label = self.getLabel(size: 28)
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
            self.pointlabels[0].leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 10),
            self.pointlabels[0].widthAnchor.constraint(equalToConstant: 10),
            
            self.pointlabels[1].centerYAnchor.constraint(equalTo: self.pointlabels[0].centerYAnchor),
            self.pointlabels[1].leadingAnchor.constraint(equalTo: self.pointlabels[0].trailingAnchor, constant: 5),
            self.pointlabels[1].widthAnchor.constraint(equalToConstant: 10),
            
            self.pointlabels[2].centerYAnchor.constraint(equalTo: self.pointlabels[1].centerYAnchor),
            self.pointlabels[2].leadingAnchor.constraint(equalTo: self.pointlabels[1].trailingAnchor, constant: 5),
            self.pointlabels[2].widthAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    private final func getLabel(size: CGFloat = 20) -> UILabel {
        let label = UILabel()
        label.tintColor = .black
        label.font = .systemFont(ofSize: size)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        self.removeNativeSubviews()
        self.startAnimation()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        self.stopAnimation()
    }
    
    public final func updateTitle(title: String) {
        self.titleLabel.text = title
    }
    
    private final func removeNativeSubviews() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        for subview in self.subviews {
            if subview === self.activity {
                continue
            }
            if subview === self.titleLabel {
                continue
            }
            if self.pointlabels.contains(where: { $0 === subview }) {
                continue
            }
            subview.removeFromSuperview()
        }
    }
    
    private final func startAnimation() {
        
        let labelCount: Double = .init(self.pointlabels.count)
        let duration: Double = 0.2 * labelCount
        let keyConstant: Double = duration / labelCount
        UIView.animateKeyframes(withDuration: duration + keyConstant, delay: 0, options: [.repeat, .autoreverse]) {
            for row in self.pointlabels.enumerated() {
                let cgIdx = Double(row.offset)
                UIView.addKeyframe(withRelativeStartTime: cgIdx * keyConstant, relativeDuration: (cgIdx + 1) * keyConstant) {
                    row.element.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/4))
                }
            }
        } completion: { (_) in
        }
    }
    
    private final func stopAnimation() {
        self.pointlabels.forEach({
            $0.transform = .identity
            $0.layer.removeAllAnimations()
        })
    }
}
