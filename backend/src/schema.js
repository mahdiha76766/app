import { z } from 'zod';

export const DAILY_QUESTION_LIMIT = Number(process.env.DAILY_QUESTION_LIMIT || 10);
export const MAX_QUESTION_CHARS = Number(process.env.MAX_QUESTION_CHARS || 500);
export const MAX_OUTPUT_TOKENS = Number(process.env.MAX_OUTPUT_TOKENS || 500);
export const RATE_LIMIT_WINDOW_MS = Number(process.env.RATE_LIMIT_WINDOW_MS || 60_000);
export const RATE_LIMIT_MAX = Number(process.env.RATE_LIMIT_MAX || 20);
export const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-5.6-luna';

export const likelihoodSchema = z.enum(['low', 'medium', 'high']);
export const urgencySchema = z.enum(['normal', 'inspect_soon', 'stop_vehicle']);

export const assistantReplySchema = z.object({
  summary: z.string().min(1),
  possibleCauses: z
    .array(
      z.object({
        title: z.string().min(1),
        likelihood: likelihoodSchema,
        reason: z.string().min(1),
      }),
    )
    .min(1)
    .max(6),
  followUpQuestions: z.array(z.string()).max(6),
  recommendedTests: z.array(z.string()).max(8),
  urgency: urgencySchema,
  safetyWarning: z.string(),
  disclaimer: z.string().min(1),
});

export const askRequestSchema = z.object({
  question: z.string().trim().min(1).max(MAX_QUESTION_CHARS),
  vehicleContext: z
    .object({
      vehicleModel: z.string().max(120).optional(),
      mileage: z.number().int().nonnegative().nullable().optional(),
      complaint: z.string().max(800).optional(),
      selectedServices: z.array(z.string().max(80)).max(12).optional(),
      recentRepairs: z
        .array(
          z.object({
            summary: z.string().max(200),
            mileage: z.number().int().nonnegative().nullable().optional(),
          }),
        )
        .max(5)
        .optional(),
    })
    .default({}),
  recentMessages: z
    .array(
      z.object({
        role: z.enum(['user', 'assistant']),
        content: z.string().max(2000),
      }),
    )
    .max(6)
    .default([]),
});

/** JSON Schema for OpenAI structured output (strict). */
export const assistantReplyJsonSchema = {
  type: 'object',
  additionalProperties: false,
  required: [
    'summary',
    'possibleCauses',
    'followUpQuestions',
    'recommendedTests',
    'urgency',
    'safetyWarning',
    'disclaimer',
  ],
  properties: {
    summary: { type: 'string' },
    possibleCauses: {
      type: 'array',
      minItems: 1,
      maxItems: 6,
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['title', 'likelihood', 'reason'],
        properties: {
          title: { type: 'string' },
          likelihood: { type: 'string', enum: ['low', 'medium', 'high'] },
          reason: { type: 'string' },
        },
      },
    },
    followUpQuestions: {
      type: 'array',
      maxItems: 6,
      items: { type: 'string' },
    },
    recommendedTests: {
      type: 'array',
      maxItems: 8,
      items: { type: 'string' },
    },
    urgency: {
      type: 'string',
      enum: ['normal', 'inspect_soon', 'stop_vehicle'],
    },
    safetyWarning: { type: 'string' },
    disclaimer: { type: 'string' },
  },
};

export const SYSTEM_PROMPT = `شما دستیار تشخیصی برای مکانیک خودرو هستید.
فقط به زبان فارسی پاسخ بده.
هرگز خرابی را قطعی اعلام نکن؛ تشخیص نهایی همیشه با تعمیرکار است.
نام مشتری، شماره موبایل، پلاک کامل و اطلاعات بانکی را درخواست یا تکرار نکن.
پاسخ باید فقط JSON معتبر مطابق schema باشد.
در disclaimer بنویس که تشخیص نهایی باید توسط تعمیرکار انجام شود.`;
