const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// --- Mock Blockchain Data ---
const mockBalance = {
  "address": "0x1234567890abcdef",
  "balance": 123.45,
  "timestamp": Date.now()
};

const mockTransactions = {
  "address": "0x1234567890abcdef",
  "transactions": [
    { "hash": "0xabc123", "amount": -10.5, "timestamp": Date.now() - 100000, "recipient": "0xrecipient1", "sender": "0x1234567890abcdef"},
    { "hash": "0xdef456", "amount": 50.0, "timestamp": Date.now() - 250000, "recipient": "0x1234567890abcdef", "sender": "0xsender1"},
    { "hash": "0xghi789", "amount": -5.0, "timestamp": Date.now() - 500000, "recipient": "0xrecipient2", "sender": "0x1234567890abcdef"}
  ]
};

// --- API Endpoints ---

app.get('/balance/:address', (req, res) => {
  console.log(`[GET /balance] Address: ${req.params.address}`);
  res.json(mockBalance);
});

app.get('/transactions/:address', (req, res) => {
  console.log(`[GET /transactions] Address: ${req.params.address}`);
  res.json(mockTransactions);
});

app.post('/submit-transaction', (req, res) => {
  console.log('[POST /submit-transaction] Body:', req.body);
  const { recipient, amount } = req.body;
  
  if (!recipient || !amount) {
    return res.status(400).json({ error: 'Missing recipient or amount' });
  }

  const newTransaction = {
    hash: `0x${Math.random().toString(16).slice(2, 12)}`,
    amount: -parseFloat(amount),
    timestamp: Date.now(),
    recipient: recipient,
    sender: "0x1234567890abcdef"
  };

  // Add to the start of our mock transaction list
  mockTransactions.transactions.unshift(newTransaction);
  // Decrease our mock balance
  mockBalance.balance -= parseFloat(amount);

  res.json({
    "hash": newTransaction.hash,
    "status": "submitted"
  });
});

app.listen(3000, () => {
  console.log('Mock API Gateway listening on port 3000');
});
