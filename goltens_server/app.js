const path = require('path');
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const helmet = require('helmet');
const errorHandler = require('./middlewares/error');

// Routes
const authRoutes = require('./routes/auth');
const groupRoutes = require('./routes/group');
const messageRoutes = require('./routes/message');
const riskAssessmentRoutes = require('./routes/risk-assessment');
const otherFilesRoutes = require('./routes/other-files');
const feedbackRoutes = require('./routes/feedback');
const masterListRoutes = require('./routes/master-list');
const userOrientationRoutes = require('./routes/user-orientation');
const adminRoutes = require('./routes/admin');

const app = express();

// Development Only Middlewares
if (process.env.NODE_ENV === 'development') {
  app.use(cors());
}

// Middlewares
app.use(
  cors({ origin: ['https://goltens.co.in', 'https://www.goltens.co.in'] })
);
app.use(morgan('dev'));
app.use(helmet({ contentSecurityPolicy: false }));
app.use(express.json({ limit: '10kb' }));
app.use('/api/v1', express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public-flutter')));

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/group', groupRoutes);
app.use('/api/v1/message', messageRoutes);
app.use('/api/v1/risk-assessment', riskAssessmentRoutes);
app.use('/api/v1/other-file', otherFilesRoutes);
app.use('/api/v1/feedback', feedbackRoutes);
app.use('/api/v1/master-list', masterListRoutes);
app.use('/api/v1/user-orientation', userOrientationRoutes);
app.use('/api/v1/admin', adminRoutes);

// Serve Flutter App
app.use((_req, res, _next) => {
  res.sendFile(path.join(__dirname, 'public-flutter', 'index.html'));
});

// ErrorHandler
app.use(errorHandler);

module.exports = app;
