const jwkToPem = require('jwk-to-pem');
const jwt = require('jsonwebtoken');
const ps = require('process');
const fetch = require('node-fetch');
(async () => {
  const token = ps.argv[2];
  console.log('<== TOKEN:', token);
  console.log('==> http://localhost:4566/userpool/.well-known/jwks.json')
  const jwksResponse = await fetch('http://localhost:4566/userpool/.well-known/jwks.json');
  const jwks = await jwksResponse.json();
  console.log('<==', jwks);

  let decodedToken = jwt.decode(token, { complete: true });
  console.log('DECODED TOKEN:', decodedToken);
  const publicKey = jwkToPem(jwks.keys[0]);
  console.log('PUBLIC KEY:', publicKey);
  try {
    const decoded = jwt.verify(token, publicKey);
    console.log('!!! JWT is valid');
  } catch (err) {
    console.error('!!! ERROR:', err.message);
  }

})();
