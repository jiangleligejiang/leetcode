import UIKit

public struct Stack<T> {
    
    fileprivate var arr = [T]()
    
    public var isEmpty: Bool {
        return arr.count == 0
    }
    
    public var count: Int {
        return arr.count
    }
    
    public mutating func push(_ element: T) {
        arr.append(element)
    }
    
    public mutating func pop() -> T? {
        return arr.popLast()
    }
    
    public func top() -> T? {
        return arr.last
    }
    
}

var s: Stack<Int> = Stack()
s.push(10)
s.push(3)
s.push(57)
print("stack: \(s)")
s.pop()
print("stack: \(s)")
print("stack top: \(s.top() ?? -1)")

