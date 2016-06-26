/**
------------------------------------------
Data:  0A0056712F02
Tag:  0xa00
ID:  56712F  -  5665071
Checksum:  0x2
------------------------------------------
0A0056712F02
48 65 48 48 53 54 55 49 50 70 48 50 
*/
var SerialPort = require("serialport").SerialPort,
    port = new SerialPort("/dev/ttyAMA0", { baudrate: 9600, databits: 8 }),
    start_flag = 0x02,
    end_flag = 0x03,
    line = [];


port.on('data', data => {
    console.log(data.toString('ascii'));
    [].forEach.call(data.toString('ascii'), function(symbol, i){
        if(symbol === start_flag){
        } else if (symbol === end_flag) {
            parseExecuteLine();
        } else {
            line.push(symbol.toString(16));
        }
    });
});

function parseExecuteLine () {
    line = line.slice(0,10)
               .reduce((prev, curr, i, arr) => {
                   return (i % 2) ? (arr[i-1] + '' + item) : false;
               }, 0);
(function(){
    var Checksumme = 0;               
    [ 48, 65, 48, 48, 53, 54, 55, 49, 50, 70 ]
    .slice(0,10)
    .forEach((item, i, arr) => {
        if((i % 2)){
            Checksumme = Checksumme ^ ( (item << 4) + arr[i+1]);  
        }
    });
    console.log(Checksumme, Checksumme.toString(16));
})();

    console.log(line);
    line = [];
}


function hex2a(hexx) {
    var hex = hexx.toString();//force conversion
    var str = '';
    for (var i = 0; i < hex.length; i += 2)
        str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    return str;
}

function a2hex(str) {
    var arr = [];
    for (var i = 0, l = str.length; i < l; i ++) {
        var hex = Number(str.charCodeAt(i)).toString(16);
        arr.push(hex);
    }
    return arr.join('');
}
 
[ '30', '41', '30', '30', '35', '36', '37', '31', '32', '46', '30', '32' ]
    .slice(0,10)
    .map(hex2a)
    .map((item, i, arr) => { return (i % 2) ? (arr[i-1] + '' + item) : false; })
    .filter (item => { return item !== false; })
    .reduce((prev, curr) => {
        if(!prev){
            return a2hex(curr);
        }
        console.log(prev, curr);
        return a2hex(prev) ^ a2hex(curr);
    }, '');
    
//////

(function () {
    var summ = 0;
    ['30', '41', '30', '30', '35', '36', '37', '31', '32', '46']
    .forEach((item, i, arr) => {
        var prev = parseInt(arr[i-1], 10),
            item = parseInt(item, 10);
        if(!(i % 2)) summ = summ ^ (item + prev);
    });
    console.log(summ);
})();

// 0x30 ^ 0x41 ^ 0x30 ^ 0x30 ^ 0x35 ^ 0x36 ^ 0x37 ^ 0x31 ^ 0x32 ^ 0x46

/*
 0A0056712F
 (0A)
 */

// 36 32 45 33 30 38 36 43 45 44
var test = ['36', '32', '45', '33', '30', '38', '36', '43', '45', '44']
    .map((item, i, arr) => { return (i % 2) ? (arr[i-1] + '' + item) : false; })
    .filter (item => { return item !== false; })
    .reduce((prev, curr) => {
        if(!prev) return curr;
        return xor(new Buffer(prev, 'hex'), new Buffer(curr, 'hex'))
    }, '');
console.log(test);

String.fromCharCode('3632'.charCodeAt(0) ^ z.charCodeAt(0));
(62H) XOR (E3H) XOR (08H) XOR (6CH) XOR (EDH)

0x36 0x32 45 33 30 38 36 43 45 44

String.fromCharCode('62'.charCodeAt(0) ^ 'E3'.charCodeAt(0) ^ '08'.charCodeAt(0) ^ '6C'.charCodeAt(0) ^ 'ED'.charCodeAt(0));

(48+49) ^ (48+48) ^ (48+55) ^ (51+52) ^ (69+48)