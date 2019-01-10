//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, swift_practice_1"

//: [Next](@next)

/*:
 ## Playground 延时运行
 
 playground提供一个顺序执行的环境,每次更改代码后都会被重新编译,并清空原来的状态并运行.
 
 * 对于异步代码执行,比如这样的NSTimer在默认的Playground中是不会执行的:
 */

class MyClass {
    @objc func callMe() {
        print("Hi")
    }
}
let obj = MyClass()

//Timer.scheduledTimer(timeInterval: 1.0,
//                     target: obj,
//                     selector: #selector(MyClass.callMe),
//                     userInfo: nil,
//                     repeats: true)
//PlaygroundPage.current.needsIndefiniteExecution = true //此句暂时可以省略
//: 在执行完Timer语句后,整个Playground将停止掉,HI永远不会输出.
/*:
 * 为了使playground具有延时运行的功能,需要引入"扩展包"-`PlaygroundSupport`框架.
 */

let url = URL(string: "http://httpbin.org/get")!
let getTask = URLSession.shared.dataTask(with: url) {
    (data, response, error) in
    let dict = try! JSONSerialization.jsonObject(with: data!, options: [])
    print(dict)
}
getTask.resume()
//: 即使开启了异步,默认情况下playground会在最后一行代码执行完成后30s停止.Alt+cmd+回车 可以打开辅助编辑器修改这个默认时间

/*:
 ## Playground与项目协作
 */


/*:
 ## Playground的可视化开发
 */

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
label.backgroundColor = .red
label.font = UIFont.systemFont(ofSize: 20)
label.textAlignment = .center
label.text = "Playground"
//PlaygroundPage.current.liveView = label


class ViewCOntroller: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}

extension ViewCOntroller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}

extension ViewCOntroller {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select: \(indexPath.row)")
    }
}

let vc = ViewCOntroller()
PlaygroundPage.current.liveView = vc


/*:
 ## 数学和数字
 */

func circlePerimeter(radious: Double) -> Double {
    return 2 * Double.pi * radious
}

func yPosition(dy: Double, angle: Double) -> Double {
    return dy * tan(angle)
}

/*:
 Swift除了导入了math.h的内容以外,也在标准库中对极限的数字做了一些约定,比如使用`Int.max`和`Int.min`来获取对应平台的Int值的最大和最小值.另外Double中有两个特殊的值
 * infinity表示无穷,类似1.0/0.0,但是仅限于当前平台的CPU.
 * NaN,他是"Not a Number"的简写.可以用来表示未定义的或者出现了错误的运算:
 */

let a = 0.0/0.0
let b = sqrt(-1.0)
let c = 0.0 * Double.infinity
//都是输出nan, 与nan再进行运算的结果也是NaN. 可以直接获取一个NaN
let d = Double.nan

let num = Double.nan
if num == num {//0
    print("Num is \(num)")
} else {
    print("NaN")
}
//: 用自身是否与自己相等就可以判断是不是NaN了
//: 另一个更简洁的方式是:
let num0 = Double.nan
if num.isNaN {
    print("NaN")
}

/*:
 ## JSON和Codeable
 
 Swift4之前比较麻烦:
 */

let jsonString = """
{"menu":{"id":"file","value":"File","popup":{"menuitem":[{"value":"New","onclick":"CreateNewDoc()"}]}}}
"""
let json: Any = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8, allowLossyConversion: true)!, options: [])

if let JsonDic = json as? NSDictionary {
    if let menu = JsonDic["menu"] as? [String: Any] {
        if let popup: Any = menu["popup"] {
            if let popupDic = popup as? [String: Any] {
                if let menuItems: Any = popupDic["menuitem"] {
                    if let menuItemsArr = menuItems as? [Any] {
                        if let item0 = menuItemsArr[0] as? [String: Any] {
                            if let value: Any = item0["value"] {
                                print(value)//输出New
                            }
                        }
                    }
                }
            }
        }
    }
}

//: 操....

//: swift4中加入了Codeable协议,用来处理数据的序列化和反序列化.利用内置的JSONEncoder和JSONDecoder,在对象实例和JSON之间进行转化变得非常简单.要处理上面的JSON,我们可以创建一系列对应的类型,并声明他们实现Codable:

struct Obj: Codable {
    let menu: Menu
    struct Menu: Codable {
        let id: String
        let value: String
        let popup: Popup
    }
    struct Popup: Codable {
        let menuItem: [MenuItem]
        enum CodingKeys: String, CodingKey {
            case menuItem = "menuitem"
        }
    }
    struct MenuItem: Codable {
        let value: String
        let onClick: String
        
