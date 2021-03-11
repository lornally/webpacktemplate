import * as Generator from 'yeoman-generator'

module.exports = class WebpackGenerator extends Generator
	constructor:(args, opts) ->
		super args, opts
		opts.env.configuration = dev: {}
	
  
	prompting:->
		@prompt [
			List 'confirm', 'Welcome to the demo scaffold! Are you ready?', ['Yes','No','Pengwings']
		]
		.then (answer) ->
			if answer['confirm'] == 'Pengwings'
				0 # build the configuration
			
		
  