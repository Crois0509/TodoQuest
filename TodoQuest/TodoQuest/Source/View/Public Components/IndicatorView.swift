//
//  IndicatorView.swift
//  TodoQuest
//
//  Created by 장상경 on 9/4/25.
//

import UIKit

final class IndicatorView: UIActivityIndicatorView {
    
    init() {
        super.init(frame: .zero)
        self.style = .large
        self.color = .white
        self.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
