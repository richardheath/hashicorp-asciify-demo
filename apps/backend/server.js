
'use strict';

const art = require('ascii-art');
const express = require('express');
const uuidv4 = require('uuid/v4');
const download = require('download-file')
const Convert = require('ansi-to-html');
const convert = new Convert({
    fg: '#FFF',
    bg: '#000',
    newline: true,
    escapeXML: false,
});

const PORT = process.env.app_port || 8081;
const HOST = process.env.app_bind || '127.0.0.1';
const SAVE_TO_DB = process.env.SAVE_TO_DB || false;

const app = express();
app.get('/', (req, res) => {
    res.send('ascii');
});

app.get('/ascii/image/:url', (req, res) => {
    var options = {
        directory: "/tmp",
        filename: uuidv4()
    };

    download(req.params.url, options, function(err){
        if (err) throw err
        
        var image = new art.Image({
            filepath: options.directory + '/' + options.filename,
            alphabet:'variant4'
        });

        image.write(function(err, rendered){
            if (err) {
                res.send(err);
            }

            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify({ result: convert.toHtml(rendered) }, null, 4));

            if (SAVE_TO_DB) {
                saveResultToDB(req.params.url, rendered);
            }
        });
    });
});

function saveResultToDB(imageUrl, result) {
    var config = require('/local/config.json');
    var mysql = require('mysql');
    var connection = mysql.createConnection({
        host     : config.dbEndpoint,
        user     : config.username,
        password : config.password,
        database : 'asciifier'
    });
    
    connection.connect();
    var CURRENT_TIMESTAMP = mysql.raw('CURRENT_TIMESTAMP()');
    var post  = {imageUrl: imageUrl, result: result, createdDate: CURRENT_TIMESTAMP};
    connection.query('INSERT INTO track SET ?', post, function (error, results, fields) {
        if (error) throw error;
    });
    connection.end();
}

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
