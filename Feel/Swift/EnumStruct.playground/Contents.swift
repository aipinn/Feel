import UIKit

var str = "Hello, Enumeration and Extension"

/// 枚举
//  枚举可以包含方法

enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    func simpleDesc() -> String {
        switch self {
        case .ace:
            return "A"
        case .jack:
            return "J"
        case .queen:
            return "Q"
        case .king:
            return "K"
            
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
let aceRawVallue = ace.rawValue
ace.simpleDesc()
let queen = Rank.queen
queen.simpleDesc()

if let convertedRank = Rank(rawValue: 3) {
    print(convertedRank.simpleDesc())
}

enum Suit {//不指定原始类型
    case spades, hearts, diamonds, clubs
    func simpleDesc() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
    func color() -> String {
        switch self {
        case .diamonds, .hearts:
            return "red"
        case .spades, .clubs:
            return "black"
        }
    }
}

let hearts = Suit.hearts
let color = hearts.color()
let heartsDesc = hearts.simpleDesc()

/*
 如果枚举拥有原始值，这些值在声明时确定，就是说每一个这个枚举的实例都将拥有相同的原始值。另一个选择是让case与值关联——这些值在你初始化实例的时候确定，这样它们就可以在每个实例中不同了。比如说，考虑在服务器上请求日出和日落时间的case，服务器要么返回请求的信息，要么返回错误信息。
 */
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:00 pm")
let failure = ServerResponse.failure("Out of cheese")

switch success {
case let .result(sunrise, sunset):
    print("Sun \(sunrise) \(sunset)")
case let .failure(message):
    print("failure \(message)")

}

switch failure {
case .result:
    break
case .failure:
    break
}

let suc = ServerResponse.result("code", "0")
let fai = ServerResponse.failure("msg")

switch suc {
case .result:
    break
case .failure:
    break
}

/// 结构体 struct
//  结构体拥有很多与类相似的功能,包括方法与初始化器
//  重要的区别是: 结构体在传递的时候总是拷贝,而类则是传递引用

struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDesc() -> String {
        return "The \(rank.simpleDesc()) of \(suit.simpleDesc())"
    }
    
}

let threeOfSpades = Card(rank: .three, suit: .spades)
print(threeOfSpades.simpleDesc())
