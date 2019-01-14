//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, Objc_Swift_3"

//: [Next](@next)

/*:
 ## Associated Object
 
 swift中依然有效,只是写法有些不同.
 */
import ObjectiveC
class MyClass {
    
}

private var key: Void?
extension MyClass {
    var title: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
// 使用
func printTitle(_ input: MyClass) {
    if let title = input.title {
        print(title)
    } else {
        print("没有设置标题")
    }
}

let a = MyClass()
printTitle(a)
a.title = "aipinn.com"
printTitle(a)


/*:
 ## Lock
 
 无并发,不编码.
 OC中加锁的方式很多,@synchronized比较常用,这个关键字可以用来修饰一个变量,并未加上或者解除互斥锁.这样可以保证变量在作用范围内不会被其他线程改变.
 ```
 - (void)myMethod:(id)anObj {
    @synchronized(anObj) 大括号
        //在括号内持有anObj锁
    大括号
 }
 ```
 在swift中@synchronized已经不存在(或者是暂时)了了,其实@synchronized在幕后做的事情是调用了objc_sync中的objc_sync_enter和objc_sync_exit方法,并且加入了一些异常判断.因此如果忽略异常判断的话可以这样写:
 */

func myMethod(anObj: AnyObject) {
    objc_sync_enter(anObj)
    //在此之间持有anObj锁
    objc_sync_exit(anObj)
}

//: 更进一步,可以写一个全局的方法,接受一个闭包,来将objc_sync_enter和objc_sync_exit封装起来:

func synchronized(_ lock: AnyObject, closure: ()->()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
//: 再结合Swift的尾随闭包的特性,
func myMethodLocked(anObj: AnyObject) {
    synchronized(anObj) {
        //在括号内持有anObj锁
    }
}

class Obj {
    var _str = "123"
    var str: String {
        get {
            return _str
        }
        set {
            synchronized(self) {
                _str = newValue
            }
        }
    }
}
let oo = Obj()
oo.str
oo.str = "456"
oo.str

/*:
 ## Toll-Free Bridging 和 Unmmanaged
 
 OC中ARC负责的只是NSObject的自动引用计数,因此对于CF对象无法进行内存管理.我们在把对象在NS和CF之间进行转换时,需要向编译器
 说明是否需要转移内存的管理权.对于不设计内存管理转换的情况,OC中我们就直接加上__bridge进行说明,表示内存管理权不变.
 ```
 NSURL *fileURL = [NSURL URLWithString:@"someurl"];
 SystemSoundID theSoundID;
 OSStatus error = AudioServicesSystemSoundID((__bridge CFURLRef)fileURL, &theSound)
 ```
 
 而在swift中,这样的转换可以直接省掉了:
 */
import AudioToolbox

let fileURl = NSURL(string: "T##String")
var theSoundID: SystemSoundID = 0

//AudioServicesCreateSystemSoundID(<#T##inFileURL: CFURL##CFURL#>, <#T##outSystemSoundID: UnsafeMutablePointer<SystemSoundID>##UnsafeMutablePointer<SystemSoundID>#>)
AudioServicesCreateSystemSoundID(fileURl!, &theSoundID)
/*:
 可以注意到OC中类型名是CFURLRef,而Swift变成了CFURL. CFURL在swift中被typealiasf到CFURL上的,其实不仅仅是URL,其他
 CF类型都进行了类似的处理.这主要是减少API的迷惑:现在这些CF类型的行为更接近于ARC管理下的对象,因此去掉Ref更能变现出这一特性.
 
 CF现在也是ARC的管辖范围之内了.其背后的机制只不过是在合适的地方加上了像CF_RETURNS_RETAINED和CF_RETURNS_NOT_RETAINED这样的标注.
 
 另外,对于非系统的CF API(比如自己写的或第三方的),.....,如果没有明确的使用上面的标注来指明内存管理的方式的话,将这些返回
 CF对象的API导入Swift时,它们的类型会被对应为Unmanned<T>.
 
 这意味着在使用时我们需要手动进行内存管理,一般来说会使用得到的Unmanned对象的takeUnretainedValue或者takeRetainedValue从中取出需要的CF对象并同时处理引用计数.takeUnretainedValue将会保持原来的引用计数不变,在你
 明白你没有义务去释放原来的内存时,应该使用这个方法,如果你需要释放得到的CF的对象的内存时,应该使用takeRetainedValue来让引用计数加一,然后在使用完后对原来的Unmanned进行手动释放.为了能够手动操作Unmanned的引用计数,Unmanned中还提供了retain,release和autorelease供我们使用.
 这些API纯属虚构:
 ```
 //CFGetSomething() -> Unmanned<Something>
 //CFCreateSomething() -> Unmanned<Something>

 
 let unmanned = CFGetSomething()
 let something = unmanaged.takeUnretainedValue()
 //something的类型是something,直接使用就可以了
 
 
 let unmanned = CFCreateSomething()
 let something = unmanaged.takeRetainedValue()
 //使用 something
 
 //因为在取值时retain了,使用完成进行release
 unmanned.release()
 
 ```
 > 切记,这些是有在没有标注的极少数情况下才会用到,如果只调用系统的CF API,而不会去写自己的CF API的话,是没有必要关注这些的.
 */
