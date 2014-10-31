angular.module('app.directives').directive('crRepeatComplite', [
  '$rootScope'
  ($rootScope)->
    compile = (tElement, tAttributes) ->
      id = ++uuid
      tElement.attr "repeat-complete-id", id
      tElement.removeAttr "cr-repeat-complite"
      completeExpression = tAttributes.crRepeatComplite
      parent = tElement.parent()
      parentScope = (parent.scope() or $rootScope)

      unbindWatcher = parentScope.$watch(->
        lastItem = parent.children("*[ repeat-complete-id = '" + id + "' ]:last")
        return unless lastItem.length
        itemScope = lastItem.scope()
        if itemScope.$last
          unbindWatcher()
          itemScope.$eval completeExpression
        return
      )
      return

    uuid = 0
    return {
      compile: compile
      priority: 1001
      restrict: "A"
    }

])