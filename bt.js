const readline = require('readline');
const rl = readline.createInterface(process.stdin, process.stdout);

const SerialPort = require("serialport").SerialPort;
const port = new SerialPort("/dev/ttyAMA0", { baudrate: 9600, databits: 8 });

rl.on('line', (cmd) => {
  console.log(`You just typed: ${cmd}`);
  port.write(cmd, function(err, bytesWritten){
    if(err){
      console.log('err' + err);
    }
    console.log('answer' + bytesWritten);
  });
});

port.on('data', data => {
    console.log(data);
});