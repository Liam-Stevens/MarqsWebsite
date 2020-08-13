process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()

module.exports.devServer.host = '0.0.0.0'
module.exports.devServer.watchOptions.poll = 1000