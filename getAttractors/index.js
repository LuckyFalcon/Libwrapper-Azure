'use strict';
const addon = require('../build/Release/libAttractFunctions');
const anuQrng = require('../api/anuapi.js');
const request = require('request');
const querystring = require('querystring');

module.exports =  async function (context, req) {
  try {
    //Init params
    var radius = parseFloat(req.query.radius);
    var x = req.query.x;
    var y = req.query.y;
    var selected = req.query.selected;
    var entropysource = req.query.entropy;
    
    var th = await addon.getOptimizedDots(radius); 
    var hexSize = await addon.requiredEnthropyHex(th);

    //Get Entropy from desired source
    var entropy;

    switch(entropysource){
      case "ANU": 
        entropy = await anuQrng.getsizeqrng(hexSize);
        break;
      case "CAMRNG": 
        var postBody = querystring.parse(context.req.body)
        entropy = await validateCameraRNG(postBody.entropy, parseFloat(postBody.size));
        break; 
      case "SCOTT": 
        entropy = await anuQrng.getsizeqrng(hexSize);
        break;
      default: 
        context.res = {
          status: 400, /* Defaults to 200 */
          body: 'No entropy source found',
          headers: {
              'Content-Type': 'application/json'
          }
        };
        context.done();
    }

    var buffer = Buffer.from(entropy, 'hex');
    var results = await getAttractors(buffer, radius, x, y);

    context.res = {
      status: 200,
      body: results.body,
      headers: {
          'Content-Type': 'application/json'
      }
    };
    context.done();
    return;
  } catch (error) {

    context.res = {
      status: 400,
      body: error,
      headers: {
          'Content-Type': 'application/json'
      }
    };
    context.done();
    return;
  }
};  

async function getAttractors(buffer, radius, x, y) {
  return new Promise(resolve => {
  var options = {
    url: 'https://gonewtonlib.azurewebsites.net/api/attractors?radius='+radius+'&latitude='+x+'&longitude='+y+'&gid=3333',
    method: 'POST',
    headers: {
      'Content-Type': 'application/octet-stream',
    },
    body: buffer
  };    
  request.post(options, function(err, response, body) {
    if (err) {
      resolve(err);

    }
    if (response) {
     resolve(response);
    }
  });
});
}

function highattractor(attractors, selected, context){
  return new Promise(resolve => {

  var json = JSON.parse(attractors)
  if(json.points.length > 0){
    if(selected == "Attractor"){
      let position = getMaxAttractor(json);
      request('https://api.onwater.io/api/v1/results/' + json.points[position].Center.Point.Latitude+','+json.points[position].Center.Point.Longitude + '?access_token='+tokenOnWater, { json: true }, (err, res, body) => {
      if (err) { return attractors }
        json.points[position].water = body.water;
        console.log(json.points[position])
         //Check water points
         context.res = {
          status: 200, /* Defaults to 200 */
          body: {
            points: [
              json.points[position]
            ]
          },
          headers: {
              'Content-Type': 'application/json'
          }
       };
      context.done();
      return;
      });
    }else if(selected == "Void"){
      let position = getMaxVoid(json);
      request('https://api.onwater.io/api/v1/results/' + json.points[position].Center.Point.Latitude+','+json.points[position].Center.Point.Longitude + '?access_token='+tokenOnWater, { json: true }, (err, res, body) => {
      if (err) { return attractors }
        json.points[position].water = body.water;
        //Check water points
        context.res = {
          status: 200, /* Defaults to 200 */
          body: {
            points: [
              json.points[position]
            ]
          },
          headers: {
              'Content-Type': 'application/json'
          }
       };
      context.done();
      return;
      });
    } else if(selected == "Anomalie"){
      let position = getMaxAnomaly(json);
      request('https://api.onwater.io/api/v1/results/' + json.points[position].Center.Point.Latitude+','+json.points[position].Center.Point.Longitude + '?access_token='+tokenOnWater, { json: true }, (err, res, body) => {
      if (err) { return attractors }
        json.points[position].water = body.water;
        //Check water points
        context.res = {
          status: 200, /* Defaults to 200 */
          body: {
            points: [
              json.points[position]
            ]
          },
          headers: {
              'Content-Type': 'application/json'
          }
       };
      context.done();
      return;
      });
    }
  } else {
    //Check water points
    context.res = {
      status: 200, /* Defaults to 200 */
      body: attractors,
      headers: {
          'Content-Type': 'application/json'
      }
   };
  context.done();
  return;
  }

});
}

function getMaxAttractor(attractors) {
  let max = 0;
  let position = -1;
  for (let i = 0; i < attractors.points.length; i++) {
    if (attractors.points[i].Power > max && attractors.points[i].Type == 1) {
      max = attractors.points[i].Power;
      position = i;
    }
  }
  return position;
}

function getMaxVoid(attractors) {
  let result = 0;
  let position = -1;

  for (let i = 0; i < attractors.points.length; i++) {
    if (attractors.points[i].Z_score < 0 && attractors.points[i].Type == 2) {
      if (result == 0 || attractors.points[i].Z_score < result) {
        result = attractors.points[i].Z_score;
        position = i;
      }
    }
  }
  return position;
}

function getMaxAnomaly(attractors){

  let positionvoid = getMaxVoid(attractors);
  let positionattractor = getMaxAttractor(attractors);

  if(positionvoid == -1){
    return positionattractor;
  }
  else if(positionattractor == -1){
    return positionvoid;
  }
  let minusZscore = attractors.points[positionvoid].Z_score;
  let maxPower = attractors.points[positionattractor].Power;

  if(Math.abs(minusZscore) > maxPower){
    return positionvoid;
  } else {
    return positionattractor;
  }

}

function validateCameraRNG(cameraRng, cameraRnglength){
  return new Promise(resolve => {
      if(cameraRng.length != cameraRnglength){
        console.log('valid')

        resolve('Camera RNG size does not match size');

      }

      //Verify whether the string is hex
      var regexp = /^[0-9a-fA-F]+$/;

      if (regexp.test(cameraRng)){
        //The string is HEX
        console.log('valid555')
        resolve(cameraRng);
      } else {
        //The string is not HEX
        resolve('Camera RNG error');
      }
      
  });
}