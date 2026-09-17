# NediCar Assistant API

بک‌اند سبک برای «دستیار هوشمند مکانیک». کلید OpenAI فقط اینجا نگهداری می‌شود.

## اجرا

```bash
cd backend
cp .env.example .env
# OPENAI_API_KEY را در .env بگذارید
npm install
npm start
```

پیش‌فرض: `http://0.0.0.0:8787`

## متغیرهای محیطی

| متغیر | پیش‌فرض | توضیح |
|--------|---------|--------|
| `OPENAI_API_KEY` | — | الزامی |
| `OPENAI_MODEL` | `gpt-5.6-luna` | مدل Responses API |
| `PORT` | `8787` | پورت |
| `HOST` | `0.0.0.0` | برای دسترسی گوشی در LAN |
| `DAILY_QUESTION_LIMIT` | `10` | سقف روزانه هر نصب |
| `MAX_QUESTION_CHARS` | `500` | حداکثر طول سؤال |
| `MAX_OUTPUT_TOKENS` | `500` | سقف توکن پاسخ |
| `RATE_LIMIT_WINDOW_MS` | `60000` | پنجره Rate Limit |
| `RATE_LIMIT_MAX` | `20` | حداکثر درخواست در پنجره |

## API

`POST /v1/assistant/ask`  
Header: `X-Device-Id: <uuid نصب>`  
Body: `{ question, vehicleContext, recentMessages }`

`GET /health`
