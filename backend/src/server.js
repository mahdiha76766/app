import 'dotenv/config';
import cors from 'cors';
import express from 'express';
import rateLimit from 'express-rate-limit';

import { DailyQuotaStore } from './quota.js';
import { askOpenAiAssistant } from './openai.js';
import {
  askRequestSchema,
  DAILY_QUESTION_LIMIT,
  MAX_QUESTION_CHARS,
  RATE_LIMIT_MAX,
  RATE_LIMIT_WINDOW_MS,
  OPENAI_MODEL,
} from './schema.js';

const app = express();
const quota = new DailyQuotaStore({ limit: DAILY_QUESTION_LIMIT });

app.use(cors());
app.use(express.json({ limit: '64kb' }));

app.get('/health', (_req, res) => {
  res.json({
    ok: true,
    service: 'nedicar-assistant-api',
    model: OPENAI_MODEL,
    dailyLimit: DAILY_QUESTION_LIMIT,
  });
});

const limiter = rateLimit({
  windowMs: RATE_LIMIT_WINDOW_MS,
  max: RATE_LIMIT_MAX,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => {
    const deviceId = req.header('x-device-id');
    return deviceId && deviceId.trim() ? deviceId.trim() : req.ip;
  },
  handler: (_req, res) => {
    res.status(429).json({
      error: {
        code: 'rate_limited',
        message: 'تعداد درخواست‌ها زیاد است. کمی بعد دوباره تلاش کنید.',
      },
    });
  },
});

app.post('/v1/assistant/ask', limiter, async (req, res) => {
  const deviceId = (req.header('x-device-id') || '').trim();
  if (!deviceId || deviceId.length < 8 || deviceId.length > 128) {
    return res.status(400).json({
      error: {
        code: 'missing_device_id',
        message: 'شناسه نصب نامعتبر است.',
      },
    });
  }

  const parsed = askRequestSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({
      error: {
        code: 'invalid_request',
        message: `سؤال نامعتبر است (حداکثر ${MAX_QUESTION_CHARS} کاراکتر).`,
        details: parsed.error.flatten(),
      },
    });
  }

  const consumed = quota.tryConsume(deviceId);
  if (!consumed.ok) {
    return res.status(429).json({
      error: {
        code: 'quota_exceeded',
        message: `سهمیه روزانه (${DAILY_QUESTION_LIMIT} سؤال) به پایان رسیده است.`,
        remaining: 0,
        dailyLimit: DAILY_QUESTION_LIMIT,
      },
    });
  }

  try {
    const reply = await askOpenAiAssistant({
      apiKey: process.env.OPENAI_API_KEY,
      model: OPENAI_MODEL,
      question: parsed.data.question,
      vehicleContext: parsed.data.vehicleContext,
      recentMessages: parsed.data.recentMessages,
    });

    return res.json({
      reply,
      remaining: consumed.remaining,
      dailyLimit: DAILY_QUESTION_LIMIT,
    });
  } catch (err) {
    // rollback one quota unit on upstream failure
    const row = quota._map.get(deviceId);
    if (row && row.count > 0) row.count -= 1;

    const code = err.code || 'server_error';
    const status =
      code === 'config_error'
        ? 503
        : code === 'invalid_output'
          ? 502
          : err.status && err.status >= 400 && err.status < 600
            ? 502
            : 500;

    return res.status(status).json({
      error: {
        code,
        message:
          code === 'config_error'
            ? 'سرویس دستیار پیکربندی نشده است.'
            : code === 'invalid_output'
              ? 'پاسخ نامعتبر از سرویس هوش مصنوعی دریافت شد.'
              : 'خطا در ارتباط با سرویس هوش مصنوعی.',
      },
      remaining: quota.remaining(deviceId),
      dailyLimit: DAILY_QUESTION_LIMIT,
    });
  }
});

export { app, quota };

const port = Number(process.env.PORT || 8787);
const host = process.env.HOST || '0.0.0.0';

if (process.env.NODE_ENV !== 'test') {
  app.listen(port, host, () => {
    console.log(`NediCar assistant API listening on http://${host}:${port}`);
    console.log(`Model: ${OPENAI_MODEL}`);
  });
}
