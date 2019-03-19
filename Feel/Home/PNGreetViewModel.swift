//
//  PNGreetViewModel.swift
//  Feel
//
//  Created by pinn on 2019/3/19.
//  Copyright © 2019 PINN. All rights reserved.
//

import UIKit

protocol PNGreetViewModelProtocol: AnyObject {//: class
    var greeting: String? { get }
    var greetingDidChanged: ((PNGreetViewModelProtocol) -> ())? { set get }
    init(person: Person)
    func showGreeting()
}

class PNGreetViewModel: PNGreetViewModelProtocol {

    var person: Person?
    
    var greeting: String? {
        didSet {
            greetingDidChanged?(self)
        }
    }
    
    var greetingDidChanged: ((PNGreetViewModelProtocol) -> ())?
    
    required init(person: Person) {
        self.person = person
    }
    
    func showGreeting() {
        if let fn = person?.lastName, let ln = person?.lastName {
            self.greeting = "Hello " + fn + " " + ln + "!"
        }
       
    }
    
}
