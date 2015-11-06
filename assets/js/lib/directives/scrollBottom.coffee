angular.module('app.directives').directive('crScrollBottom', [
  '$parse'
  '$timeout'
  ($parse, $timeout)->
    restrict : 'A'
    link : (scope, element, attrs)->

      #TODO исправить по человечески
      $timeout(()->
        element.scrollTop(999999)
      , 300)
])
