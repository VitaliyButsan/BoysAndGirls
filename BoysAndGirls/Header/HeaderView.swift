//
//  HeaderView.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 10.12.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
        
    static let reuseId: String = "reuseID"
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Copperplate", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHeaderView() {
        addSubview(headerView)
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
            self.headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            self.headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            self.headerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
            ])
        
        self.setupHeaderLabel()
    }
    
    private func setupHeaderLabel() {
        headerView.addSubview(labelView)
        
        NSLayoutConstraint.activate([
            self.labelView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.labelView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
}
