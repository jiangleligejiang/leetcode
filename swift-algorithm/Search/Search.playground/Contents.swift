import UIKit


// ============== 线性搜索，平均时间复杂度为O(n) ==============//
func linearSearch<T : Equatable> (_ arr: [T], _ element: T) -> Int? {
    for (index, obj) in arr.enumerated() where obj == element {
        return index
    }
    return nil
}

let array = [5, 2, 4, 7]
linearSearch(array, 2)

// ======================================================//




// ============== 二分法搜索，平均时间复杂度为O(lgn)，前置条件为序列必须是有序的 ==============//

func binarySearch<T : Comparable> (_ arr: [T], key: T, range: Range<Int>) -> Int? {
    if range.lowerBound >= range.upperBound {
        return nil
    }
    
    let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2 //避免使用`(lowerBound+upperBound)/2`的方式，可能出现溢出
    
    if arr[midIndex] < key {
        return binarySearch(arr, key: key, range: midIndex + 1 ..< range.upperBound)
    } else if arr[midIndex] > key {
        return binarySearch(arr, key: key, range: range.lowerBound ..< midIndex)
    } else {
        return midIndex
    }
}

let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43, range: 0 ..< numbers.count)

func binarySearchNoRecursive<T : Comparable> (_ arr: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = arr.count //upperBound选取为数组大小，非数组的最后一个元素
    
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if arr[midIndex] < key {
            lowerBound = midIndex + 1
        } else if arr[midIndex] > key {
            upperBound = midIndex //此处不能设置为`midIndex-1`,因为upperBound是不能取的位置
        } else {
            return midIndex
        }
    }
    
    return nil
}

binarySearchNoRecursive(numbers, key: 43)

// ======================================================//


// ============== 二分法统计元素次数，平均时间复杂度为O(lgn)，前置条件为序列必须是有序的 ==============//

func countOccurrences<T : Comparable> (_ arr: [T], key: T) -> Int {
    var leftBound: Int {
        var low = 0
        var high = arr.count
        while low < high {
            let mid = low + (high - low) / 2
            if key > arr[mid] {
                low = mid + 1
            } else {
                high = mid
            }
        }
        return low //此处返回为key最早出现的位置
    }
    
    var rightBound: Int {
        var low = 0
        var high = arr.count
        while low < high {
            let mid = low + (high - low) / 2
            if key < arr[mid] {
                high = mid
            } else {
                low = mid + 1
            }
        }
        return low //此处返回为key最后出现位置+1
    }
    
    return rightBound - leftBound
}

let a = [ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

countOccurrences(a, key: 3)

// ======================================================//

// ============== 使用pair的方式将最大最小值比较次数从forEach遍历比较方式的2(n-1)比较 降至3(n-1)/2次比较 ==============//

func minimumMaximum<T : Comparable> (_ array: [T]) -> (minimun: T, maximum: T)? {
    guard var minimum = array.first else {
        return nil
    }
    
    var maxmum = minimum
    let start = array.count % 2
    
    for i in stride(from: start, to: array.count, by: 2) {
        let pair = (array[i], array[i+1])
        if pair.0 > pair.1 {
            if pair.0 > maxmum {
                maxmum = pair.0
            }
            if pair.1 < minimum {
                minimum = pair.1
            }
        } else {
            if pair.1 > maxmum {
                maxmum = pair.1
            }
            if pair.0 < minimum {
                minimum = pair.0
            }
        }
    }
    return (minimum, maxmum)
}

let arr = [ 8, 3, 9, 4, 6 ]
minimumMaximum(arr)

// ======================================================//


// ============== 使用快速排序+二分法实现选择kth-element,时间复杂度为O(lgn) ==============//

public func randomizedSelect<T: Comparable> (_ array: [T], order k: Int) -> T {
    
    var a = array
    
    func randomPivot<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> T {
        let randomIndex = Int.random(in: low ..< (high + 1))
        a.swapAt(randomIndex, high)
        return a[high]
    }
    
    func randomizedPartition<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> Int {
        let pivot = randomPivot(&a, low, high)
        var i = low
        for j in low ..< high {
            if a[j] <= pivot {
                a.swapAt(i, j) //将小于pivot的放在前面
                i += 1
            }
        }
        a.swapAt(i, high) //将pivot放在“中间”位置
        return i
    }
    
    func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
        if low < high {
            let partition = randomizedPartition(&a, low, high)
            if k > partition {
                return randomizedSelect(&a, partition + 1, high, k)
            } else if k < partition {
                return randomizedSelect(&a, low, partition - 1, k)
            } else {
                return a[partition]
            }
        } else {
            return a[low]
        }
    }
    
    precondition(a.count > 0)
    return randomizedSelect(&a, 0, a.count - 1, k)
}

let arr2 = [ 7, 92, 23, 9, -1, 0, 11, 6 ]
randomizedSelect(arr2, order: 4)

// ======================================================//
