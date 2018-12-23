
'use strict';
const axios = require('axios');
const express = require('express');

const PORT = process.env.app_port || 8080;
const HOST = process.env.app_bind || '0.0.0.0';

// App
const app = express();
app.set('view engine', 'ejs');
app.get('/', (req, res) => {
    res.render('index', {});
});

app.get('/asciify/:url', (req, res) => {
    var config = require('/local/config.json');
    var asciifierApi = `${config.asciifierUrl}/ascii/image/`;
    var requestURL = asciifierApi + encodeURIComponent(req.params.url);
    axios.get(requestURL)
    .then(response => {
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(response.data, null, 4));
    })
    .catch(error => {
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify({ error: error.toString() }, null, 4));
        console.log(error);
    });
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);


