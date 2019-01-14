//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

//: [Next](@next)

class PlayViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
    }
}

extension PlayViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension PlayViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

PlaygroundPage.current.liveView = PlayViewController()


/*:
 ## 泛型扩展

 Swift对泛型的支持使得我们可以避免为类似的功能多次书写重复的代码,这是一种很好的简化.对于泛型类型,我们也可以使用extension为泛型类型添加新的方法.
 与为普通的类型添加扩展不同的是,泛型类型在定义的时候就引入了类型标志,我们可以直接使用.
 例如:Array中的
 */
extension Array {
    var random: Element? {
        return self.count != 0 ?
        self[Int(arc4random_uniform(UInt32(self.count)))] : nil
    }
    func appendRandomDescription <U: CustomStringConvertible> (_ input: U) -> String {
        if let element = self.random {
            return "\(element)" + input.description
        } else {
            return "Empty array"
        }
    }
}

let lau = ["swift", "ObjC", "C++", "Java"]
lau.random!

let ranks = [1,2,3,4,5]
ranks.random!

/*:
 在扩展中是不能添加整个类型可用的新泛型符号的,但是对于某个特定的方法来说,我们可以添加T以外的t其他泛型符号.不如刚才的扩展中加上:appendRandomDescription:方法
 */

