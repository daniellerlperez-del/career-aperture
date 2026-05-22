// Netlify Function: research.js
// Proxies requests to Claude API — API key stays server-side, never in the browser.

const https = require('https');

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'ANTHROPIC_API_KEY not configured in Netlify environment variables.' }),
    };
  }

  let body;
  try {
    body = JSON.parse(event.body);
  } catch {
    return { statusCode: 400, body: JSON.stringify({ error: 'Invalid JSON body' }) };
  }

  const payload = JSON.stringify({
    model:      body.model      || 'claude-sonnet-4-6',
    max_tokens: body.max_tokens || 1024,
    system:     body.system,
    messages:   body.messages,
  });

  return new Promise((resolve) => {
    const req = https.request(
      {
        hostname: 'api.anthropic.com',
        path:     '/v1/messages',
        method:   'POST',
        headers: {
          'Content-Type':      'application/json',
          'Content-Length':    Buffer.byteLength(payload),
          'x-api-key':         apiKey,
          'anthropic-version': '2023-06-01',
        },
      },
      (res) => {
        let data = '';
        res.on('data', chunk => { data += chunk; });
        res.on('end', () => {
          resolve({
            statusCode: res.statusCode,
            headers: { 'Content-Type': 'application/json' },
            body: data,
          });
        });
      }
    );

    req.on('error', (err) => {
      resolve({
        statusCode: 502,
        body: JSON.stringify({ error: err.message }),
      });
    });

    req.write(payload);
    req.end();
  });
};
