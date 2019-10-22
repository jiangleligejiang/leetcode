import UIKit

class Solution {
    
    func minAvailableDuration(_ slots1: [[Int]], _ slots2: [[Int]], _ duration: Int) -> [Int] {
        typealias Pair = (start: Int, end: Int)
        var pairs1: [Pair] = []
        var pairs2: [Pair] = []
        for arr in slots1 {
            pairs1.append((arr[0], arr[1]))
        }
        for arr in slots2 {
            pairs2.append((arr[0], arr[1]))
        }
        //以start进行排序，保证为“最早”的条件
        let cmp = { (first: Pair, second: Pair) -> Bool in
            return first.start < second.start
        }
        pairs1.sort(by: cmp)
        pairs2.sort(by: cmp)
        print(pairs1)
        print(pairs2)
        
        var i = 0, j = 0, result = -1
        while i < pairs1.count && j < pairs2.count {
            let first = pairs1[i], second = pairs2[j]
            let r = min(first.end, second.end)
            if first.start < second.start {
                if (r - second.start) >= duration { //判断是否满足条件
                    result = second.start
                    break
                }
            } else {
                if (r - first.start) >= duration {
                    result = first.start
                    break
                }
            }
            if r == first.end { //end最小的往前走
                i += 1
            } else {
                j += 1
            }
        }
        return result == -1 ? [] : [result, result + duration]
    }
    
    func probabilityOfHeads(_ prob: [Double], _ target: Int) -> Double {
        var dp: [[Double]] = Array.init(repeating: Array.init(repeating: 0, count: prob.count + 1), count: prob.count + 1)
        dp[0][0] = 1
        for i in 1 ... prob.count {
            for j in 1 ... i {
                dp[i][j] = dp[i-1][j] * (1 - prob[i-1]) + dp[i-1][j-1] * prob[i-1];
            }
            dp[i][0] = dp[i-1][0] * (1 - prob[i-1]);
        }
        return dp[prob.count][target]
    }
    
    func probabilityOfHeads_V2(_ prob: [Double], _ target: Int) -> Double {
        var dp: [Double] = Array.init(repeating: 0, count: prob.count + 1)
        dp[0] = 1
        for i in 1 ... prob.count {
            for j in (1 ... i).reversed() { //倒序更新，因为dp[j]依赖dp[j-1]数据，若正序更新，那么dp[j-1]会先更新，那么久覆盖了上一个状态的数据
                dp[j] = dp[j] * (1 - prob[i-1]) + dp[j-1] * prob[i-1]
            }
            dp[0] = dp[0] * (1 - prob[i-1])
        }
        return dp[target]
    }
    
    func probabilityOfHeads_V3(_ prob: [Double], _ target: Int) -> Double {
        var dp: [Double] = Array.init(repeating: 0, count: prob.count + 1)
        var np: [Double] = Array.init(repeating: 0, count: prob.count + 1)
        dp[0] = 1
        for i in 1 ... prob.count {
            np[0] = dp[0] * (1 - prob[i-1])
            for j in (1 ... i) {
                np[j] = dp[j] * (1 - prob[i-1]) + dp[j-1] * prob[i-1]
            }
            dp = np
        }
        return dp[target]
    }
    
    func maximizeSweetness(_ sweetness: [Int], _ K: Int) -> Int {
        var maximum = 0
        var minimum = 0
        for i in 0 ..< sweetness.count {
            maximum += sweetness[i]
            minimum = min(sweetness[i], minimum)
        }
        var left = minimum, right = maximum //选出目标值范围
        var result = -1
        while left <= right {
            let mid = left + (right - left) / 2
            if self.check(sweetness, K+1, mid) { //若满足切割条件，则尽可能往上走，以保证所选取的目标值最大
                left = mid + 1
                result = mid
            } else {
                right = mid - 1
            }
        }
        return result
    }
    
    private func check(_ arr: [Int], _ K: Int, _ target: Int) -> Bool{
        var times = 0
        var sum = 0
        for i in 0 ..< arr.count {
            sum += arr[i]
            if sum >= target { //保证能够切割成K份不小于目标值的集合
                times += 1
                sum = 0
            }
            
            if times >= K {
                return true
            }
        }
        return false
    }
}

let solution = Solution()
print(solution.minAvailableDuration(
    [[216397070,363167701],[98730764,158208909],[441003187,466254040],[558239978,678368334],[683942980,717766451]],
    [[50490609,222653186],[512711631,670791418],[730229023,802410205],[812553104,891266775],[230032010,399152578]],
    456085))
print(solution.probabilityOfHeads_V3([0.5, 0.5, 0.5, 0.5, 0.5], 0))
print(solution.maximizeSweetness([1,2,3,4,5,6,7,8,9], 5))




