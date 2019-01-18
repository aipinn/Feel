//: [Previous](previous)

import Foundation
import UIKit

var str = "Hello, playground"

//: [Next](next)

/*:
 ## 谓词和正则表达式
 
 [Apple 文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795)
 */

do{
    let regex = "[a-z]"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let ret = predicate.evaluate(with: "q")
}

/*:
 ## 1. Parser Basics(解析基础)
 %K: is a var arg substitution(替换) for a key path.
 %: is a var arg substitution for an object value—often a string, number, or date.
 */
do {

    let name = "firstname"
    let value = "Adam"
    let predicate = NSPredicate(format: "%K like %@", name, value)
    let pre = NSPredicate(format: "%K like '%@'", name, value)
}

/*:
 ## 2. Basic Comparisons(比较)
 * `=,==`
 * `>=, =>`
 * `<=, =<`
 * `>`
 * `<`
 * `!=,<>`
 */
//: * BETWEEN 左边的表达式介于或等于右边指定值之间
do {
    let arr = [1, 10]//true //[5,5]->true, [6, 10]->false
    let betweenpre = NSPredicate(format: "name BETWEEN %@", arr)
    let dic = ["name": 5]
    let between = betweenpre.evaluate(with: dic);
    
}

/*:
 ## 3. Boolean Value Preicates
 
 `TRUEPREDICATE`
 A predicate that always evaluates to TRUE.
 `FALSEPREDICATE`
 A predicate that always evaluates to FALSE.

 */


/*:
 ## 4. Basic Compound Predicates
 
 * AND, &&
    Logical AND.
 * OR, ||
    Logical OR.
 * NOT, !
    Logical NOT.

 */

/*:
 ## 5. String Comparisons
 默认情况下，字符串比较区分大小写和变音符号。可以使用方括号中的关键字符c和d修改操作符，以分别指定大小写和变音符号不敏感，例如:
 > `firstName以[cd] $FIRST_NAME`开头。
 
 * BEGINSWITH
 * CONTAINS
 * ENDSWITH
 * LIKE
    + The left hand expression equals the right-hand expression: ? and * are allowed as wildcard characters, where ? matches 1 character and * matches 0 or more characters.
 * MATCHES
 * UTI-CONFORMS-TO
 * UTI-EQUALS
 */

do {
    let start = "The"
    let string = "The world is virtual!"
    let pre = NSPredicate(format: "%@ BEGINSWITH %@", string, start)
    let startBool = pre.evaluate(with: nil)
}
/*:
 ## 6. Aggregate Operations(集合操作符)
 
 * ANY, SOME
    + For example ANY `children.age < 18`.
 * ALL
    +  For example ALL `children.age < 18`.
 * NONE
    + For example, `NONE children.age < 18`. This is logically equivalent to `NOT (ANY ...)`.
 * IN
    +
 */

do {
    let aCollection = ["allen", "peng", "pinn"]
    let preIN = NSPredicate(format: "attribute IN %@", aCollection)
    let dict = ["attribute": "pinn"]
    let ret = preIN.evaluate(with: dict)//true
}

/*:
 * array[index]
 * array[FIRST]
 * array[LAST]
 * array[SIZE]
 */

/*:
 ## 7. Identifiers
 
 * C style identifier
    Any C style identifier that is not a reserved word.
 * #symbol
    Used to escape a reserved word into a user identifier.
 * [\]{octaldigit}{3}
    Used to escape an octal number ( \ followed by 3 octal digits).
 * [\][xX]{hexdigit}{2}
    Used to escape a hex number ( \x or \X followed by 2 hex digits).
 * [\][uU]{hexdigit}{4}
    Used to escape a Unicode number ( \u or \U followed by 4 hex digits).

 */

/*:
 ## 8. Literals(字面量)
 * FALSE, NO
 * TRUE, YES
 * SELF
 * "text", A character string.
 * 'text', A character string.
 
 * 0x
 * 0o
 * 0b
 
 */


/*:
 # Usage
 */


//: Evaluating Predicates
do {
    let pre = NSPredicate(format: "SELF IN %@", ["String", "Shaffiq", "Chris"])
    let ret = pre.evaluate(with: "Sshaffiq")//大小写敏感.true

}

//: Using Predicates with Arrays(数组)
do {
    var names: NSMutableArray = ["nick", "Ben", "adam", "melissa", "bell"]//必须是OC对象
    let pre = NSPredicate(format: "SELF beginswith[c] 'b'")//[c]表示大小写不敏感
    
    //返回一个新的数组,可变不可变数组都可以
    let beginWithB = names.filtered(using: pre)//["Ben", "bell"]
    print(names)//
    
    //改变原来的数组,只能是可变对象
    let preE = NSPredicate(format: "self contains[c] 'e'")
    names.filter(using: preE)
    print(names)
}

//: Using Predicates with key-path

//: Using Null Values
do {
    let str = "Ben"
    let arr: NSArray = [["firstName": "Ben", "age": 12], ["lastName": "Kill"]]
    let pre = NSPredicate(format: "firstName like %@", str)
    let one = arr.filtered(using: pre)
}

//: Using Regular Expressions

do {
    let arr: NSArray = ["TATACCATGGGCCATCATCATCATCATCATCATCATCATCATCACAG",
    "CGGGATCCCTATCAAGGCACCTCTTCG", "CATGCCATGGATACCAACGAGTCCGAAC",
    "CAT", "CATCATCATGTCT", "DOG"]
    //CAT至少重复三次,但是后面没有跟随一个CA
    //.出换行以外的y任意字符
    //*重复零次或多次
    //{n,m},重复n到m次
    //()分组也叫子表达式
    //(?!exp)零宽断言,(?!CA)不是CA
    let pre = NSPredicate(format: "SELF MATCHES %@", ".*(CAT){3,}(?!CA).*")
    let some = arr.filtered(using: pre)
    
    // | 分支
    let isbnTestArray: NSArray = ["123456789X", "987654321x", "1234567890", "12345X", "1234567890"]
    //let preEarth = NSPredicate(format: "SELF MATCHES '\\\\d{10}|\\\\d{9}[xX]'")
    let preEarth = NSPredicate(format: "SELF MATCHES %@", "\\d{10}|\\d{9}[Xx]")

    let someEarth = isbnTestArray.filtered(using: preEarth)
}

//: Performance Considerations(性能考虑)
do {
    
    //1.
    let pre = NSPredicate(format: "(title matches .*mar[1-10]) OR (type = 1)")
    //更好的写法: 只有第一个表达式是false时才执行后面的条件
    let preBetter = NSPredicate(format: "(type = 1) OR (title matches .*mar[1-10])")
    
    //2.Using Joins,通常，连接(跨关系的查询)也是开销很大的操作，如果可以，应该避免使用它们。在测试一对一关系时，如果您已经(或者可以很容易地检索)关系源对象(或其对象ID)，那么测试对象是否相等要比测试源对象的属性更有效。而不是写如下:
    let preJoin = NSPredicate(format: "deparment.name like %@", department.name)
    //更加高效
    let preJoinBetter = NSPredicate(format: "deparment == %@", department)
    //If a predicate contains more than one expression, it is also typically more efficient to structure it to avoid joins. For example, @"firstName beginswith[cd] 'Matt' AND (ANY directreports.paygrade <= 7)" is likely to be more efficient than @"(ANY directreports.paygrade <= 7) AND (firstName beginswith[cd] 'Matt')" because the former avoids making a join unless the first test succeeds.
    

}
