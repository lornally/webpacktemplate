
//options: {postcssOptions:{plugins: () => [postcssPresetEnv({stage: 0})]}},
     
module.exports = {
  // You can specify any options from http://api.postcss.org/global.html#processOptions here
  // parser: 'sugarss',
  plugins: [
		// Plugins for PostCSS
	//	['postcss-short', { prefix: 'x' }],

		['postcss-preset-env',{stage: 0}],
	//	'postcss-modules',
		//'posthtml-css-modules',
		//'stylelint',
		//'postcss-sass',
  ],
};
