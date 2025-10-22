const express = require('express');
const app = express();
const port = 8080;

app.use(express.json());

let walletData = {
  'test_address': {
    address: 'test_address',
    balance: 1000,
    transactions: [],
  },
};

app.get('/flutterflow/wallet-info', (req, res) => {
  const address = req.query.address;
  if (walletData[address]) {
    res.json({ success: true, data: walletData[address] });
  } else {
    res.status(404).json({ success: false, message: 'Wallet not found' });
  }
});

app.post('/faucet', (req, res) => {
  const address = req.body.address;
  if (walletData[address]) {
    walletData[address].balance += 100;
    res.json({ success: true, message: '100 tokens credited' });
  } else {
    res.status(404).json({ success: false, message: 'Wallet not found' });
  }
});

app.post('/flutterflow/send-transaction', (req, res) => {
  const { recipient, amount } = req.body;
  const sender = 'test_address'; // Hardcoded for now

  if (walletData[sender] && walletData[recipient]) {
    if (walletData[sender].balance >= amount) {
      walletData[sender].balance -= amount;
      walletData[recipient].balance += amount;
      const transaction = { sender, recipient, amount, timestamp: new Date() };
      walletData[sender].transactions.push(transaction);
      walletData[recipient].transactions.push(transaction);
      res.json({ success: true, data: { transactionHash: 'mock_hash' } });
    } else {
      res.status(400).json({ success: false, message: 'Insufficient funds' });
    }
  } else {
    res.status(404).json({ success: false, message: 'Sender or recipient not found' });
  }
});

app.listen(port, () => {
  console.log(`Mock server listening at http://localhost:${port}`);
});
