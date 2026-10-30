# 🤖 Wiam Dev ChatBot

شات بوت ذكي بواجهة ويب أنيقة، من تطوير **Wiam Dev**، يجيب على أسئلتك باستخدام نموذج لغوي كبير عبر **نظام متعدد المزودين (Groq وGoogle Gemini وOpenRouter)** يضمن استمرارية الخدمة حتى عند انقطاع أو امتلاء كوتة أحد المزودين، ويمكنه أيضاً **قراءة وتحليل ملفاتك (PDF, Word, صور، TXT وMarkdown)** والإجابة من محتواها مباشرة باستخدام تقنية **RAG (Retrieval-Augmented Generation)**.

بالإضافة إلى ذلك، يدعم المشروع **توليد الصور بالذكاء الاصطناعي** من خلال Tool Calling، كما يستطيع **فهم وتحليل الصور** باستخدام OCR ونموذج Vision متعدد الوسائط عبر Groq.

![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python\&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-3.x-black?logo=flask\&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ المميزات

* 💬 واجهة محادثة أنيقة ومتجاوبة لسطح المكتب والموبايل، بتصميم مستوحى من ChatGPT
* 📎 رفع ملفات **PDF, Word (.docx), صور، TXT وMarkdown**
* 🔍 **بحث دلالي باستخدام RAG** لاسترجاع المعلومات الأكثر ارتباطاً بالسؤال
* 📚 بناء قاعدة معرفة من الملفات المرفوعة باستخدام FAISS
* 🧠 ذاكرة محادثة لكل جلسة مستخدم
* 🌐 دعم اللغة العربية والإنجليزية وواجهة RTL
* 🔤 استخراج النص من الصور باستخدام **Tesseract OCR**
* 👁️ **فهم الصور باستخدام Vision AI** عند عدم وجود نص كافٍ داخل الصورة
* 🤖 استخدام **Qwen Vision عبر Groq** لتحليل محتوى الصور ووصفها
* 🖼️ **توليد الصور بالذكاء الاصطناعي** من خلال الأوصاف النصية
* 🪄 استخدام **Tool Calling** لجعل النموذج يقرر تلقائياً متى يحتاج إلى توليد صورة
* 🎨 إنشاء صور من أوصاف تتضمن العناصر والألوان والأسلوب الفني والخلفية
* ⚡ استجابة سريعة عبر نظام متعدد المزودين: **Groq → Gemini → OpenRouter**
* 🔁 **Fallback تلقائي** بين ثلاثة مزودين للذكاء الاصطناعي عند فشل أو ازدحام أحدهم
* 🔄 إعادة محاولة ذكية (Retry with Backoff) عند ازدحام الطلبات لكل مزود
* 🔐 حماية مفاتيح API باستخدام Environment Variables
* 📋 عرض المستندات الموجودة في قاعدة المعرفة
* 🗑️ حذف المستندات وإعادة بناء فهرس البحث
* 🐳 دعم Docker
* 🚂 قابل للنشر على Railway ومنصات الاستضافة التي تدعم Flask

---

# 🧱 التقنيات المستخدمة

| الطبقة             | التقنية                                                       |
| ------------------ | ------------------------------------------------------------- |
| Backend            | Flask / Python                                                |
| LLM (أول محاولة - اختياري) | Groq API                                              |
| نموذج Groq              | `openai/gpt-oss-120b`                                        |
| LLM (إلزامي) | Google Gemini API (يُستخدم عند فشل Groq أو عدم ضبطه)         |
| نموذج Gemini            | `gemini-3.6-flash`                                           |
| LLM (احتياطي أخير - اختياري) | OpenRouter API                                      |
| نموذج OpenRouter        | `openrouter/free` (راوتر تلقائي يختار أفضل نموذج مجاني متاح) |
| SDK                | OpenAI-compatible SDK لكل المزودين الثلاثة                    |
| Image Generation   | Pollinations (أساسي) ← Hugging Face FLUX (احتياطي)             |
| Image Tool Calling | OpenAI-compatible Tool Calling                                |
| Vision AI          | `qwen/qwen3.6-27b` عبر Groq                                   |
| Embeddings         | Hugging Face Inference Providers                              |
| Embedding Model    | `sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2` |
| Vector Database    | FAISS                                                         |
| OCR                | Tesseract / PyTesseract                                       |
| PDF Processing     | pypdf                                                         |
| Word Processing    | python-docx                                                   |
| Image Processing   | Pillow                                                        |
| Frontend           | HTML / CSS / JavaScript                                       |
| Deployment         | Railway / Docker / Gunicorn                                   |

---

# 🧠 كيف يعمل المشروع؟

يمكن تقسيم النظام إلى عدة أجزاء رئيسية:

```text
                         ┌────────────────────┐
                         │      المستخدم      │
                         └─────────┬──────────┘
                                   │
                                   ▼
                         ┌────────────────────┐
                         │   Flask (main.py)  │
                         └─────────┬──────────┘
                                   │
                 ┌─────────────────┼─────────────────┐
                 ▼                 ▼                 ▼
           ┌──────────┐      ┌──────────┐      ┌─────────────┐
           │  Chat    │      │   RAG    │      │ Image Tool  │
           └────┬─────┘      └────┬─────┘      └──────┬──────┘
                │                 │                    │
                ▼                 ▼                    ▼
        Groq → Gemini →       FAISS ◄── Hugging   Pollinations → HF FLUX
          OpenRouter                       Face    (كشف صورة الحد + حفظ محلي)
```

---

# 💬 المحادثة مع الذكاء الاصطناعي

يعتمد المشروع على **نظام Fallback متعدد المزودين** بدلاً من الاعتماد على مزود واحد فقط، لضمان استمرارية الخدمة عند انقطاع أو امتلاء كوتة أحد المزودين.

## 🔗 ترتيب المحاولة

```text
1️⃣  Groq        → openai/gpt-oss-120b (اختياري، يُتخطى إن لم يُضبط مفتاحه)
2️⃣  Gemini      → gemini-3.6-flash    (إلزامي)
3️⃣  OpenRouter  → openrouter/free     (اختياري)
```

يتم تجربة المزودين بالترتيب أعلاه. عند فشل مزود لأي سبب (ازدحام طلبات، انتهاء كوتة، انقطاع خدمة)، ينتقل النظام تلقائياً للمزود التالي، من دون أي تدخل من المستخدم.

## 🔄 إعادة المحاولة (Retry with Backoff)

لكل مزود على حدة، عند حدوث خطأ **ازدحام طلبات (Rate Limit)**، يحاول النظام مرة أخرى مع فترة انتظار تصاعدية (Exponential Backoff) قبل الانتقال للمزود التالي:

```text
MAX_RETRIES = 2
MAX_RETRY_WAIT = 8 ثوانٍ
```

أما الأخطاء غير المتعلقة بالازدحام (مثل خطأ في المصادقة أو طلب غير صالح)، فينتقل النظام مباشرة للمزود التالي دون انتظار.

## 📨 محتوى الطلب

يتم إرسال:

* رسالة النظام
* سجل المحادثة
* سؤال المستخدم
* سياق المستندات عند توفره

إلى المزود النشط للحصول على الإجابة.

يحتفظ المشروع بآخر **4 رسائل** فقط كسياق يُرسل للنموذج في كل طلب (لتقليل استهلاك التوكنز).

> 💡 لماذا Gemini إلزامي؟ لأن `main.py` يتوقف عند التشغيل إذا لم يجد `GEMINI_API_KEY`، فهو الضمان الأخير الذي لا يعمل المشروع بدونه. Groq وOpenRouter اختياريان يتخطاهما النظام تلقائياً إن لم تُضبط مفاتيحهما.

> 🔄 لماذا `openrouter/free` بدلاً من نموذج مجاني محدد؟ لأن قائمة النماذج المجانية على OpenRouter تتغيّر وتُسحب باستمرار (مثلاً توقفت عائلة Llama المجانية بالكامل في وقت من الأوقات). `openrouter/free` هو الراوتر التلقائي الرسمي من OpenRouter، يختار بنفسه أفضل نموذج مجاني متاح حالياً، مما يجعل هذه الطبقة الاحتياطية مستقرة حتى لو تغيّرت أو أُلغيت نماذج مجانية معينة مستقبلاً.

---

# 🖼️ توليد الصور بالذكاء الاصطناعي

يدعم Wiam Dev ChatBot توليد الصور مباشرة من المحادثة.

إذا طلب المستخدم مثلاً:

```text
ارسم لي قطة صغيرة تبرمج على حاسوب محمول بأسلوب كرتوني
```

يمكن للنموذج اكتشاف أن الطلب يحتاج إلى صورة واستدعاء أداة:

```text
generate_image
```

بدلاً من كتابة رابط صورة وهمي. الأداة مدعومة على كل المزودين الثلاثة (Groq, Gemini, OpenRouter) باستخدام نفس تنسيق Tool Calling المتوافق مع OpenAI.

## 🔄 آلية توليد الصورة

```text
طلب المستخدم
     │
     ▼
LLM النشط ──► Tool Calling ──► generate_image(prompt)
     │
     ▼
السيرفر يجلب الصورة بنفسه
     │
     ├─► Pollinations (محاولتان، seed عشوائي)
     │        └─ هل هي صورة "At its limit"؟ ◄── كشف بالحجم + OCR
     │
     ├─► Hugging Face FLUX (احتياطي)
     │
     ▼
حفظ في storage/generated  ──►  /generated/<id>.jpg  ──►  الواجهة
```

> ⚠️ **لماذا لا نمرّر رابط Pollinations للمتصفح؟** عند امتلاء الخدمة المجانية لا يُرجع Pollinations خطأ HTTP، بل **صورة** مكتوب عليها "At its limit right now". لذلك يجلب السيرفر الصورة ويتحقق منها (الحجم المطلوب 1024×1024 + OCR لعبارات صورة الحد) قبل عرضها. إذا فشلت كل المزودات تظهر رسالة "الخدمة مشغولة" بدل صورة خاطئة.

الدالة المسؤولة:

```python
generate_image_url(prompt, width=1024, height=1024)  # تُرجع رابطاً محلياً /generated/...
```

والحجم الافتراضي: `1024 × 1024`.

يُحتفظ بآخر 200 صورة مولّدة فقط (`MAX_GENERATED_FILES`) لتوفير المساحة.

* * *

## 🪄 Image Tool

يحتوي المشروع على أداة مخصصة للنموذج باسم:

```text
generate_image
```

وتستقبل:

```text
prompt
```

وهو وصف تفصيلي للصورة.

يتم توجيه النموذج لإنشاء وصف يشمل، عند الحاجة:

* الأشخاص
* الأشياء
* الألوان
* الخلفية
* الأسلوب الفني
* التفاصيل البصرية

ثم يستخدم التطبيق هذا الوصف لتوليد الصورة وحفظها وإنشاء رابطها.

---

# 🔗 Image Generation API

يوفر المشروع Endpoint مستقلاً لتوليد الصور:

```text
POST /api/generate-image
```

مثال للطلب:

```json
{
  "prompt": "A cute cartoon cat programming on a laptop"
}
```

مثال للاستجابة:

```json
{
  "status": "ok",
  "image_url": "/generated/3f2a....jpg",
  "prompt": "A cute cartoon cat programming on a laptop"
}
```

---

# 🛡️ منع Fake Image Markdown

يتضمن النظام حماية إضافية في حال حاول النموذج كتابة صورة باستخدام Markdown بدلاً من استدعاء أداة التوليد.

مثلاً:

```markdown
![image](some-url)
```

يقوم المشروع باكتشاف هذا النوع من الاستجابات باستخدام Regular Expression، ثم:

1. إزالة Markdown الوهمي.
2. استخراج الحالة المناسبة.
3. إنشاء الصورة فعلياً عند الحاجة.
4. إعادة رابط الصورة الحقيقي إلى الواجهة.

ويتم ذلك باستخدام:

```text
FAKE_IMAGE_MARKDOWN_PATTERN
strip_fake_image_markdown()
extract_fake_image_prompt()
```

---

# 📎 قراءة الملفات

يمكن للمستخدم رفع الملفات التالية:

```text
PDF
DOCX
PNG
JPG
JPEG
WEBP
BMP
TXT
MD
```

بعد رفع الملف، يقوم التطبيق باستخراج محتواه وتحويله إلى معلومات قابلة للبحث.

---

# 📄 PDF

يستخدم المشروع:

```text
pypdf
```

لاستخراج النص من صفحات ملفات PDF.

يتم جمع النصوص الموجودة في الصفحات وتحويلها إلى نص واحد قبل تمريرها إلى نظام RAG.

---

# 📝 Word / DOCX

يستخدم المشروع:

```text
python-docx
```

لقراءة ملفات Word.

لا تتم قراءة الفقرات فقط، بل يتم أيضاً استخراج محتوى الجداول الموجودة داخل المستند.

---

# 🖼️ فهم الصور وOCR

واحدة من أهم ميزات المشروع هي أن الصور لا يتم التعامل معها على أنها ملفات غير قابلة للبحث.

يستخدم النظام **مرحلتين لتحليل الصور**.

## 1️⃣ OCR

في البداية يتم استخدام:

```text
Tesseract OCR
```

مع:

```text
ara + eng
```

لدعم النصوص العربية والإنجليزية.

وهذا مناسب للصور التي تحتوي على:

* مستندات
* صفحات كتب
* لقطات شاشة
* ملاحظات
* نصوص مطبوعة
* مستندات ممسوحة ضوئياً

إذا تم العثور على نص كافٍ، يتم استخدامه لبناء قاعدة المعرفة.

---

# 👁️ Vision AI

إذا لم يجد OCR نصاً كافياً، لا يتوقف النظام.

بدلاً من ذلك، يتم إرسال الصورة إلى نموذج رؤية متعدد الوسائط عبر Groq:

```text
qwen/qwen3.6-27b
```

يقوم النموذج بتحليل الصورة ووصف محتواها باللغة العربية.

يمكن أن يتضمن الوصف:

* 👤 الأشخاص
* 📦 الأشياء
* 🏞️ المشهد
* 🎨 الألوان
* 📝 النصوص الموجودة
* 🔎 التفاصيل
* 🧩 السياق العام

ثم يتم تحويل هذا الوصف إلى نص قابل للفهرسة والبحث.

---

# 🔄 دورة تحليل الصورة

```text
                 الصورة
                    │
                    ▼
              Tesseract OCR
                    │
             هل يوجد نص كافٍ؟
              /            \
            نعم             لا
             │               │
             ▼               ▼
        نص OCR          Qwen Vision
             │               │
             └───────┬───────┘
                     ▼
               النص النهائي
                     │
                     ▼
                  Chunks
                     │
                     ▼
                Embeddings
                     │
                     ▼
                   FAISS
```

وهذا يسمح للمستخدم برفع صورة لا تحتوي حتى على نص، مثل صورة منتج أو رسم أو مشهد، ثم طرح أسئلة عنها لاحقاً.

---

# 🧠 RAG — Retrieval-Augmented Generation

يعتمد المشروع على تقنية:

**Retrieval-Augmented Generation**

بدلاً من إرسال السؤال مباشرة إلى النموذج فقط، يبحث التطبيق أولاً داخل قاعدة المعرفة عن المعلومات الأكثر ارتباطاً بالسؤال.

---

# 🔄 كيف يعمل RAG؟

## 1. رفع المستند

يتم استخراج النص من:

```text
PDF
DOCX
TXT
MD
Image
```

---

## 2. تقسيم النص

يتم تنظيف النص وتقسيمه إلى أجزاء صغيرة:

```text
CHUNK_SIZE = 700
CHUNK_OVERLAP = 120
```

يساعد الـOverlap على الحفاظ على السياق بين الأجزاء المتجاورة.

---

## 3. إنشاء Embeddings

يستخدم المشروع نموذج:

```text
sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2
```

من خلال:

```text
Hugging Face Inference Providers
```

حجم الـEmbedding:

```text
384 dimensions
```

وبالتالي يتحول كل Chunk إلى متجه رقمي يمكن البحث عنه.

---

# 🔎 البحث الدلالي

عند سؤال المستخدم، يتم إنشاء Embedding للسؤال.

ثم يتم البحث داخل FAISS عن أقرب النتائج.

الإعداد الحالي:

```text
TOP_K = 4
```

أي يتم استرجاع أقرب 4 أجزاء من قاعدة المعرفة.

## 🎯 حد أدنى للتشابه (Relevance Threshold)

لمنع النظام من اعتبار أي مستند مرفوع "مصدراً" لكل سؤال يُطرح لاحقاً حتى لو لم يكن له علاقة فعلية بالسؤال، تم إضافة حد أدنى لدرجة التشابه:

```text
MIN_SEARCH_SCORE = 0.5
```

أي نتيجة تكون درجة تشابهها الحقيقية (Cosine Similarity) أقل من هذا الحد يتم تجاهلها تماماً ولا تُستخدم كسياق (Context) ولا تظهر ضمن المصادر (Sources) في الإجابة. بهذا الشكل، تظهر المصادر فقط عندما يكون هناك تطابق دلالي حقيقي بين سؤال المستخدم ومحتوى المستند المرفوع.

---

# 📐 Cosine Similarity

يقوم المشروع بتطبيع الـEmbeddings ثم استخدام:

```text
FAISS IndexFlatIP
```

وبسبب تطبيع المتجهات، يصبح الـInner Product مكافئاً عملياً للبحث باستخدام:

```text
Cosine Similarity
```

وهذا يسمح بالعثور على النصوص الأكثر تشابهاً مع سؤال المستخدم من ناحية المعنى، وليس فقط تطابق الكلمات.

---

# 📚 قاعدة المعرفة

يتم تخزين قاعدة المعرفة محلياً باستخدام:

```text
FAISS
```

مع ملف Metadata منفصل.

هيكل التخزين:

```text
storage/
│
├── uploads/
│   └── الملفات المرفوعة
│
├── kb.index
│
└── kb_meta.json
```

### `kb.index`

يحتوي على متجهات FAISS.

### `kb_meta.json`

يحتوي على معلومات مثل:

```json
{
  "doc_id": "...",
  "source": "example.pdf",
  "chunk_no": 0,
  "text": "..."
}
```

---

# 🗑️ إدارة المستندات

يوفر التطبيق API لإدارة قاعدة المعرفة.

### رفع مستند

```text
POST /api/upload
```

### عرض المستندات

```text
GET /api/documents
```

### حذف مستند

```text
DELETE /api/documents/<doc_id>
```

عند حذف مستند، يعيد المشروع بناء فهرس FAISS باستخدام المستندات المتبقية.

---

# 💡 مثال عملي على RAG

إذا رفع المستخدم ملفاً يحتوي على:

```text
Python هي لغة برمجة عالية المستوى...
```

ثم سأل:

```text
ما هي Python؟
```

يقوم النظام بـ:

```text
السؤال
  ↓
Embedding
  ↓
FAISS Search
  ↓
العثور على Chunk المناسب
  ↓
إضافة المصدر إلى Context
  ↓
Gemini LLM
  ↓
الإجابة
```

وبذلك يستطيع النموذج الإجابة باستخدام المعلومات الموجودة في الملف.

---

# ⚠️ RAG ليس Fine-tuning

من المهم التمييز بين RAG وFine-tuning.

هذا المشروع **لا يقوم بتدريب النموذج اللغوي** ولا يغير أوزانه.

RAG يعمل أثناء الاستخدام:

```text
Documents
    ↓
Embeddings
    ↓
Vector Database
    ↓
Retrieval
    ↓
Context
    ↓
LLM
```

وهذا يجعل تحديث المعرفة أسهل بكثير، لأن إضافة ملف جديد لا تتطلب إعادة تدريب النموذج.

---

# 🧠 ذاكرة المحادثة

يستخدم المشروع:

```text
Flask Session
```

للحفاظ على تاريخ المحادثة.

يتم الاحتفاظ بحد أقصى:

```text
20 messages
```

مع الحفاظ على System Prompt الأساسي.

---

# 👩‍💻 هوية Wiam Dev AI

تم تصميم المساعد بحيث يعرف هويته ومطورته.

عند طرح أسئلة مثل:

```text
من برمجك؟
من طورك؟
من صنعك؟
من صاحبة المشروع؟
Who created you?
Who developed you?
Who programmed you?
```

يستطيع النظام التعرف على السؤال وإرجاع:

> **تم تطويري وبرمجتي بواسطة العبقرية Wiam Dev 🧠💜**

يوجد أيضاً نظام مخصص لاكتشاف أسئلة الهوية، بدلاً من الاعتماد على النموذج اللغوي وحده.

---

# 📂 هيكل المشروع

```text
wiam-dev-chatbot/
│
├── main.py                   # تطبيق Flask ومنطق المحادثة والـAPI
├── database.py               # حفظ المحادثات (SQLite / PostgreSQL)
├── rag.py                    # محرك RAG ومعالجة المستندات والصور
│
├── templates/
│   └── index.html            # واجهة المستخدم
│
├── requirements.txt          # مكتبات Python
├── .env.example              # نموذج متغيرات البيئة
├── .gitignore
│
├── Dockerfile                # إعداد Docker
├── Procfile                  # أمر تشغيل Production
├── nixpacks.toml             # إعداد بيئة البناء
│
└── README.md
```

> يتم إنشاء مجلد `storage/` تلقائياً عند الحاجة. يحتوي على الملفات المرفوعة وقاعدة المعرفة، لذلك لا يجب رفعه إلى GitHub.

---

# 🚀 التشغيل محلياً

## المتطلبات

* Python 3.10 أو أحدث
* حساب ومفتاح API من **Google Gemini** (إلزامي: لا يعمل المشروع بدونه)
* حساب ومفتاح API من **Groq** (اختياري: يُجرَّب أولاً في المحادثة، وهو مطلوب أيضاً لتحليل الصور عبر Vision AI)
* حساب ومفتاح API من **OpenRouter** (مزود بديل ثالث واختياري، لمزيد من الاستقرار)
* مفتاح Hugging Face
* Tesseract OCR لدعم قراءة الصور النصية
* اتصال بالإنترنت لتحميل نموذج الـEmbeddings واستخدام APIs

---

# 1️⃣ استنساخ المشروع

```bash
git clone https://github.com/wiam-bahri/wiam-dev-chatbot.git
cd wiam-dev-chatbot
```

---

# 2️⃣ إنشاء Virtual Environment

```bash
python -m venv venv
```

### Windows

```bash
venv\Scripts\activate
```

### macOS / Linux

```bash
source venv/bin/activate
```

ثم:

```bash
pip install -r requirements.txt
```

---

# 3️⃣ إعداد Environment Variables

انسخ:

```text
.env.example
```

إلى:

```text
.env
```

### Windows

```powershell
copy .env.example .env
```

### macOS / Linux

```bash
cp .env.example .env
```

ثم أضف:

```env
GEMINI_API_KEY=your_gemini_api_key
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxx
OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxx
HF_API_KEY=hf_xxxxxxxxxxxxxxxxx
FLASK_SECRET_KEY=your_random_secret_key
```

> `GEMINI_API_KEY` **إلزامي**: بدونه يتوقف التطبيق عند التشغيل.
> `GROQ_API_KEY` **اختياري**: يُجرَّب أولاً في المحادثة، وهو مطلوب أيضاً لتحليل الصور (Vision AI) داخل `rag.py`.
> `OPENROUTER_API_KEY` **اختياري**: الطبقة الأخيرة عند فشل Groq وGemini معاً.
> `HF_API_KEY` مطلوب للـEmbeddings (RAG)، ويُستخدم أيضاً كمزود احتياطي لتوليد الصور.

### متغيرات اختيارية إضافية

```env
POLLINATIONS_API_KEY=        # من enter.pollinations.ai لتجنب ازدحام الطبقة المجانية
POLLINATIONS_BASE_URL=       # لتغيير عنوان خدمة Pollinations إن تغيّر
IMAGE_PROVIDERS=pollinations,huggingface   # ترتيب مزودي الصور
HF_IMAGE_MODEL=black-forest-labs/FLUX.1-schnell
ADMIN_PASSWORD=              # لفتح لوحة /admin
DATABASE_URL=                # PostgreSQL (إن تُرك فارغاً يُستخدم SQLite)
STORAGE_PATH=                # مسار تخزين دائم (Volume على Railway)
```

---

# 🔐 إنشاء Flask Secret Key

يمكن إنشاء مفتاح عشوائي باستخدام:

```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

ثم وضع الناتج في:

```env
FLASK_SECRET_KEY=...
```

---

# 4️⃣ تشغيل المشروع

```bash
python main.py
```

ثم افتح:

```text
http://localhost:5000
```

🎉 أصبح Wiam Dev ChatBot جاهزاً للاستخدام.

---

# 🖥️ Tesseract OCR

لتحليل النصوص الموجودة داخل الصور، يجب تثبيت Tesseract OCR.

يستخدم المشروع اللغتين:

```text
Arabic
English
```

ويتم استدعاؤه من Python عبر:

```text
pytesseract
```

إذا تعذر تشغيل OCR، يحاول النظام استخدام Vision AI لتحليل الصورة بدلاً من إيقاف عملية الرفع بالكامل.

---

# 🐳 تشغيل المشروع باستخدام Docker

يحتوي المشروع على:

```text
Dockerfile
```

لتسهيل تشغيل التطبيق في بيئة Docker.

بناء الصورة:

```bash
docker build -t wiam-dev-chatbot .
```

تشغيل التطبيق:

```bash
docker run -p 5000:5000 \
  -e GEMINI_API_KEY="your_gemini_api_key" \
  -e GROQ_API_KEY="your_groq_api_key" \
  -e OPENROUTER_API_KEY="your_openrouter_api_key" \
  -e HF_API_KEY="your_huggingface_key" \
  -e FLASK_SECRET_KEY="your_secret_key" \
  wiam-dev-chatbot
```

ثم:

```text
http://localhost:5000
```

---

# 🌍 Production Deployment

في بيئة الإنتاج، يفضل عدم استخدام:

```bash
python main.py
```

بدلاً من ذلك يمكن استخدام Gunicorn:

```bash
gunicorn main:app -b 0.0.0.0:8000 --timeout 120 --workers 1 --threads 4
```

يفضل Worker واحد مع عدة Threads: كل Worker يحمل مكونات RAG في الذاكرة، وتوليد الصورة يحجز الطلب عدة ثوانٍ، فالـThreads تمنع توقف باقي المستخدمين.

---

# 🚂 Railway

المشروع مجهز للنشر على Railway باستخدام (الأمر الفعلي: `gunicorn main:app --timeout 120 --workers 1 --threads 4`):

```text
Procfile
nixpacks.toml
Dockerfile
```

يجب إضافة Environment Variables من لوحة Railway:

```text
GEMINI_API_KEY
GROQ_API_KEY
OPENROUTER_API_KEY
HF_API_KEY
FLASK_SECRET_KEY
ADMIN_PASSWORD            (اختياري)
STORAGE_PATH              (اختياري: مسار Volume دائم)
```

ولا يجب رفع ملف `.env`.

> ⚠️ ملاحظة مهمة حول التخزين: عند تشغيل المشروع على Railway، يستخدم التطبيق `/tmp/storage` للتخزين. هذا النوع من التخزين قد يكون مؤقتاً، لذلك لا ينبغي اعتباره تخزيناً دائماً لبيانات المستخدم في بيئة إنتاجية طويلة المدى.

للاستخدام الإنتاجي الحقيقي، يمكن مستقبلاً نقل الملفات وقاعدة المعرفة إلى خدمة تخزين دائمة أو Object Storage.

---

# ☁️ منصات نشر مقترحة

| المنصة         | الملاحظات                      |
| -------------- | ------------------------------ |
| Railway        | مناسبة للمشروع وسهلة الإعداد   |
| Render         | مناسبة للتجارب والنشر البسيط   |
| VPS            | تحكم كامل في البيئة والتخزين   |
| Docker Hosting | مناسب للبيئات التي تدعم Docker |

> ❌ لا يُنصح باستخدام Vercel لهذا المشروع تحديداً بصورته الحالية، لأنه يعتمد على Flask وFAISS وتخزين الملفات وعمليات RAG تحتاج إلى بيئة تشغيل وخدمات تخزين مناسبة.

---

# 🔐 ملاحظات الأمان

* لا تضع `GEMINI_API_KEY` داخل الكود.
* لا تضع `GROQ_API_KEY` داخل الكود.
* لا تضع `OPENROUTER_API_KEY` داخل الكود.
* لا تضع `HF_API_KEY` داخل الكود.
* لا ترفع `.env` إلى GitHub.
* استخدم Environment Variables في Production.
* إذا تم تسريب API Key في أي وقت، قم بإلغائه وإنشاء مفتاح جديد.
* اجعل `FLASK_SECRET_KEY` عشوائياً وطويلاً.
* لا تشارك مفاتيح API مع الآخرين.
* الملفات المرفوعة قد تحتوي على بيانات خاصة، لذلك يجب التعامل مع مجلد `storage/` بحذر.

---

# 🔌 API Endpoints

يوفر المشروع مجموعة من endpoints:

| Endpoint                  | Method | الوظيفة                 |
| ------------------------- | ------ | ----------------------- |
| `/`                       | GET    | الصفحة الرئيسية         |
| `/api/chat`               | POST   | إرسال رسالة إلى المساعد |
| `/api/generate-image`     | POST   | توليد صورة              |
| `/api/upload`             | POST   | رفع مستند               |
| `/api/documents`          | GET    | عرض المستندات           |
| `/api/documents/<doc_id>` | DELETE | حذف مستند               |
| `/api/reset`              | POST   | بدء محادثة جديدة        |
| `/generated/<file>`       | GET    | عرض صورة مولّدة         |
| `/admin`                  | GET    | لوحة الإدارة (تحتاج `ADMIN_PASSWORD`) |

---

# 🧩 المكونات الرئيسية

## `main.py`

مسؤول عن:

* Flask
* API Routes
* المحادثة
* Session
* نظام Fallback متعدد المزودين (Groq / Gemini / OpenRouter)
* Tool Calling
* Image Generation
* إدارة المستندات
* Identity Detection

---

## `rag.py`

مسؤول عن:

* استخراج النصوص
* قراءة PDF
* قراءة DOCX
* OCR
* Vision AI
* إنشاء Embeddings
* Chunking
* FAISS
* البحث الدلالي
* إدارة المستندات
* حفظ واستعادة قاعدة المعرفة

---

# 🗺️ تحسينات مستقبلية ممكنة

يمكن تطوير المشروع مستقبلاً بإضافة:

* [ ] قاعدة معرفة منفصلة لكل مستخدم
* [ ] تسجيل دخول وحسابات مستخدمين
* [ ] حفظ المحادثات بشكل دائم باستخدام SQLite/PostgreSQL
* [ ] تخزين دائم للملفات باستخدام Object Storage
* [ ] تحسين نظام RAG باستخدام Re-ranking
* [ ] دعم المزيد من أنواع الملفات
* [ ] تحسين إدارة المستندات
* [ ] خيارات متقدمة لتوليد الصور
* [ ] التحكم في أبعاد الصور
* [ ] اختيار أسلوب الصورة
* [ ] تحسين نظام الصلاحيات
* [ ] واجهة متقدمة لإدارة قاعدة المعرفة
* [ ] Streaming للإجابات
* [ ] دعم نماذج ذكاء اصطناعي إضافية
* [ ] لوحة مراقبة لعرض إحصائيات استخدام كل مزود ذكاء اصطناعي (Groq/Gemini/OpenRouter)

---

# 📊 ملخص المعمارية

```text
                         Wiam Dev ChatBot
                                │
             ┌──────────────────┼──────────────────┐
             ▼                  ▼                  ▼
          Chat AI            RAG System       Image Generation
             │                  │                  │
             ▼                  ▼                  ▼
   Groq → Gemini →         Hugging Face       Tool Calling
     OpenRouter                 │                  │
                                ▼                  ▼
                              FAISS        Pollinations → HF FLUX
                                ▲
                          ┌─────┴─────┐
                          ▼           ▼
                         OCR      Vision AI
                     Tesseract   Qwen via Groq
```

---

# 📄 الترخيص

هذا المشروع مرخّص بموجب:

**MIT License**

يمكن استخدام المشروع وتعديله وتطويره وفق شروط رخصة MIT.

---

# 🙋‍♀️ المطوّرة

**Wiam Dev**

تم تصميم وتطوير هذا المشروع بهدف بناء تطبيق عملي للذكاء الاصطناعي يجمع بين:

* Large Language Models
* Retrieval-Augmented Generation
* Vector Search
* Computer Vision
* OCR
* Image Generation
* Web Development

المشروع يمثل تجربة تعليمية وعملية في بناء تطبيقات ذكاء اصطناعي باستخدام **Python وFlask وGoogle Gemini وGroq وHugging Face وFAISS**.

---

# ⭐ إذا أعجبك المشروع

إذا وجدت المشروع مفيداً أو أعجبتك فكرته، يمكنك دعم المشروع عبر:

⭐ إعطائه Star على GitHub

🐛 الإبلاغ عن الأخطاء

💡 اقتراح تحسينات

🤝 المساهمة في تطويره

---

## 💜 Built with Python & Curiosity

**Wiam Dev 🧠💜**
