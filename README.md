# Face Mesh — MediaPipe Tasks (Workshop 2)

เว็บแอปตัวอย่างสำหรับตรวจจับ **ใบหน้าแบบเรียลไทม์ (Face Landmark Detection)** ผ่านกล้องเว็บแคม โดยใช้ [MediaPipe Tasks Vision](https://developers.google.com/mediapipe/solutions/vision/face_landmarker) ฝั่ง Frontend (JavaScript) ร่วมกับ [Flask](https://flask.palletsprojects.com/) เป็นเว็บเซิร์ฟเวอร์ฝั่ง Backend

> โปรเจกต์นี้เป็นส่วนหนึ่งของวิชา DT-508 Workshop สัปดาห์ที่ 5 (W5)

---

## ✨ ฟีเจอร์หลัก

- ตรวจจับใบหน้าและจุด Landmark บนใบหน้า (สูงสุด 478 จุด) แบบเรียลไทม์จากกล้องเว็บแคมของเครื่อง
- แสดงผลลัพธ์ทับบนวิดีโอผ่าน `<canvas>` โดยไม่ต้องอัปโหลดวิดีโอขึ้นเซิร์ฟเวอร์ (ประมวลผลทั้งหมดที่ฝั่ง Browser)
- เปิด/ปิดการแสดงผลแต่ละเลเยอร์ได้อิสระผ่านปุ่มบนหน้าเว็บ:
  - **Mesh** — เส้นตาข่ายใบหน้าทั้งหมด (Face Tesselation)
  - **Eyes** — ดวงตาและคิ้วทั้งสองข้าง
  - **Lips** — ริมฝีปาก
  - **Oval** — เส้นขอบวงหน้า (Face Oval)
  - **Labels** — ป้ายกำกับตำแหน่งสำคัญ (ตา, จมูก, ปาก)
- แสดงสถานะการทำงานแบบเรียลไทม์: จำนวนใบหน้าที่พบ, จำนวนจุด Landmark, และสถานะปัจจุบัน

> หมายเหตุ: โฟลเดอร์ `static/models/` มีโมเดลของ Hand Landmarker และ Pose Landmarker เตรียมไว้ให้แล้ว แต่ในโค้ดปัจจุบัน (`static/face.js`) ยังเปิดใช้งานเฉพาะ **Face Landmarker** เท่านั้น สามารถต่อยอดเพิ่มการตรวจจับมือ/ท่าทางร่างกายได้ในอนาคต

---

## 🧱 สถาปัตยกรรมและการทำงาน

```
Browser (Client)                                               Flask Server
┌─────────────────────────────────────────────┐           ┌────────────────────┐
│ templates/index.html                        │◀──GET /───│  main.py           │
│  └─ static/face.js (module)                 │           │  (render_template) │
│      ├─ เปิดกล้อง (getUserMedia)              │           └────────────────────┘
│      ├─ โหลด MediaPipe Tasks-Vision (CDN)   │ 
│      ├─ โหลดโมเดล .task จาก /static/models/ │
│      └─ วาดผล Landmark ลงบน <canvas> ทุกเฟรม │
└─────────────────────────────────────────────┘
```

- **Backend (`main.py`)**: Flask ทำหน้าที่เพียง serve หน้า `templates/index.html` และไฟล์ static (JS/โมเดล) เท่านั้น ไม่มีการประมวลผลภาพที่ฝั่งเซิร์ฟเวอร์
- **Frontend (`static/face.js`)**:
  1. โหลดไลบรารี `@mediapipe/tasks-vision` จาก CDN (jsDelivr)
  2. สร้าง `FaceLandmarker` โดยโหลดโมเดลจาก `/static/models/face_landmarker.task` (รันด้วย GPU delegate)
  3. ขอสิทธิ์กล้องผ่าน `navigator.mediaDevices.getUserMedia`
  4. วนลูปด้วย `requestAnimationFrame` เพื่อตรวจจับใบหน้าทุกเฟรม (`detectForVideo`) แล้ววาดผลลง canvas
- **Template (`templates/index.html`)**: หน้า UI ที่ใช้ Bootstrap 5 (จาก CDN) สำหรับปุ่มควบคุมเลเยอร์และการ์ดแสดงสถานะ

---

## 📂 โครงสร้างโปรเจกต์

```
workshop-2/
├── main.py                      # Flask entry point
├── pyproject.toml                # ข้อมูลโปรเจกต์และ dependencies (ใช้กับ uv)
├── uv.lock                       # ล็อกเวอร์ชัน dependencies
├── templates/
│   └── index.html                # หน้าเว็บหลัก (UI)
├── static/
│   ├── face.js                   # โลจิกตรวจจับใบหน้าฝั่ง Client
│   └── models/
│       ├── face_landmarker.task  # โมเดล Face Landmarker (ใช้งานอยู่)
│       ├── hand_landmarker.task  # โมเดล Hand Landmarker (ยังไม่ได้ใช้ในโค้ด)
│       └── pose_landmarker.task  # โมเดล Pose Landmarker (ยังไม่ได้ใช้ในโค้ด)
└── README.md
```

---

## ✅ ความต้องการของระบบ (Prerequisites)

- Python **3.14** ขึ้นไป (กำหนดใน `pyproject.toml` และ `.python-version`)
- ตัวจัดการแพ็กเกจ [uv](https://docs.astral.sh/uv/) (แนะนำ) หรือ `pip` ทั่วไป
- เว็บเบราว์เซอร์ที่รองรับ WebRTC/`getUserMedia` (เช่น Chrome, Edge, Firefox เวอร์ชันล่าสุด)
- กล้องเว็บแคมที่ใช้งานได้ และอนุญาตสิทธิ์การเข้าถึงกล้องให้เบราว์เซอร์
- การเชื่อมต่ออินเทอร์เน็ต (เพื่อโหลด Bootstrap และไลบรารี MediaPipe Tasks-Vision จาก CDN)

---

## 🚀 การติดตั้งและรันโปรเจกต์

### วิธีที่ 1: ใช้ `uv` (แนะนำ)

```bash
# 1) ติดตั้ง dependencies ตามที่ล็อกไว้ใน uv.lock
uv sync

# 2) รันเซิร์ฟเวอร์
uv run main.py
```

### วิธีที่ 2: ใช้ `pip` แบบทั่วไป

```bash
# 1) สร้างและเปิดใช้งาน virtual environment
python -m venv .venv
source .venv/bin/activate      # macOS/Linux
# .venv\Scripts\activate       # Windows

# 2) ติดตั้ง dependencies
pip install flask mediapipe opencv-python

# 3) รันเซิร์ฟเวอร์
python main.py
```

หลังจากรันสำเร็จ ระบบจะแสดงข้อความประมาณนี้ในเทอร์มินัล:

```
 * Running on http://127.0.0.1:5000
 * Debug mode: on
```

จากนั้นเปิดเบราว์เซอร์ไปที่ **http://127.0.0.1:5000** แล้วอนุญาตให้เว็บไซต์เข้าถึงกล้องของเครื่อง

---

## 🕹️ วิธีใช้งานหน้าเว็บ

1. เมื่อเปิดหน้าเว็บ ระบบจะขึ้นข้อความ "กำลังโหลดโมเดล..." พร้อมขอสิทธิ์เข้าถึงกล้อง
2. เมื่อโหลดเสร็จ กล้องจะเปิดและเริ่มตรวจจับใบหน้าโดยอัตโนมัติ
3. ใช้ปุ่มด้านบนเพื่อเปิด/ปิดการแสดงผลแต่ละเลเยอร์ (Mesh, Eyes, Lips, Oval, Labels) ได้ตามต้องการ
4. ข้อมูลสถานะด้านล่าง (จำนวนใบหน้าที่พบ, จำนวน Landmark Points, สถานะการทำงาน) จะอัปเดตแบบเรียลไทม์

---

## ⚙️ Dependencies หลัก

| แพ็กเกจ                          | หน้าที่                                              |
| -------------------------------- | ----------------------------------------------------- |
| `flask`                          | เว็บเซิร์ฟเวอร์สำหรับ serve หน้า HTML และไฟล์ static |
| `mediapipe`                      | ใช้เตรียม/ทดสอบโมเดล (ฝั่ง Python)                    |
| `opencv-python`                  | ประมวลผลภาพ (ฝั่ง Python หากมีการต่อยอด)             |
| `@mediapipe/tasks-vision` (CDN)  | Library หลักที่ใช้ตรวจจับ Landmark ฝั่ง Browser       |
| `bootstrap` (CDN)                | จัดหน้าตา UI                                          |

> หมายเหตุ: `mediapipe` และ `opencv-python` ที่ระบุใน `pyproject.toml` เป็น dependency ฝั่ง Python ซึ่งปัจจุบัน `main.py` ยังไม่ได้เรียกใช้งานโดยตรง (การตรวจจับทั้งหมดทำที่ฝั่ง Browser ผ่าน CDN) — เตรียมไว้สำหรับกรณีต้องการประมวลผลฝั่งเซิร์ฟเวอร์ในอนาคต

---

## 🧩 แนวทางต่อยอด (Ideas for Extension)

- เพิ่มการตรวจจับมือด้วย `hand_landmarker.task` ที่เตรียมไว้ใน `static/models/` โดยสร้างไฟล์ JS ใหม่ (เช่น `static/hand.js`) และใช้ `HandLandmarker` จาก `@mediapipe/tasks-vision`
- เพิ่มการตรวจจับท่าทางร่างกายด้วย `pose_landmarker.task` ผ่าน `PoseLandmarker`
- เพิ่มปุ่มสลับโหมดระหว่าง Face / Hand / Pose บนหน้าเว็บเดียวกัน
- บันทึกภาพ/วิดีโอผลลัพธ์ หรือส่งข้อมูล Landmark ไปประมวลผลต่อที่ฝั่งเซิร์ฟเวอร์ผ่าน API endpoint ใน `main.py`

---

## 🛠️ การแก้ปัญหาเบื้องต้น (Troubleshooting)

- **กล้องไม่เปิด / ขึ้น error สิทธิ์การเข้าถึง**: ตรวจสอบว่าอนุญาต Permission กล้องให้เบราว์เซอร์ และไม่มีแอปอื่นใช้งานกล้องอยู่
- **ค้างที่ "กำลังโหลดโมเดล..."**: ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต เนื่องจากต้องโหลดไลบรารีและไฟล์ wasm จาก CDN (jsDelivr)
- **หน้าเว็บช้า/กระตุก**: ลองปิดบางเลเยอร์ (เช่น Mesh) เพื่อลดภาระการวาดผล หรือตรวจสอบว่าเบราว์เซอร์รองรับ GPU delegate
- **พอร์ต 5000 ถูกใช้งานอยู่แล้ว**: แก้ไขใน `main.py` โดยระบุพอร์ตใหม่ เช่น `app.run(debug=True, port=5001)`

---

## 📄 License

โปรเจกต์นี้เผยแพร่ภายใต้ [MIT License](LICENSE)
