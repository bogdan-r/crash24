angular.module('app.directives').directive('crWatchScrollOffset', [
  '$parse'
  ($parse)->
    restrict : 'A'
    link : (scope, element, attrs)->
      _fn = $parse(attrs.crWatchScrollOffset)
      _timeout = null

      element.off('scroll.watchoffset')
      element.on('scroll.watchoffset', (e)->
        clearTimeout(_timeout)
        _timeout = setTimeout(()=>
          currentScrollOffset = angular.element(@).scrollTop()
          scope.$apply(->
            _fn(scope, {$event : e, currentScrollOffset : currentScrollOffset})
          )
        , 300)
      )
])