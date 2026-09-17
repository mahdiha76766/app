import {
  OPENAI_MODEL,
  MAX_OUTPUT_TOKENS,
  SYSTEM_PROMPT,
  assistantReplyJsonSchema,
  assistantReplySchema,
} from './schema.js';

function buildUserPayload({ question, vehicleContext, recentMessages }) {
  const ctx = {
    vehicleModel: vehicleContext.vehicleModel ?? null,
    mileage: vehicleContext.mileage ?? null,
    complaint: vehicleContext.complaint ?? null,
    selectedServices: vehicleContext.selectedServices ?? [],
    recentRepairs: vehicleContext.recentRepairs ?? [],
  };
  return {
    question,
    vehicleContext: ctx,
    recentMessages: recentMessages.slice(-6),
  };
}

function extractOutputText(data) {
  if (typeof data.output_text === 'string' && data.output_text.trim()) {
    return data.output_text.trim();
  }
  const parts = [];
  for (const item of data.output ?? []) {
    if (item.type !== 'message') continue;
    for (const c of item.content ?? []) {
      if (c.type === 'output_text' && typeof c.text === 'string') {
        parts.push(c.text);
      }
    }
  }
  return parts.join('\n').trim();
}

/**
 * Calls OpenAI Responses API with structured JSON schema.
 * @param {{ apiKey: string, model?: string, question: string, vehicleContext: object, recentMessages: array }} args
 */
export async function askOpenAiAssistant({
  apiKey,
  model = OPENAI_MODEL,
  question,
  vehicleContext,
  recentMessages,
  fetchImpl = fetch,
}) {
  if (!apiKey || process.env.DEMO_MODE === '1') {
    return {
      summary:
        'حالت نمایشی: بر اساس شرح شما چند علت محتمل برای بررسی پیشنهاد می‌شود.',
      possibleCauses: [
        {
          title: 'بررسی سیستم مرتبط با شکایت',
          likelihood: 'medium',
          reason: `سؤال: ${String(question).slice(0, 120)}`,
        },
        {
          title: 'نیاز به تست‌های میدانی',
          likelihood: 'high',
          reason: 'بدون بازدید حضوری نمی‌توان علت را قطعی دانست.',
        },
      ],
      followUpQuestions: [
        'آیا چراغ چک‌انجین روشن است؟',
        'علائم در چه شرایطی شدیدتر می‌شود؟',
      ],
      recommendedTests: [
        'بازرسی چشمی اتصالات و نشتی‌ها',
        'تست عملکردی قطعه مشکوک',
      ],
      urgency: 'inspect_soon',
      safetyWarning: 'در صورت صدای غیرعادی شدید یا بوی سوخت، خودرو را متوقف کنید.',
      disclaimer: 'تشخیص نهایی باید توسط تعمیرکار انجام شود (حالت نمایشی بدون OpenAI).',
    };
  }

  const payload = buildUserPayload({ question, vehicleContext, recentMessages });
  const body = {
    model,
    max_output_tokens: MAX_OUTPUT_TOKENS,
    input: [
      {
        role: 'developer',
        content: SYSTEM_PROMPT,
      },
      {
        role: 'user',
        content: JSON.stringify(payload),
      },
    ],
    text: {
      format: {
        type: 'json_schema',
        name: 'mechanic_assistant_reply',
        strict: true,
        schema: assistantReplyJsonSchema,
      },
    },
  };

  const res = await fetchImpl('https://api.openai.com/v1/responses', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });

  const raw = await res.text();
  let data;
  try {
    data = JSON.parse(raw);
  } catch {
    const err = new Error('Invalid JSON from OpenAI');
    err.code = 'upstream_invalid';
    err.status = res.status;
    throw err;
  }

  if (!res.ok) {
    const err = new Error(data?.error?.message || `OpenAI error ${res.status}`);
    err.code = 'upstream_error';
    err.status = res.status;
    err.details = data;
    throw err;
  }

  const text = extractOutputText(data);
  if (!text) {
    const err = new Error('Empty structured output from OpenAI');
    err.code = 'invalid_output';
    throw err;
  }

  let parsed;
  try {
    parsed = JSON.parse(text);
  } catch {
    const err = new Error('Assistant output is not valid JSON');
    err.code = 'invalid_output';
    err.raw = text;
    throw err;
  }

  const validated = assistantReplySchema.safeParse(parsed);
  if (!validated.success) {
    const err = new Error('Assistant output failed schema validation');
    err.code = 'invalid_output';
    err.details = validated.error.flatten();
    throw err;
  }

  return validated.data;
}
