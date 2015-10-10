var webpack = require('webpack');

module.exports = {
  entry: {
    web: './assets/js/web/boot.js',
    admin: './assets/js/admin/boot.js'
  },
  devtool: 'eval-source-map',
  debug: true,
  output: {
    path: __dirname,
    filename: "./.tmp/public/js/[name]/[name].bundle.js"
  },
  externals: {
    "jquery": "jQuery"
  },
  resolve: {
    modulesDirectories: [
      'node_modules',
      'assets'
    ]
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loaders: ["babel-loader"] },
      { test: /\.css$/, loader: "style!css" },
      { test: /\.less$/, loader: "style!css!less"}
    ]
  }
};

