//
//  ProgressView.swift
//  TodoQuest
//
//  Created by 장상경 on 8/6/25.
//

import UIKit

final class ProgressView: UIView {
    
    private let backgroundLayer = CapsuleLayer()
    private let progressLayer = CapsuleLayer()
    
    var state: Double = 0 {
        didSet {
            updateProgressSize()
        }
    }
    
    var progressColor: UIColor? {
        get { returnColor(progressLayer) }
        set { progressLayer.backgroundColor = newValue?.cgColor }
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 100, height: 50)
    }
    
    override var backgroundColor: UIColor? {
        get { returnColor(backgroundLayer) }
        set { backgroundLayer.backgroundColor = newValue?.cgColor }
    }
    
    init(_ bgColor: UIColor = .View.textField, _ progressColor: UIColor = .CustomColors.personal) {
        super.init(frame: .zero)
        backgroundLayer.backgroundColor = bgColor.cgColor
        progressLayer.backgroundColor = progressColor.cgColor
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer.frame = bounds
        updateProgressSize()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backgroundColor = .View.textField
    }
    
    private func updateProgressSize() {
        let rect = bounds.insetBy(dx: 3, dy: 3)
        let width = rect.width * state
        let size = CGSize(width: width, height: rect.height)
        
        progressLayer.frame = .init(x: rect.origin.x, y: rect.origin.y, width: size.width, height: size.height)
    }
    
    private func returnColor(_ layer: CALayer) -> UIColor? {
        guard let bgColor = layer.backgroundColor,
              let components = bgColor.components,
              components.count >= 3
        else { return nil }
        
        return UIColor(red: components[0],
                       green: components[1],
                       blue: components[2],
                       alpha: bgColor.alpha)
    }
}

private extension ProgressView {
    final class CapsuleLayer: CALayer {
        override func layoutSublayers() {
            super.layoutSublayers()
            cornerRadius = bounds.height * 0.5
        }
    }
}
