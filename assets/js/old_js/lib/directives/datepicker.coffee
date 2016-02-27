angular.module('app.directives').directive('crDatepicker', [
  ()->
    restrict : 'A'
    scope : {
      'show' : '&crDatepickerOnShow'
      'hide' : '&crDatepickerOnHide'
      'clearDate' : '&crDatepickerOnCleardate'
      'changeDate' : '&crDatepickerOnChangedate'
      'changeYear' : '&crDatepickerOnChangeyear'
      'changeMonth' : '&crDatepickerOnChangemonth'
      'datepicker' : '=crDatepicker'
    }
    link : (scope, element, attrs)->
      scope.datepickerEvents = ['show', 'hide', 'clearDate', 'changeDate', 'changeYear', 'changeMonth']
      datepicker = element.datepicker(scope.datepicker)
      _.each(scope.datepickerEvents, (eventName, i)->
        datepicker.on(eventName, (e)->
          scope.$apply(->
            scope[eventName]()
          )
        )
      )
])