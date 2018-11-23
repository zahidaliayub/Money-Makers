var http = require("https");

var options = {
  "method": "POST",
  "hostname": "sandbox.bronid.com",
  "path": "/verify",
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

req.write(JSON.stringify({ metadata:
   { serviceUuid: 'yourServiceUuid',
     secretKey: 'yourSecretKey',
     version: '1',
     userId: '1' },
  personal:
   { firstName: 'Jane',
     middleName: 'Middle',
     lastName: 'Citizen',
     dateOfBirth: '30/11/1980',
     gender: 'f',
     email: 'test@email.com',
     address:
      { unitNumber: '10',
        streetNumber: '200',
        streetName: 'George',
        streetType: 'Street',
        suburb: 'Sydney',
        postcode: '2000',
        state: 'NSW',
        country: 'AUS',
        addressImage: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' } },
  driversLicence:
   { driversLicenceNumber: '11111111',
     driversLicenceState: 'VIC',
     driversLicenceExpiryDate: '30/11/2020',
     driversLicenceConsentCheck: 'checked',
     driversLicenceImageFront: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==',
     driversLicenceImageBack: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' },
  medicare:
   { medicareCardColour: 'green',
     medicareCardNumber: '2111111111',
     medicareIndividualReferenceNumber: '1',
     medicareNameOnCard: 'Jane Citizen',
     medicareExpiryDate: '11/2024',
     medicareConsentCheck: 'checked',
     medicareImage: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' },
  passport:
   { passportNumber: 'A1111111',
     passportCountryOfIssue: 'AUS',
     passportConsentCheck: 'checked',
     passportImage: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' } }));
req.end();
