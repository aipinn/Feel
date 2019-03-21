//
//  PNSayViewPresenter.swift
//  Feel
//
//  Created by emoji on 2019/3/20.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

protocol SayingView: AnyObject {
    func setSaying(saying: String)
}

protocol SayingPresenter {
    init(view: SayingView, say: Say)
    func saying()
}

class PNSayViewPresenter: SayingPresenter {
    unowned let view: SayingView
    let say: Say
    required init(view: SayingView, say: Say) {
        self.view = view
        self.say = say
    }
    
    func saying() {
        let saying = self.say.chinese + self.say.english
        self.view.setSaying(saying: saying)
    }

}
