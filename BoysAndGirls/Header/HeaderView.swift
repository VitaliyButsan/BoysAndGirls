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
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
            ])
        
        setupHeaderLabel()
    }
    
    private func setupHeaderLabel() {
        headerView.addSubview(labelView)
        
        NSLayoutConstraint.activate([
            labelView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
}
