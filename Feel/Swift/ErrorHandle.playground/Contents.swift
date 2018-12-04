import UIKit

var str = "Hello, Error handle"

// 可以使用任何遵循Error协议的类型来表示错误.

enum PrintError: Error {
    case outOfPaper
    case noToner
    case onFire
}

// 使用throw来抛出一个错误,并且用throws来标记u一个可以抛出错误的函数. 如果你在函数里抛出一个错误,函数会立即返回,并且调用函数处理错误的代码
func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrintError.noToner
    }
    return "Job sent"
}

// do catch try

do  {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
} catch {
    print(error)
    
 }

