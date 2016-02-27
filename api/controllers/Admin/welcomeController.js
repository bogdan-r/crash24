module.exports = {
  index(req, res) {
    res.cookie('XSRF-TOKEN', res.locals._csrf)
    return res.view();
  }
};