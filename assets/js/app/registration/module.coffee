window.Registration = 'app.modules.registration'
window.RegistrationControllers = 'app.modules.registration.controllers'

angular.module(Registration, [
  RegistrationControllers
])

angular.module(RegistrationControllers, [])