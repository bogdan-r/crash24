window.Pages = 'app.modules.pages'
window.PagesControllers = 'app.modules.pages.controllers'

angular.module(Pages, [
  PagesControllers
])

angular.module(PagesControllers, [])