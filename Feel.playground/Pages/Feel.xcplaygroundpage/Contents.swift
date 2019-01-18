//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)


/*:
 ## 正则
 **元字符**
 * `.`匹配换行符以外的任意字符
 * `^`匹配开头
 * `$`匹配结尾
 
 **重复**
 * `?`重复零次或一次
 * `*`重复零次或多次,包括一次
 * `+`重复一次或多次
 
**零宽断言**
 * `(?=exp)`,匹配exp前面的部分;也叫零宽度正预测先行断言,它断言自身出现的位置的后面能匹配表达式exp.
 > 例如:`\b\w+(?=ing\b)`匹配以ing结尾的单词的前面部分(除了ing以外的部分),如:I'm singing while you are dancing,
 它会匹配sing和danc
 
 * `(?<=exp)`匹配exp后面的位置,也叫零宽度正回顾后发断言,它断言自身出现的位置的后前面能匹配表达式exp.
 > 例如:`(?<=\bre)\w+\b`匹配以re开头的单词的后半部分(除了re以外的部分),如:I'm reading a book,它会匹配ading.
 
 * `(?!exp)`匹配后面跟的不是exp的位置,零宽度负预测先行断言,它断言此位置后面不能匹配表达式exp.
 > 例如:`\d{3}(?!\d)`匹配三个数字而且这三个数字后面不能s是数字; `\b((?!abc)\w)+\b`匹配不包含连续字符串abc的单词
 
 * `(?<!exp)`匹配前面不是exp的位置,也叫零宽度负回顾后发断言,它断言此位置的前面不能匹配表达式exp.
 > 例如: `(?<![a-z]\d{7})`匹配前面不是小写字母的7位数字.
 
 
 */


do {

    let str = "f"
    //单个
    //let regex = "[a-zA-Z]"//单个字母
    //let regex = "[0-9]"//单个数字
    //let regex = "[0-9a-zA-Z]"//单个数字或字母
    //let regex = "[\\u4e00-\\u9fa5]"//汉字
    
    //1或N个, MATCHES[c]表示大小写不敏感,[0-9]可以换成\\d
    //let regex = "[a-zA-Z]+"//字母
    let regex = "[0-9a-zA-Z]+"//字母或数字
    //let regex = "[0-9a-zA-Z]{2,5}"//2-5位字母或数字
    //(不能都是小写字母或大写字母或数字,是数字字母组合)6-12位数字和字母组合
    //let regex = "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[0-9a-zA-Z]{6,12}"
    //(必须包含大写字母和小写字母和数字)8-20必须包含大小写字母和数字
    //let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}"
    //数字和字母组合
    //let regex = "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)[a-zA-Z0-9]+$"
    
    let pre = NSPredicate(format: "SELF MATCHES %@", regex)
    let ret = pre.evaluate(with: str)
    
    
}



