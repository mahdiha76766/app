import assert from 'node:assert/strict';
import test from 'node:test';

import { DailyQuotaStore } from '../src/quota.js';
import { askRequestSchema, assistantReplySchema } from '../src/schema.js';
import { askOpenAiAssistant } from '../src/openai.js';

test('daily quota allows 10 then blocks', () => {
  const store = new DailyQuotaStore({
    limit: 10,
    nowFn: () => new Date('2026-07-24T10:00:00'),
  });
  for (let i = 0; i < 10; i++) {
    const r = store.tryConsume('device-a');
    assert.equal(r.ok, true);
  }
  const blocked = store.tryConsume('device-a');
  assert.equal(blocked.ok, false);
  assert.equal(blocked.code, 'quota_exceeded');
  assert.equal(store.remaining('device-a'), 0);
});

test('ask request rejects overlong question', () => {
  const long = 'x'.repeat(501);
  const result = askRequestSchema.safeParse({ question: long });
  assert.equal(result.success, false);
});

test('assistant reply schema rejects incomplete output', () => {
  const result = assistantReplySchema.safeParse({
    summary: 'فقط خلاصه',
  });
  assert.equal(result.success, false);
});

test('askOpenAiAssistant validates structured JSON', async () => {
  const reply = {
    summary: 'احتمال مشکل سوخت‌رسانی',
    possibleCauses: [
      {
        title: 'گرفتگی فیلتر بنزین',
        likelihood: 'medium',
        reason: 'کاهش قدرت در دور بالا',
      },
    ],
    followUpQuestions: ['آیا چک‌انجین روشن است؟'],
    recommendedTests: ['فشار سوخت را اندازه بگیرید'],
    urgency: 'inspect_soon',
    safetyWarning: 'در صورت افزایش دما توقف کنید',
    disclaimer: 'تشخیص نهایی باید توسط تعمیرکار انجام شود',
  };

  const fetchImpl = async () => ({
    ok: true,
    status: 200,
    text: async () =>
      JSON.stringify({
        output_text: JSON.stringify(reply),
      }),
  });

  const data = await askOpenAiAssistant({
    apiKey: 'test-key',
    question: 'موتور ریپ می‌زند',
    vehicleContext: { vehicleModel: 'پژو ۲۰۶', mileage: 120000 },
    recentMessages: [],
    fetchImpl,
  });
  assert.equal(data.urgency, 'inspect_soon');
  assert.equal(data.possibleCauses.length, 1);
});

test('askOpenAiAssistant fails on invalid output', async () => {
  const fetchImpl = async () => ({
    ok: true,
    status: 200,
    text: async () =>
      JSON.stringify({
        output_text: '{"summary":"incomplete"}',
      }),
  });

  await assert.rejects(
    () =>
      askOpenAiAssistant({
        apiKey: 'test-key',
        question: 'سوال',
        vehicleContext: {},
        recentMessages: [],
        fetchImpl,
      }),
    (err) => err.code === 'invalid_output',
  );
});
