//: [Previous](@previous)

import Foundation

var str = "Hello, Swift_Practice2"

//: [Next](@next)

/*:
 ## Core Data
 
 @dynamic在OC中表示我们向编译器承诺会在运行时提供getter和setter方法的实现,不需要编译器做检测;
 当运行时如果检测不到对应实现就会崩溃;
 Swift中没有@dynamic关键字,因为swift并不保证一切都走动态派发,swift张总严格来说没有原来的@dynamic的完整替代品,但是swift中专门为CoreData加入了一个特定的标注来处理动态代码,即@NSManaged
 ........待续
 */

/*:
 ## 闭包歧义
 Swift中闭包的写法很多,最正规的应该是h将闭包的输入和输出都写上,然后用in关键字隔开参数和实现.
 eg:
 如果我们想实现一个int的extension,使其可以执行闭包若干次,并同时将次数传递到闭包中:
 */

extension Int {
    func times(f: (Int) -> ()) {
        for i in 1...self {
            f(i)
        }
    }
}

3.times { (i: Int) -> () in
    print(i)
}

//:这里的闭包接收int输入没有返回,这种情况下可以将这个闭包进行简化,成为下面这样:
3.times { i in
    print(i)
}

//: 只需要执行若干次
extension Int {
    func timenew (f: () -> Void) {
        for _ in 1...self {
            f()
        }
    }
    
}

//:Void的定义 public typealias Void = ()
3.timenew {
    print("666")
}

/*:
 ## 泛型扩展
 比如数组定义中已经声明了Element为泛型类型.为此类型添加扩展时就不需要再extension中重复去写<Element>这样的泛型类型名字(编译器也不允许),可以直接使用.
 */

extension Array {
    var random: Element? {
        return self.count != 0 ?
        self[Int(arc4random_uniform(UInt32(self.count)))] :
        nil
    }
}

let languages = ["swift", "oc", "c++", "java"]
print(languages.random)

let ranks = [1,2,4,5]
print(ranks.random)

//: 在扩展中是不能添加整个类型可用的新泛型符号的,但是对于特定的方法来说,可以添加其他泛型符号,eg:

extension Array {
    func appendRandomDescription<T: CustomStringConvertible>(_ input: T) -> String {
        if let element = self.random {
            return "\(element)" + input.description
        } else {
            return "empty array"
        }
    }
}
print("---------")
//: 我们添加了实现CustomStringConvertible协议的input参数,然后就可以使用description方法.
//随机组合languages和ranks各一个元素输出
print(languages.appendRandomDescription(ranks.random!))
print(ranks.appendRandomDescription(languages.random!))

/*:
 > 简单说就是我们不能通过扩展来重新定义当前已有的泛型符号，但是可以对其进行使用;在扩展中也不能为这个类型添加泛型符号;但只要名字不冲突，我们是可以在新声明的方法中定义和使用新的泛型符号的。
 */

/*:
 ## 兼容性
 */


/*:
 ## 列举enum类型
 */

enum Suit: String {
    case spades = "♠️"
    case hearts = "♥️"
    case clubs = "♣️"
    case diamonds = "♦️"
}

enum Rank: Int, CustomStringConvertible {
    case ace = 1
    case two,three,four,five,six,seven,eight,nine,ten
    case jack,queue,king
    var description: String {
        switch self {
        case .ace:
            return "A"
        case .jack:
            return "J"
        case .queue:
            return "Q"
        case .king:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
}

protocol EnumerableEnum {
    static var allValues: [Self] {get}
}

extension Suit: EnumerableEnum {
    static var allValues: [Suit] {
        return [.spades, .hearts, .clubs, .diamonds]
    }
}

extension Rank: EnumerableEnum {
    static var allValues: [Rank] {
        return [.ace, .two, .three, .four, .five, .six,
                .seven, .eight, .nine, .ten, .jack, .queue, .king]
    }
}

for suit in Suit.allValues {
    for rank in Rank.allValues {
        //print("\(suit.rawValue)\(rank)")
    }
}
print("🐒")
print("🐒")

/*:
 ## 尾递归
 */

func sum(_ n: UInt) -> UInt {
    if n == 0 {
        return 0
    }
    return n + sum(n - 1)
}

print(sum(5))


/*:
 但是当数很大时,就会产生错误.
 
 这是因为递归调用都需要在调用栈上保存当前状态,否则就无法计算最后的n+sum(n-1).当n足够大时,调用栈足够深
 ,就会导致栈空间被耗尽而产生栈溢出错误.
 
 解决的办法就是采用尾递归的写法.尾递归就是让函里的最后一个动作是一个函数调用的形式,这个调用的返回值将直
 接被当前函数返回,从而避免在栈上保存状态.
 */

func tailSum(_ n: UInt) -> UInt {
    func sumInternal(_ n:UInt, current: UInt) -> UInt {
        if n == 0 {
            return current
        } else {
            return sumInternal(n-1, current: current + n)
        }
    }
    return sumInternal(n, current: 0)
}

print(tailSum(1000))

/*:
 > 但是如果你在项目中直接尝试运行这段代码的话还是会报错，因为在Debug模式下Swift编译器
 并不会对尾递归进行优化。我们可以在scheme设置中将Run的配置从Debug改为Release,
 这段代码就能正确运行了。
 */
