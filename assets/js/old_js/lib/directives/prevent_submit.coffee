angular.module('app.directives').directive('crPreventSubmit', [
  ()->
    restrict : 'A'
    link : (scope, element, attrs)->

      preventFormSubmit = (e)->
        code = e.keyCode or e.which
        if code == 13
          e.preventDefault()
          return false

      $(element).on('focus', (e)->
        $(@).closest('form').on('keydown', preventFormSubmit)
      )

      $(element).on('blur', (e)->
        $(@).closest('form').off('keydown', preventFormSubmit)
      )
])


