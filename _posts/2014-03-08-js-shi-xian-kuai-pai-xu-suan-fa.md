---
layout: post
title: "js实现快速排序算法"
categories:
    - 
tags:
    - js
    - quicksort
    - 快排
    - 快速排序
description: ""
---

快排是一种常用的排序算法，它的基本步骤如下：

* 选择基准
* 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。
* 递归地对两个子序列进行快速排序，直到序列为空或者只有一个元素为止。

在简单的伪代码中，此算法可简单地表示为：

     function quicksort(q)
         var list less, pivotList, greater
         if length(q) ≤ 1 {
            return q
         } else {
            select a pivot value pivot from q
            for each x in q except the pivot element
                if x < pivot then add x to less
                if x ≥ pivot then add x to greater
            add pivot to pivotList
            return concatenate(quicksort(less), pivotList, quicksort(greater))
         }


参考以上伪代码，js可以这么实现快排：

<!-- more -->

```javascript
var quicksort = function(arr) {
    if(arr.length <= 1) {
        return arr;
    }

    // 这里选择了序列的中间值作为基准
    var idx = Math.floor(arr.length / 2);
    var pivot = arr[idx];
    arr.splice(idx, 1);

    var left = [];
    var right = [];
    for(var i = 0, len = arr.length; i < len; i++) {
        if(arr[i] < pivot) {
            left.push(arr[i]);
        } else {
            right.push(arr[i]);
        }
    }
    return quicksort(left).concat([pivot]).concat(quicksort(right));
}

quicksort([3,2,12,6,7,9,6,10,2,4,5]);
```

运行此示例：

<div class="example">
<button id="quicksort1">快速排序</button>
<div id="quicksort1-result"></div>
<script type="text/javascript">
    var quicksort = function(arr) {
        if(arr.length <= 1) {
            return arr;
        }

        // 这里我选择了序列的中间值作为基准
        var idx = Math.floor(arr.length / 2);
        var pivot = arr[idx];
        arr.splice(idx, 1);

        var left = [];
        var right = [];
        for(var i = 0, len = arr.length; i < len; i++) {
            if(arr[i] < pivot) {
                left.push(arr[i]);
            } else {
                right.push(arr[i]);
            }
        }
        return quicksort(left).concat([pivot]).concat(quicksort(right));
    }
    $('#quicksort1').click(
        function(e) {
            var result = quicksort([3,2,12,6,7,9,6,10,2,4,5]);
            $('#quicksort1-result').html(
                '排序结果：' + result.join(',') 
            );
        }
    );
</script>
</div>

但是很显然，这种方法比较浪费存储空间，所以就有人提出了原地分区（in-place partition），伪代码如下：

     function partition(a, left, right, pivotIndex)
          pivotValue := a[pivotIndex]
          swap(a[pivotIndex], a[right])
          storeIndex := left
          for i from left to right-1
              if a[i] < pivotValue
                  swap(a[storeIndex], a[i])
                  storeIndex := storeIndex + 1
                  z
          swap(a[right], a[storeIndex]) 
          return storeIndex
 

有了以上分区算法，就可以这么写快排：

     procedure quicksort(a, left, right)
          if right > left
              select a pivot value a[pivotIndex]
              pivotNewIndex := partition(a, left, right, pivotIndex)
              quicksort(a, left, pivotNewIndex-1)
              quicksort(a, pivotNewIndex+1, right)

这种方式下，js可以这么实现快排：

```javascript
// 交换
function swap(arr, a, b) {
    var temp = arr[a];
    arr[a] = arr[b];
    arr[b] = temp;
}
// 分区算法
function partition(arr, low, high) {
    // 初始low为基准
    while(low < high) {
        while(high > low && arr[high] >= arr[low]) {
            high--;
        }
        while(low < high && arr[low] <= arr[high]) {
            low++;
        }
        swap(arr, low, high);
        high--;
    }
    
    return low;
}
// 快排
function qsort(arr, low, high) {
    if(low >= high) {
        return arr;
    }
    var pivot = partition(arr, low, high);

    qsort(arr, low, pivot - 1);
    qsort(arr, pivot + 1, high);

    return arr;
}

// demo
qsort([3,2,12,6,7,9,6,10,2,4,5]);
```

运行此示例：

<div class="example">
<button id="quicksort2">快速排序</button>
<div id="quicksort2-result"></div>
<script type="text/javascript">
    // 交换
    function swap(arr, a, b) {
        var temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }
    // 分区算法
    function partition(arr, low, high) {
        while(low < high) {
            while(high > low && arr[high] >= arr[low]) {
                high--;
            }
            while(low < high && arr[low] <= arr[high]) {
                low++;
            }
            swap(arr, low, high);
            high--;
        }
        
        return low;
    }
    // 快排
    function qsort(arr, low, high) {
        if(low >= high) {
            return arr;
        }
        var pivot = partition(arr, low, high);

        qsort(arr, low, pivot - 1);
        qsort(arr, pivot + 1, high);

        return arr;
    }
    $('#quicksort2').click(
        function(e) {
            var result = qsort([3,2,12,6,7,9,6,10,2,4,5], 0, 10);
            $('#quicksort2-result').html(
                '排序结果：' + result.join(',')
            );
        }
    );
</script>
</div>
