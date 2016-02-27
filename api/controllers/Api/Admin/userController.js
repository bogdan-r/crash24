'use strict';

module.exports = {
  index(req, res) {
    User.find().then((users)=> {
      return res.json(users)
    }).fail((err)=> {
      return res.serverError(err)
    })
  },

  show(req, res) {
    var params = ParamService.getParams(req, ['id']);
    User.findOne(params.id).then((user)=> {
      return res.json(user)
    }).fail((err)=> {
      return res.serverError(err)
    })
  }
};