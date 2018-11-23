var http = require("https");

var options = {
  "method": "POST",
  "hostname": "sandbox.bronid.com",
  "path": [
    "/webhookRequestTester"
  ],
  "headers": {
    "Content-Type": "application/json"
  }
};

var req = http.request(options, function (res) {
  var chunks = [];

  res.on("data", function (chunk) {
    chunks.push(chunk);
  });

  res.on("end", function () {
    var body = Buffer.concat(chunks);
    console.log(body.toString());
  });
});

req.write(JSON.stringify({ webhookUrl: 'https://sandbox.bronid.com/webhookTester',
  expectedResult:
   { status: 'error',
     verificationStatus: 'rejected',
     verificationUuid: '2222',
     userId: '2' } }));
req.end();
