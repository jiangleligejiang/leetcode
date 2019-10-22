import UIKit

class Solution {
    func checkStraightLine(_ coordinates: [[Int]]) -> Bool {
        if coordinates.count <= 2 {
            return true
        }
        
        let first = (x: coordinates[0][0], y: coordinates[0][1])
        let second = (x: coordinates[1][0], y: coordinates[1][1])
        let k = Double(second.y - first.y) / Double(second.x - first.x)
        let b = Double(first.y) - k * Double(first.x)
        
        for i in 2 ..< coordinates.count {
            let x = Double(coordinates[i][0])
            let y = Double(coordinates[i][1])
            if y != k * x + b {
                return false
            }
        }
        return true
    }
    
    func removeSubfolders(_ folder: [String]) -> [String] {
        var folderCopy:[String] = folder
        for i in 0 ..< folder.count {
            let str = folder[i]
            for j in 0 ..< folder.count {
                if i != j && self.checkContain(root: str, sub: folder[j]) {
                    if let removeIndex = folderCopy.firstIndex(of: str) {
                        folderCopy.remove(at: removeIndex)
                        break
                    }
                }
            }
        }
        return folderCopy
    }
    
    private func checkContain(root: String, sub: String) -> Bool {
    
        let components1 = root.components(separatedBy: CharacterSet.init(charactersIn: "/"))
        let components2 = sub.components(separatedBy: CharacterSet.init(charactersIn: "/"))
        if components1.count > components2.count {
            return false
        }
        
        var i = 0, j = 0
        while i < components1.count && j < components2.count {
            if components1[i] != components2[j] {
                return false
            }
            i += 1; j += 1
        }
        return true
    }
    
    func removeSubfolders_V2(_ folder: [String]) -> [String] {
        if folder.isEmpty {
            return folder
        }
        var folders: [String] = folder
        folders.sort()
        
        var root = folders[0] + "/"
        var result: [String] = [folders[0]]
        
        for i in 1 ..< folders.count {
            if !folders[i].contains(root) {
                root = folders[i] + "/"
                result.append(folders[i])
            }
        }
        
        return result
    }
    
    func balancedString(_ s: String) -> Int {
        var q = 0, r = 0, w = 0, e = 0
        for character in s {
            switch character {
            case "Q":
                q += 1
            case "R":
                r += 1
            case "W":
                w += 1
            case "E":
                e += 1
            default:
                break
            }
        }
        let balance = s.count / 4
        
        var dict:[Character : Int] = [:]
        dict["Q"] = q - balance
        dict["R"] = r - balance
        dict["W"] = w - balance
        dict["E"] = e - balance
        
        return balance
    }
}

let solution = Solution()
print(solution.checkStraightLine([[1,1],[2,2],[3,4],[4,5],[5,6],[7,7]]))
print(solution.removeSubfolders_V2(["/a","/a/b","/c/d","/c/d/e","/c/f"]))
//print(solution.balancedString("WWEQERQWQWWRWWERQWEQ"))