        enum CodingKeys: String, CodingKey {
            case value
            case onClick = "onclick"
        }
    }
}

/*:
  只要一个类型中所有的成员都实现了Codable,那么这个类型也就可以自动满足Codable的要求.在Swift标准库中,像是String,Int,Double,Date,URL这样的类型默认就实现了Codable的,因此我们可以的基于这些常见类型构建更复杂的Codable类型.
 
 另外,如果JSON中的key和类型中的变量名不一致的话,我们还需要在对应类中声明CodingKeys枚举,并用合适的键值覆盖对应的默认值,上面的Popup和MenuItem都属于这种情况.
 
 
 */

let data = jsonString.data(using: .utf8)!
do {
    let obj = try JSONDecoder().decode(Obj.self, from: data)
    let value = obj.menu.popup.menuItem[0].value
    print(value)
} catch {
    //此处自有error
    print("出错了:\(error)")
}


/*:
 ## NSNull
`NSNull`出厂最多的时候就是在JSON解析了.
 
 OC中,对nil发送消息不会有任何问题;如果json中存在null时,其对应NSNull,对NSNull发送消息会崩溃.
 可以对NSNull添加分类,让它响应各种常见的方法,并返回默认值.但是难免会有疏漏
 
 swift中,这个问题被彻底解决了. 因为swift强调类型安全,无论怎么说都要一层转换.因此除非我们犯二不去将AnyObject转换为我们需要的类型,否则我们绝对不会错误的向一个NSNull发送消息.NSNull会默默地被通过Optional Binding被转换为nil,从而避免执行:
 */

let jsonValue: AnyObject = NSNull()
if let string = jsonValue as? String {
    print(string.hasPrefix("a"))
} else {
    print("不能解析")
}

/*:
 ## 性能考虑
 
 建立虚函数表.
 inline
 */

/*:
 ## Log
 
 符号         类型     描述
 #file      String  包含这个符号的文件的路径
 #line      Int     符号出现处的行号
 #column    Int     符号出现处的列号
 #function  String  方法名字
 */

func printing<T>(_ message: T,
                      file: String = #file,
                    method: String = #function,
                      line: Int = #line)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)],\(method): \(message)")
    #endif
}

func methoddddd() {
    printing("这是输出内容")
}

methoddddd()

/*:
 ## 溢出
 */

//: 编译不过自动报错
//Int.max + 1

/*:
 可选择溢出自动高位截断:
 * 溢出加法(&+)
 * 溢出减法(&-)
 * 溢出乘法(&*)
 * 溢出除法(&/)
 * 溢出求模(&%)
 
 这样的处理结果是:
 */

var max = Int.max
max = max &+ 1
print(max, Int.max)
//-9223372036854775808 9223372036854775807

/*:
 ## 宏定义define
 
 swift中没有宏了.....
 苹果给出了替代建议:
 * 使用合适范围的let或者get属性来替代原来的宏定义值,例如很多Darwin中的C的define值就是这么做的:
 `var M_PI = Double { get }`
 
 * 对于宏定义,类似地还有:
 
 ```
 #define NSLocalizedString(key, comment) \
 [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
 ```
 
 
 ```
 public func NSLocalizedString(_ key: String,
 tableName: String? = default,
 bundle: Bundle = default,
 value: String = default,
 comment: String) -> String
 ```
 
 * 随着#define的消失,#ifdef这样通过宏定义是否来进行条件判断并决定某些事情的方式也消失了.可以使用#if来处理
 */


/*:
 ## 属性访问控制
 
 Swift中由低至高提供了private, fileprivate, interval, public, open五种访问控制权限.默认的internal在绝大多数是适用的.
 * private让代码只能在当前作用域或者同一类型的作用域中被使用
 * fileprivate表示代码可以在当前文件中被访问,而不做类型限制,例如以下代码是合法的:
 */

//File1.swift
class Foo {
    private let privateBtn = UIButton()
    fileprivate let fileprivateBtn = UIButton()
}

class Baz {
    func baz() {
        print(Foo().fileprivateBtn)
        
    }
}

extension Foo {
    func fooExtension() {
        print(privateBtn)
        print(Foo().fileprivateBtn)
    }
}

class Tool: Foo {
    func subFoo() {
        print(fileprivateBtn)
        //print(privateBtn)
    }
}

//: 但是将Baz和extension Foo的部分移动到别的文件的话,就无法编译了.
/*:
 public与open的区别:
    只有被open标记的内容才能在别的框架中被继承或者重写.
    如果只希望框架的用户使用某个类型或者方法,而不希望他们继承或重写的话使用public
 */

//:>移步One.swift Two.swift查看


