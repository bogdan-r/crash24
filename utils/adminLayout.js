var _ = require('lodash');

module.exports = function (route) {
  const defaultAdminLayout = {
    locals: {
      layout: 'layouts/admin/layout'
    }};
  var routeObj;
  if (_.isString(route)) {
    var splitRoute = route.split('.');
    routeObj = {
      controller: splitRoute[0],
      action: splitRoute[1]
    }
  } else {
    routeObj = route
  }

  return _.assign({}, defaultAdminLayout, routeObj)
}