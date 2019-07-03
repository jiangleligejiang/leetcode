### 一、问题描述

![](https://user-gold-cdn.xitu.io/2019/3/15/1697f155270bbec1?w=768&h=283&f=png&s=39682)

### 二、思考过程
> 该题需要我们对数组进行重排序，使得数组的值是当前值的下一个值，比如```1->2->3```的下一个值为```1->3->2```。

- 起初的想法是从尾部开始遍历，若前面的数大于后面的数，则进行交换即可。若找不到这样的数，则将数组反转过来。

```c++
class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        for (int i = nums.size() - 1; i > 0; i --) {
            for (int j = i - 1; j >= 0; j --) {
                if (nums[i] <= nums[j]) continue;
                else {
                    int tmp = nums[i];
                    nums[i] = nums[j];
                    nums[j] = tmp;
                    return;
                }
            }
        }
        int lo = 0, hi = nums.size()-1;
        while(lo < hi) {
            int tmp = nums[lo];
            nums[lo] = nums[hi];
            nums[hi] = tmp;
            lo ++;
            hi --;
        }
    }
};
```
这样的想法对于给出的样例是OK的，但对于这种情况，是无法通过的！

![](https://user-gold-cdn.xitu.io/2019/3/15/1697f1b6596df96f?w=511&h=173&f=png&s=9220)
我们知道明显213>132,且213<231，所以```2->1->3```才是下一个值。明显上面的做法是存在漏洞的，它对于123,115这种升序的数组是OK的，但对于非升序的数组是不行的。我们来看一个比较长的序列
```c++
1,5,8,4,7,6,5,3,1
我们知道若从尾开始，若j = nums.size()-1, nums[j]<nums[j-1]，即为升序顺序，比如上面的3，2，1，就是这个情况，那么它势必是最大的。
抓住这个关键点，我们先找到不符合升序顺序的位置，如上从1开始，可以看到4，7是不符合的，那么我们要把4进行交换，交换的数就从4后面的序列中找出大于4的最小的数。

class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        int i = nums.size() - 2;
        while(i >= 0 && nums[i+1] <= nums[i]) { //找到不符合升序的位置
            i --;
        }
        if (i >= 0) {
            int j = nums.size() - 1;
            while(j > i && nums[j] <= nums[i]) { //找到大于4最小的数
                j --;
            }
            swap(nums, i, j);
            return;
        }
        
        int lo = 0, hi = nums.size()-1;
        while(lo < hi) { 
            swap(nums, lo, hi);
            lo ++;
            hi --;
        }
    }
    
    void swap(vector<int>& nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
};
```
但发现还是无法通过，我们可以思考下对于上面的程序，序列```1,5,8,4,7,6,5,3,1```经过交换后，得到的数为```1,5,8,5,7,6,4,3,1```，虽然这个数大于原序列，但却不是原序列的下一值，它的下一个值应该为```1,5,8,1,3,5,6,7```,所以我们交换后，应该对后面的序列反转过来。
```c++
class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        int i = nums.size() - 2;
        while(i >= 0 && nums[i+1] <= nums[i]) {
            i --;
        }
        if (i >= 0) {
            int j = nums.size() - 1;
            while(j > i && nums[j] <= nums[i]) {
                j --;
            }
            swap(nums, i, j);
        }
        
        reverse(nums, i+1);
    }
    
    void swap(vector<int>& nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
    
    void reverse(vector<int>& nums, int start) {
        int i = start, j = nums.size() - 1;
        while(i < j) {
            swap(nums, i, j);
            i ++;
            j --;
        }
    }
};
```
### 三、总结
> 该题最重要是能够考虑到特殊情况，不能只是简单地考虑样例的情况。找出升序变化的关键位置，并在交换后，对位置后面的序列反转输出。