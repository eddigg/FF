const express = require('express');
const cors = require('cors');
const http = require('http');
const https = require('https');
const { URL } = require('url');

const app = express();
app.use(cors());
app.use(express.json());

// Blockchain node configuration
const BLOCKCHAIN_URL = process.env.BLOCKCHAIN_URL || 'http://blockchain-node:8080';

// Helper function to make HTTP requests
function makeRequest(url, options = {}) {
  return new Promise((resolve, reject) => {
    const parsedUrl = new URL(url);
    const client = parsedUrl.protocol === 'https:' ? https : http;

    const req = client.request({
      hostname: parsedUrl.hostname,
      port: parsedUrl.port,
      path: parsedUrl.pathname + parsedUrl.search,
      method: options.method || 'GET',
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      }
    }, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        try {
          resolve({
            statusCode: res.statusCode,
            data: JSON.parse(data)
          });
        } catch (e) {
          resolve({
            statusCode: res.statusCode,
            data: data
          });
        }
      });
    });

    req.on('error', (err) => {
      reject(err);
    });

    if (options.body) {
      req.write(JSON.stringify(options.body));
    }
    req.end();
  });
}

// --- API Endpoints ---

app.get('/balance/:address', async (req, res) => {
  console.log(`[GET /balance] Address: ${req.params.address}`);
  try {
    const blockchainUrl = `${BLOCKCHAIN_URL}/balance/${req.params.address}`;
    console.log(`Proxying to: ${blockchainUrl}`);

    const response = await makeRequest(blockchainUrl);
    if (response.statusCode === 200) {
      res.json(response.data);
    } else {
      res.status(response.statusCode).json({ error: 'Blockchain request failed' });
    }
  } catch (error) {
    console.error('Error fetching balance:', error);
    res.status(500).json({ error: 'Failed to fetch balance from blockchain' });
  }
});

app.get('/transactions/:address', async (req, res) => {
  console.log(`[GET /transactions] Address: ${req.params.address}`);
  try {
    const blockchainUrl = `${BLOCKCHAIN_URL}/transactions/${req.params.address}`;
    console.log(`Proxying to: ${blockchainUrl}`);

    const response = await makeRequest(blockchainUrl);
    if (response.statusCode === 200) {
      res.json(response.data);
    } else {
      res.status(response.statusCode).json({ error: 'Blockchain request failed' });
    }
  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({ error: 'Failed to fetch transactions from blockchain' });
  }
});

app.post('/submit-transaction', async (req, res) => {
  console.log('[POST /submit-transaction] Body:', req.body);
  const { recipient, amount, sender, signature } = req.body;

  if (!recipient || !amount || !sender) {
    return res.status(400).json({ error: 'Missing required fields: recipient, amount, sender' });
  }

  try {
    const blockchainUrl = `${BLOCKCHAIN_URL}/submit-transaction`;
    console.log(`Proxying to: ${blockchainUrl}`);

    const response = await makeRequest(blockchainUrl, {
      method: 'POST',
      body: {
        recipient,
        amount: parseFloat(amount),
        sender,
        signature
      }
    });

    if (response.statusCode === 200) {
      res.json(response.data);
    } else {
      res.status(response.statusCode).json({ error: 'Blockchain request failed' });
    }
  } catch (error) {
    console.error('Error submitting transaction:', error);
    res.status(500).json({ error: 'Failed to submit transaction to blockchain' });
  }
});

app.listen(3000, () => {
  console.log(`Blockchain API Gateway listening on port 3000`);
  console.log(`Connected to blockchain node at: ${BLOCKCHAIN_URL}`);
});
