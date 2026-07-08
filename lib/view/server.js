const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();
const cors = require('cors');
const crypto = require('crypto');

const app = express();
app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error(err));

function hashPassword(password) {
  return new Promise((resolve, reject) => {
    const salt = crypto.randomBytes(16).toString('hex');

    crypto.scrypt(password, salt, 64, (error, derivedKey) => {
      if (error) {
        reject(error);
        return;
      }

      resolve(`${salt}:${derivedKey.toString('hex')}`);
    });
  });
}

function verifyPassword(password, storedPassword) {
  return new Promise((resolve, reject) => {
    const [salt, originalHash] = String(storedPassword).split(':');

    if (!salt || !originalHash) {
      resolve(false);
      return;
    }

    crypto.scrypt(password, salt, 64, (error, derivedKey) => {
      if (error) {
        reject(error);
        return;
      }

      const derivedHash = derivedKey.toString('hex');
      resolve(
        crypto.timingSafeEqual(
          Buffer.from(originalHash, 'hex'),
          Buffer.from(derivedHash, 'hex'),
        ),
      );
    });
  });
}

function serializeUser(user) {
  return {
    id: user._id.toString(),
    name: user.name,
    email: user.email,
    phone: user.phone,
    businessName: user.businessName,
    role: user.role,
  };
}

// Example schema
const userSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, trim: true, lowercase: true, unique: true },
  phone: { type: String, default: '' },
  businessName: { type: String, default: '' },
  passwordHash: { type: String, required: true },
  role: { type: String, default: 'USER', uppercase: true },
}, {
  timestamps: true,
});
const User = mongoose.model('User', userSchema);

// Routes
app.get('/', (req, res) => {
  res.send('API is running');
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.post('/api/auth/register', async (req, res) => {
  try {
    const name = String(req.body.name || '').trim();
    const email = String(req.body.email || '').trim().toLowerCase();
    const phone = String(req.body.phone || '').trim();
    const businessName = String(req.body.businessName || name).trim();
    const password = String(req.body.password || '');

    if (!name || !email || !phone || !password) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ message: 'An account with this email already exists' });
    }

    const passwordHash = await hashPassword(password);
    const user = await User.create({
      name,
      email,
      phone,
      businessName,
      passwordHash,
      role: 'USER',
    });

    return res.status(201).json(serializeUser(user));
  } catch (error) {
    console.error('Register error:', error);
    return res.status(500).json({ message: 'Could not register account' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const email = String(req.body.email || '').trim().toLowerCase();
    const password = String(req.body.password || '');

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const passwordMatches = await verifyPassword(password, user.passwordHash);
    if (!passwordMatches) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    return res.json(serializeUser(user));
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({ message: 'Could not sign in' });
  }
});

app.get('/api/users', async (req, res) => {
  const users = await User.find().sort({ createdAt: -1 });
  res.json(users.map(serializeUser));
});

app.post('/api/users', async (req, res) => {
  const name = String(req.body.name || '').trim();
  const email = String(req.body.email || '').trim().toLowerCase();

  const user = await User.create({
    name,
    email,
    phone: String(req.body.phone || '').trim(),
    businessName: String(req.body.businessName || name).trim(),
    passwordHash: await hashPassword(String(req.body.password || 'change-me')),
    role: String(req.body.role || 'USER').trim().toUpperCase(),
  });

  res.status(201).json(serializeUser(user));
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));