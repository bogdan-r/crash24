var webpack = require('webpack');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  context: __dirname + '/assets',
  entry: {
    web: './js/web/boot.js',
    admin: './js/admin/boot.js'
  },
  devtool: 'eval-source-map',
  debug: true,
  output: {
    path: __dirname + "/.tmp/public",
    filename: "js/[name]/[name].bundle.js",
    publicPath: "/"
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
      {
        test: /\.js$/, exclude: /node_modules/,
        loader: "babel-loader",
        query: {
          plugins: ['transform-runtime', 'transform-decorators-legacy'],
          presets: ['es2015', 'stage-0', 'react']
        }
      }, {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("css")
      }, {
        test: /\.less$/,
        loader: ExtractTextPlugin.extract("css!autoprefixer?browsers=last 2 versions!less")
      }, {
        test:   /\.(png|jpg|gif|svg|otf|ttf|eot|woff|woff2)$/,
        loader: 'file?name=[path][name].[ext]'
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      'fetch': 'imports?this=>global!exports?global.fetch!whatwg-fetch'
    }),
    new ExtractTextPlugin('css/[name].css', {allChunks: true})
  ]
};

