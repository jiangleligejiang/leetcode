### 一、问题描述

![](https://user-gold-cdn.xitu.io/2019/3/13/16976df6f13841f0?w=811&h=432&f=png&s=44696)

### 二、思考过程
> 本题主要含义就是从一个集合中找出四个数的和，使其等于目标值，且四个数存在多种情况，但最终的结果不能包含相同的情况。

- 看完题后，心想这不是和[3Sum Closest](https://juejin.im/post/5c87b76351882515043f07ee)思路差不多嘛，只不过就是多了一个纬度，还是老办法：for+二分法

```c++
class Solution {
public:
    vector<vector<int>> fourSum(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end(), less<int>());
        vector<vector<int>> result;
        for (int i = 1; i < nums.size(); i ++) {
            if (nums[i] == nums[i - 1]) 
                continue;
            int cur = target - nums[i-1];
            for (int j = i; j < nums.size(); j ++) {
                int lo = j + 1, hi = nums.size() - 1;
                while(lo < hi) {
                    int tmp = nums[j] + nums[lo] + nums[hi];
                    if (tmp == cur) {
                        vector<int> v = {nums[i-1], nums[j], nums[lo], nums[hi]};
                        result.push_back(v);
                        lo ++;
                    } else if (tmp > cur) {
                        hi --;
                    }  else {
                        lo ++;
                    }
                }
            }
        }
        return result;
    }
};
```
结果通过了样例，但还是wrong answer了...

![](https://user-gold-cdn.xitu.io/2019/3/13/16976e3ec26b761a?w=415&h=172&f=png&s=8519)
细心一想，是重复元素的坑，由于```if(nums[i] == nums[i-1]) continue;```这个判断导致循环全被continue掉，为此，增加了一个条件，只有i>0的情况下才判断是否需要忽略重复元素。
```c++
class Solution {
public:
    vector<vector<int>> fourSum(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end(), less<int>());
        vector<vector<int>> result;
        for (int i = 0; i < nums.size(); i ++) {
            if (i > 0 && nums[i] == nums[i - 1]) 
                continue;
            int cur = target - nums[i];
            for (int j = i + 1; j < nums.size(); j ++) {
                int lo = j + 1, hi = nums.size() - 1;
                while(lo < hi) {
                    int tmp = nums[j] + nums[lo] + nums[hi];
                    if (tmp == cur) {
                        vector<int> v = {nums[i], nums[j], nums[lo], nums[hi]};
                        result.push_back(v);
                        lo ++;
                    } else if (tmp > cur) {
                        hi --;
                    }  else {
                        lo ++;
                    }
                }
            }
        }
        return result;
    }
};
```
结果还是wrong answer了，还是重复元素的坑！！！

![](https://user-gold-cdn.xitu.io/2019/3/13/16976ebf33ae7001?w=754&h=180&f=png&s=23396)
细细一想，是因为0，0的锅，我们只是在第一层for中判重了，但没有在第二层中判重啊！于是在第二层for循环中增加判断条件```if (j > (i+1) && nums[j] == nums[j-1]) continue;```，这次机智了，没有漏掉```j>i+1```这个条件。

![](https://user-gold-cdn.xitu.io/2019/3/13/16976ef9e2dd72c9?w=726&h=175&f=png&s=21565)
但结果还是错了，依旧是去重问题，为什么两个for都判重了，还是存在这种情况呢？后来看到```tmp==cur```的情况，我们只是进行了```lo++```操作，对于```-2,-1,0,3```这种情况，第一个0满足后，经过```lo++```还是出现```-2,-1,0,3```的情况！！！所以我们在这里也要去重，将相同的元素直接忽略掉！
```c++
class Solution {
public:
    vector<vector<int>> fourSum(vector<int>& nums, int target) {
        sort(nums.begin(), nums.end(), less<int>());
        vector<vector<int>> result;
        for (int i = 0; i < nums.size(); i ++) {
            if (i > 0 && nums[i] == nums[i - 1]) 
                continue;
            int cur = target - nums[i];
            for (int j = i + 1; j < nums.size(); j ++) {
                if (j > (i+1) && nums[j] == nums[j-1])
                    continue;
                int lo = j + 1, hi = nums.size() - 1;
                while(lo < hi) {
                    int tmp = nums[j] + nums[lo] + nums[hi];
                    if (tmp == cur) {
                        vector<int> v = {nums[i], nums[j], nums[lo], nums[hi]};
                        result.push_back(v);
                        do { lo ++; } while(lo < hi && nums[lo] == nums[lo-1]);
                        do { hi --; } while(lo < hi && nums[hi] == nums[hi+1]);
                    } else if (tmp > cur) {
                        hi --;
                    }  else {
                        lo ++;
                    }
                }
            }
        }
        return result;
    }
};
```
最终，Accept了！！！

### 三、总结
> 对于3sum、4sum问题，大致都是For+二分法的套路，通过二分法降低一层纬度，思路并不难，但要考虑其中的特殊情况:二分法的死循环和数据的去重等。