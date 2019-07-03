### 一、问题描述

![](https://user-gold-cdn.xitu.io/2019/3/12/16972255afdc16fe?w=804&h=253&f=png&s=36080)

### 二、思考过程
> 题目的大致意思是要获取三个数的和，使得这个和最靠近目标值，并且这个值是唯一的

- 一开始的想法是用for+二分法的形式来实现，具体如下:
```c++
class Solution {
public:
    int threeSumClosest(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end());
        int result = INT_MAX;
        for (int i = 0; i < nums.size(); i ++) {
            int l = i + 1;
            int r = nums.size() - 1;
            while(l < r) {
                int tmp = nums[i] + nums[l] + nums[r];
                if (result == INT_MAX || fabs(tmp - target) < fabs(result - target)) {
                    result = tmp;
                }
                int m = (l + r) / 2;
                if (tmp < target) {
                    l = m;
                } else if (tmp > target) {
                    r = m;
                } else {
                    return target;
                }
            }
        }
        return result;
    }
};
```
运行代码之后，发现程序time out了，后来才意识到自己的二分法写错了！！！我们用样例来分析下原因
```
[-1, 2, 1, -4] 1
排序后：
[-4, -1, 1, 2] 1
i = 0, nums[i] = -4, l = 1, nums[l] = -1, r = 3, nums[r] = 2
tmp = nums[i] + nums[l] + nums[r] = -3 < target 
m = (l + r) / 2 = 1
因为 tmp < target, 所以 l = m = 1
此时: l = 1, r = 3！！！问题来了，这不是回到第一步了吗！所以程序才会陷入死循环！因为没有考虑到m的情况，可能依旧是l或者r，导致一直处于while循环中。
但其实这里还存在一个问题，就是m = (l + r) / 2这里，若l和r足够大的时候，可能存在溢出情况
```
针对上面两个问题，修改之后
```c++
class Solution {
public:
    int threeSumClosest(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end());
        int result = INT_MAX;
        for (int i = 0; i < nums.size(); i ++) {
            int l = i + 1;
            int r = nums.size() - 1;
            while(l < r) {
                int tmp = nums[i] + nums[l] + nums[r];
                if (result == INT_MAX || fabs(tmp - target) < fabs(result - target)) {
                    result = tmp;
                }
                int m = (l + r) >> 2;
                if (tmp < target) {
                    l = m - 1;
                } else if (tmp > target) {
                    r = m + 1;
                } else {
                    return target;
                }
            }
        }
        return result;
    }
};
```
但结果还是运行的不对，我们来看下错误样例

![](https://user-gold-cdn.xitu.io/2019/3/13/16974d5861fdf66f?w=335&h=154&f=png&s=9099)
```
根据样例，可以看出三个数为2、16、64，所以我们直接从2开始
i = 1, nums[i] = 2, l = 2, nums[l] = 4, r = 7, nums[r] = 128
tmp = nums[i] + nums[l] + nums[r] = 134 > target
m = (l + r) >> 2 = 4, r = 4, num[r] = 16
此时我们就会发现问题，现在范围缩小到l=2,r=4,那么64自然会被排除在外，所以无法获取到正确的结果。
```
为了避免这个问题，我们的二分法不能按照往常的做法每次从中间取，而是分别从两边逐一的取数。
```c++
class Solution {
public:
    int threeSumClosest(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end());
        
        int result = INT_MAX;
        for (int i = 0; i < nums.size(); i ++) {
            int l = i + 1;
            int r = nums.size() - 1;
            while(l < r) {
                int tmp = nums[i] + nums[l] + nums[r];
                if (result == INT_MAX || fabs(tmp - target) < fabs(result - target)) {
                    result = tmp;
                }
                if (tmp < target) {
                    l++;
                } else if (tmp > target) {
                    r--;
                } else {
                    return target;
                }
            }
        }
        return result;
    }
};
```
### 三、总结
> 虽然这是一道看似简单的题，但里面却隐藏来很多坑，特别是二分法的死循环问题，以及容易忽略的溢出问题。最后推荐一个二分法常见陷阱的文章。

- [二分查找法，你真的写对了吗](https://segmentfault.com/a/1190000011283470)



