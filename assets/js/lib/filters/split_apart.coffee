angular.module("app.filters").filter "splitApart", [->
  (input, countSplitPart) ->
    toClass = (data) ->
      {}.toString.call(data).slice 8, -1

    splitData = (countToSplit, arrData) ->
      arr = []
      counter = 0
      i = 0

      while i < arrData.length
        arr.push []  if (i % countToSplit) is 0
        arr[counter].push arrData[i]
        counter++  if ((i + 1) % countToSplit) is 0
        i++
      arr

    return input  unless countSplitPart
    return splitData(countSplitPart, input)  if typeof countSplitPart is "number"
    if toClass(countSplitPart) is "Array"
      intermArr = input
      i = countSplitPart.length

      while i > 0
        intermArr = splitData(countSplitPart[i - 1], intermArr)
        i--
      intermArr
]