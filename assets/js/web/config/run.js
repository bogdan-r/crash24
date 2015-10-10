import _ from 'lodash'

runConfig.$inject = ['$rootScope', '$modal', '$window', '$cacheFactory', 'LocateDefinition'];

export default function runConfig($rootScope, $modal, $window, $cacheFactory, LocateDefinition){
  /*var _modalInstance = null;

  if(!LocateDefinition.isExistLocate()){
    LocateDefinition.setDefault();
    _modalInstance = $modal.open({
      templateUrl : RouterHelper.templateUrl('modals/confirm_locate'),
      controller : 'ConfirmLocateCtrl',
      backdrop : 'static'
    })
  }

  if(!_.isUndefined(_modalInstance) && !_.isNull(_modalInstance)){
    _modalInstance.result.then(()=>{
      LocateDefinition.setExistLocate();
      $window.location.reload();
    })
  }

  $.fn.datepicker.defaults.autoclose = true
  $.fn.datepicker.defaults.language = 'ru'*/
}
