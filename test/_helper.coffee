process.env.NODE_ENV = 'test'

require "#{__dirname}/assert-extra"
(require 'chai').should()
