'use strict';

import Config from 'Config'; //从webpack读取数据. 

console.log(Config.apiurl); //这个是服务器端的url.

import _ from 'lodash';

  function component() {
    const element = document.createElement('div');

   // Lodash, currently included via a script, is required for this line to work
   // Lodash, now imported by this script
    element.innerHTML = _.join(['Hello, api地址: ', Config.apiurl], ' ');

    return element;
  }

  document.body.appendChild(component());
