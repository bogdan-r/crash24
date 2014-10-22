angular.module("app").run([
  '$rootScope'
  '$modal'
  '$window'
  'LocateDefinition'
  ($rootScope, $modal, $window, LocateDefinition)->
    $rootScope.settings = {
      sortFilters : [
        {name : 'Дистанции', value: "0", predicate : '', reverse : false},
        {name : 'Дате: По убыванию', value: "1", predicate : 'date', reverse : true},
        {name : 'Дате: По возрастанию', value: "2", predicate : 'date', reverse : false}
      ]

      datePickers : {
        searchFilter : {
          format : 'yyyy-mm-dd'
          endDate : new Date()
        }

        addIncident : {
          format : 'yyyy-mm-dd'
          endDate : new Date()
        }
      }
    }


    _modalInstance = null
    if !LocateDefinition.isExistLocate()
      LocateDefinition.setDefault()
      _modalInstance = $modal.open({
        templateUrl : RouterHelper.templateUrl('modals/confirm_locate')
        controller : 'ConfirmLocateCtrl'
        backdrop : 'static'
      })

    _modalInstance?.result.then(()->
      LocateDefinition.setExistLocate()
      $window.location.reload()
    )

    $.fn.datepicker.defaults.autoclose = true
    $.fn.datepicker.defaults.language = 'ru'
])