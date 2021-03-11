'use strict';
module.exports = function createDevConfig(answer) {
	let entryProp = answer.entry ? '"' + answer.entry + '"' : '"index.js"';
  let devConfig = {
    entry: entryProp,
    output: {
      filename: '"[name].js"',
    },
  };
  return devConfig;
};
