const exec = require('child_process').exec;

console.log('Author: oreg0na (t.me/svpg16)');

const process = exec('react-scripts start');

process.stdout.on('data', function(data) {
    console.log(data.toString());
});

process.stderr.on('data', function(data) {
    console.error(data.toString());
});
