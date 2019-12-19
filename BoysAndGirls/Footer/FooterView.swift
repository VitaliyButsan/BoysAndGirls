//
//  FooterView.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 19.12.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
        
    static let reuseId: String = "footer_view"
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpFooterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpFooterView() {
        self.addSubview(footerView)
        
        NSLayoutConstraint.activate([
            self.footerView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
            self.footerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            self.footerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            self.footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
            ])
    }
}
