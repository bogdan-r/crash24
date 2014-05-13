window.User = 'app.modules.user'
window.UserControllers = 'app.modules.user.controllers'

angular.module(User, [
  UserControllers
])

angular.module(UserControllers, [])