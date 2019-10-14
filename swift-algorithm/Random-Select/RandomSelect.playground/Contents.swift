import UIKit

func select<T>(from a: [T], count k: Int) -> [T] {
    var a = a
    for i in 0 ..< k {
        let r = Int.random(in: i ..< a.count)
        if i != r {
            a.swapAt(i, r)
        }
    }
    return Array(a[0 ..< k])
}

let arr = [ "a", "b", "c", "d", "e", "f", "g" ]
print(select(from: arr, count: 3))

func reservoirSample<T>(from a: [T], count k: Int) -> [T] {
    precondition(a.count >= k)
    
    var result = [T]()
    for i in 0 ..< k {
        result.append(a[i])
    }
    
    for i in k ..< a.count {
        let j = Int.random(in: 0...i)
        if j < k {
            result[j] = a[i]
        }
    }
    return result
}

let result = reservoirSample(from: arr, count: 3)
print(result)

func select_v2<T>(from a: [T], count requested: Int) -> [T] {
    var examined = 0
    var selected = 0
    var b = [T]()
    
    while selected < requested {
        let r = Double(arc4random()) / 0x100000000
        let leftToExamine = a.count - examined
        let leftToAdd = requested - selected
        
        if Double(leftToExamine) * r < Double(leftToAdd) {
            selected += 1
            b.append(a[examined])
        }
        examined += 1
    }
    return b
}

print(select_v2(from: arr, count: 3))

