//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import UIKit

var str = "Hello, playground"

//: [Next](@next)

struct Person { // Model
    let firstName: String
    let lastName: String
}

protocol Greeting: class {
    func setGreeting(greeting: String)
}

protocol GreetingViewPresenter {
    init(view: Greeting, person: Person)
    func showGreeting()
}

class GreetingPresenter : GreetingViewPresenter {
    unowned let greet: Greeting
    let person: Person
    required init(greet: Greeting, person: Person) {
        self.greet = greet
        self.person = person
    }
    func showGreeting() {
        let greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
        self.greet.setGreeting(greeting: greeting)
    }
}

class GreetingViewController : UIViewController, Greeting {
    var presenter: GreetingViewPresenter!
    let showGreetingButton = UIButton()
    let greetingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.showGreetingButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ button: UIButton) {
        self.presenter.showGreeting()
    }
    
    func setGreeting(greeting: String) {
        self.greetingLabel.text = greeting
    }
    
    // layout code goes here
}
// Assembling of MVP
let model = Person(firstName: "David", lastName: "Blaine")
let view = GreetingViewController()
let presenter = GreetingPresenter(view: view, person: model)
//view.presenter = presenter



let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
window.backgroundColor = .white
window.rootViewController = view
window.makeKeyAndVisible()
PlaygroundPage.current.liveView = window

