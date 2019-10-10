import UIKit

public struct Queue<T> {
    
    fileprivate var arr = [T]()
    
    public var isEmpty: Bool {
        return arr.count == 0
    }
    
    public var count: Int {
        return arr.count
    }
    
    public mutating func enqueue(_ element: T) {
        arr.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return arr.removeFirst()
        }
    }
    
    public func front() -> T? {
        return arr.first
    }
    
}

var queue: Queue<Int> = Queue()
queue.enqueue(10)
queue.enqueue(3)
queue.enqueue(57)
print("queue: \(queue)")
queue.dequeue()
print("queue: \(queue)")
print("queue front: \(queue.front() ?? -1)")

public struct Queue2<T> : Sequence {
    
    fileprivate var _storage: ContiguousArray<T?>
    private let _resizeFactor = 2
    private var _initalCapacity: Int
    private var _count = 0
    private var _pushNextIndex = 0
    
    init(_ initalCapacity: Int) {
        _initalCapacity = initalCapacity
        _storage = ContiguousArray<T?>(repeating: nil, count: initalCapacity)
    }
    
    private var dequeueIndex: Int {
        let index = _pushNextIndex - _count
        return index < 0 ? index + _storage.count : index
    }
    
    public var isEmpty: Bool {
        return _count == 0
    }
    
    public var count: Int {
        return _count
    }
    
    public mutating func enqueue(_ element: T) {
        if count == _storage.count {
            resizeTo(Swift.max(_storage.count, 1) * _resizeFactor)
        }
            
        _storage[_pushNextIndex] = element
        _pushNextIndex += 1
        _count += 1
        
        if _pushNextIndex >= _storage.count {
            _pushNextIndex -= _storage.count
        }
    }
    
    private mutating func resizeTo(_ size: Int) {
        var newStorage = ContiguousArray<T?>(repeating: nil, count: size)
        let count = _count
        let dequeueIndex = self.dequeueIndex
        let spaceToEndOfQueue = _storage.count - dequeueIndex
        
        let countElementsInFirstBatch = Swift.min(count, spaceToEndOfQueue)
        let countElementsInSecondBatch = count - countElementsInFirstBatch
        
        newStorage[0 ..< countElementsInFirstBatch] = _storage[dequeueIndex ..< (dequeueIndex + countElementsInFirstBatch)]
        newStorage[countElementsInFirstBatch ..< (countElementsInFirstBatch + countElementsInSecondBatch)] = _storage[0 ..< countElementsInSecondBatch]
        
        _count = count
        _pushNextIndex = count
        _storage = newStorage
    }
    
    public mutating func dequeue() -> T? {
        if count == 0 {
            return nil
        }
        defer {
            let downSizeLimit = _storage.count / _resizeFactor
            if count < downSizeLimit && downSizeLimit >= _initalCapacity {
                resizeTo(downSizeLimit)
            }
        }
        
        return dequeueElementOnly()
    }
    
    private mutating func dequeueElementOnly() -> T {
        precondition(count > 0)
        
        let index = dequeueIndex
        
        defer {
            _storage[index] = nil
            _count -= 1
        }
        
        return _storage[index]!
    }
    
    public func front() -> T? {
        return _storage[dequeueIndex]
    }
    
    public __consuming func makeIterator() -> AnyIterator<T> {
        
        var i = dequeueIndex
        var count = _count
        
        return AnyIterator {
            if count == 0 {
                return nil
            }
            
            defer {
                count -= 1
                i += 1
            }
            
            if i >= self._storage.count {
                i -= self._storage.count
            }
            
            return self._storage[i]
        }
        
    }
    
}

var queue2: Queue2<Int> = Queue2(1)
queue2.enqueue(10)
queue2.enqueue(3)
queue2.enqueue(57)
for element in queue2 {
    print("element from queue2: \(element)")
}
queue2.dequeue()
print("queue front: \(queue2.front() ?? -1)")
for element in queue2 {
    print("element from queue2: \(element)")
}
