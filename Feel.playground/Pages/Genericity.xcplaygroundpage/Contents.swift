import UIKit

var str = "Hello, Genericity"

// 泛型
// 把名字写在尖括号中来创建一个泛型方法或类型

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
   return result
}

makeArray(repeating: "Knock", numberOfTimes: 5)

// 你可以从函数 方法 类 枚举 结构体创建泛型
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}

var posdibleInteger: OptionalValue<Int> = .none
posdibleInteger = .some(100)

func anyCommonElements<T: Sequence, U: Sequence>(lhs: T, rhs: U) -> Bool
    where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    return true
                }
            }
        }
        return false
}

anyCommonElements(lhs: [1,2,3], rhs: [3])


func swapTwoValues<V>(a: inout V, b: inout V ){
    let temp = a
    a = b
    b = temp
}

var someone = 3
var someAnother = 5
swapTwoValues(a: &someone, b: &someAnother)
swap(&someone, &someAnother)
print(someAnother, someone)
