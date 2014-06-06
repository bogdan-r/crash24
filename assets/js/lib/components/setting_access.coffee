angular.module('app.components').factory('SettingsServ', [
  '$rootScope',
  ($rootScope)->

    class Settings

      settingsRoot = $rootScope.settings

      get : (settingsPath)->
        splitSettings = settingsPath.split(':')
        settingValue = $.extend({}, settingsRoot)

        for setting in splitSettings
          settingValue = settingValue?[setting]

        settingValue

    Settings
])