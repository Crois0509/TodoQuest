//
//  UIViewController+EXT.swift
//  TodoQuest
//
//  Created by 장상경 on 9/3/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidAppear: Observable<Void> {
        return self.base.rx.methodInvoked(#selector(Base.viewDidAppear))
            .map { _ in }
            .asObservable()
    }
}
