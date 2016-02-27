/**
 * Web/angular_templatesController.js
 *
 * @description ::
 * @docs        :: http://sailsjs.org/#!documentation/controllers
 */
var path = require('path');
var ROOT = process.cwd() + '/view/'
var ANGULAR_ROOT = path.normalize('web/angular_templates/');
var FULL_ANG_PATH = path.normalize(path.join(ROOT, ANGULAR_ROOT));
module.exports = {
  show: function (req, res) {
    //TODO сделать обработку ошибок
    var temlatePath = req.param('template');
    try {
      temlatePath = decodeURIComponent(temlatePath);
    } catch (e) {
      res.badRequest({error: 'Ошибка'});
      return;
    }

    if (~temlatePath.indexOf('\0')) {
      res.badRequest({error: 'Ошибка'});
      return;
    }
    fullPath = path.normalize(path.join(FULL_ANG_PATH, temlatePath))
    if (fullPath.indexOf(FULL_ANG_PATH) != 0) {
      res.badRequest({error: 'Ошибка'});
      return;
    }

    res.render(ANGULAR_ROOT + temlatePath, function (err, html) {
      if (err) {
        return res.notFound({error: 'Шаблон не найден'});
      }
      res.view(ANGULAR_ROOT + temlatePath, {layout: false})
    });

  }
};
