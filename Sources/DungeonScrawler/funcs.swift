
import Foundation

func fib(iterations: Int) -> Int {
    var last = 0
    var n = 1
    
    for _ in 0 ..< iterations {
        let tmp = last
        last = n
        n = n + tmp
    }
    
    return n
}

func fib(target: Int) -> Int {
    var last = 0
    var n = 1
    
    while (n < target) {
        let tmp = last
        last = n
        n = n + tmp
    }
    
    return n
}

