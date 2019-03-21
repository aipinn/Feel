//: [Previous](@previous)

import Foundation

//var str = "Hello, playground"
//
////: [Next](@next)
//
//do {
//
//    let str = "http://baidu.com"
//    var url = URL.init(string: str)
//
//    let ret = url?.path.lengthOfBytes(using: .utf8)
//
//    let path = url?.absoluteString.hasSuffix("/")
//
//    let base = URL.init(string: "", relativeTo: url)
//
//}
//
//func startLoad() {
//    let url = URL(string: "https://123.com")!
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            print(error)
//            return
//        }
//        guard let httpResp = response as? HTTPURLResponse,
//            (200...299).contains(httpResp.statusCode) else {
//
//            return
//        }
//        if let mimeType = httpResp.mimeType, mimeType == "text/html",
//            let data = data,
//            let string = String(data: data, encoding: .utf8) {
//            print(string)
//        }
//
//    }
//    task.resume()
//
//    let config = URLSessionConfiguration.default
//    config.waitsForConnectivity = true//保持连接而不是立即断开
//
//
//}
//
////startLoad()
//
//class LoadData {
//
//}
//
//extension LoadData: URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate {
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//
//    }
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//
//    }
//
//
//
//}

let d = 18.01
let dd = 15.01
let ddd = d-dd == 3.0 //3.000 000 000 000 002
/*:
 1.0在64位计算机中二进制存储形式
 001111111111
 000000000000
 000000000000
 000000000000
 000000000000
 0000

 */


let a: [Int] = []
let b: [Int] = []
let c = a==b
