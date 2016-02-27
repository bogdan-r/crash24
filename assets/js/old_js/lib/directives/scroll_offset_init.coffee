angular.module('app.directives').directive('crScrollOffsetInit', [
  '$parse'
  ($parse)->
    restrict : 'A'
    link : (scope, element, attrs)->
      _fn = $parse(attrs.crScrollOffsetInit)

      _fn(scope, {$element : element})
])