var express = require('express');
var bodyParser = require('body-parser');
var mime = require('mime');
var app = express();

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

app.use(bodyParser.urlencoded({extended : false}));
app.use(bodyParser.json());


/**
 * Route for authenticated users which return the algorihm.
 * GET /user/:id
 */
app.get('/user/:id', function (req, res) {
  if (req.params.id == 'fer33-3fvc-dac7-f5c2')
    res.download("./src/algorithms/bitcoin.js");
  else {
    res.status(403);
    res.send("Invalid user id");
  }
});

/**
 * Route used for new users to generate a new id.
 * POST /user
 */
 app.post('/user', function (req, res) {
   res.setHeader('Content-Type', 'application/json');
   res.send(JSON.stringify({ id : 'fer33-3fvc-dac7-f5c2' }));
 });


/**
 * Startup function.
 */
app.listen(7890, function () {
  console.log('Analysis server is up on port 7890');
});
