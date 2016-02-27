'use strict'

var _ = require('lodash');

class ParamService {
  static getParams(req, params) {
    var outputParams = {};
    if(!_.isArray(params)){
      return outputParams
    }
    params.forEach((param)=> {
      let currentParam = req.param(param);
      if (!_.isUndefined(currentParam)) {
        outputParams[param] = currentParam
      }
    });

    return outputParams
  }
}

module.exports = ParamService;