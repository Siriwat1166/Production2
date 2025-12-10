-- ============================================================
-- SQL Script: เพิ่มหน่วยบรรจุในตาราง Units
-- วันที่: 2025-12-10
-- คำอธิบาย: เพิ่มหน่วยบรรจุ (CAN, DRUM, PAIL, ฯลฯ) สำหรับใช้กับ package_unit_id
-- ============================================================

PRINT '============================================================'
PRINT 'เริ่มเพิ่มหน่วยบรรจุในตาราง Units...'
PRINT '============================================================'
PRINT ''

-- ตรวจสอบว่าตาราง Units มีคอลัมน์ที่จำเป็นหรือไม่
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Units') AND name = 'unit_code')
BEGIN
    PRINT '❌ ERROR: ตาราง Units ไม่มีคอลัมน์ unit_code'
    PRINT 'กรุณาตรวจสอบโครงสร้างตาราง Units'
    RETURN
END

-- เพิ่มหน่วยบรรจุทีละรายการ
DECLARE @count INT = 0

-- 1. CAN (กระป๋อง)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'CAN')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('CAN', 'Can', 'กระป๋อง', 'can', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: CAN (กระป๋อง)'
    SET @count = @count + 1
END
ELSE PRINT '  - CAN มีอยู่แล้ว'

-- 2. DRUM (ถัง)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'DRUM')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('DRUM', 'Drum', 'ถัง', 'drum', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: DRUM (ถัง)'
    SET @count = @count + 1
END
ELSE PRINT '  - DRUM มีอยู่แล้ว'

-- 3. PAIL (ถังเล็ก)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'PAIL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('PAIL', 'Pail', 'ถังเล็ก', 'pail', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: PAIL (ถังเล็ก)'
    SET @count = @count + 1
END
ELSE PRINT '  - PAIL มีอยู่แล้ว'

-- 4. BUCKET (ถังพลาสติก)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BUCKET')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BUCKET', 'Bucket', 'ถังพลาสติก', 'bucket', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: BUCKET (ถังพลาสติก)'
    SET @count = @count + 1
END
ELSE PRINT '  - BUCKET มีอยู่แล้ว'

-- 5. CARTON (กล่องกระดาษ)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'CARTON')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('CARTON', 'Carton', 'กล่องกระดาษ', 'carton', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: CARTON (กล่องกระดาษ)'
    SET @count = @count + 1
END
ELSE PRINT '  - CARTON มีอยู่แล้ว'

-- 6. BOX (กล่อง)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BOX')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BOX', 'Box', 'กล่อง', 'box', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: BOX (กล่อง)'
    SET @count = @count + 1
END
ELSE PRINT '  - BOX มีอยู่แล้ว'

-- 7. ROLL (ม้วน)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'ROLL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('ROLL', 'Roll', 'ม้วน', 'roll', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: ROLL (ม้วน)'
    SET @count = @count + 1
END
ELSE PRINT '  - ROLL มีอยู่แล้ว'

-- 8. REEL (รีล)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'REEL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('REEL', 'Reel', 'รีล', 'reel', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: REEL (รีล)'
    SET @count = @count + 1
END
ELSE PRINT '  - REEL มีอยู่แล้ว'

-- 9. SPOOL (ม้วนลวด)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'SPOOL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('SPOOL', 'Spool', 'ม้วนลวด', 'spool', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: SPOOL (ม้วนลวด)'
    SET @count = @count + 1
END
ELSE PRINT '  - SPOOL มีอยู่แล้ว'

-- 10. BAG (ถุง)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BAG')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BAG', 'Bag', 'ถุง', 'bag', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: BAG (ถุง)'
    SET @count = @count + 1
END
ELSE PRINT '  - BAG มีอยู่แล้ว'

-- 11. SACK (กระสอบ)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'SACK')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('SACK', 'Sack', 'กระสอบ', 'sack', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: SACK (กระสอบ)'
    SET @count = @count + 1
END
ELSE PRINT '  - SACK มีอยู่แล้ว'

-- 12. BUNDLE (มัด)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BUNDLE')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BUNDLE', 'Bundle', 'มัด', 'bundle', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: BUNDLE (มัด)'
    SET @count = @count + 1
END
ELSE PRINT '  - BUNDLE มีอยู่แล้ว'

-- 13. PACK (แพ็ค)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'PACK')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('PACK', 'Pack', 'แพ็ค', 'pack', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: PACK (แพ็ค)'
    SET @count = @count + 1
END
ELSE PRINT '  - PACK มีอยู่แล้ว'

-- 14. BOTTLE (ขวด)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BOTTLE')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BOTTLE', 'Bottle', 'ขวด', 'bottle', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย: BOTTLE (ขวด)'
    SET @count = @count + 1
END
ELSE PRINT '  - BOTTLE มีอยู่แล้ว'

PRINT ''
PRINT '============================================================'
PRINT 'เสร็จสมบูรณ์!'
PRINT '============================================================'
PRINT ''
PRINT CONCAT('เพิ่มหน่วยบรรจุใหม่: ', @count, ' หน่วย')
PRINT ''

-- แสดงหน่วยบรรจุทั้งหมด
PRINT 'หน่วยบรรจุที่มีในระบบ:'
SELECT
    unit_id,
    unit_code,
    unit_name,
    unit_name_th,
    unit_symbol,
    CASE WHEN is_active = 1 THEN 'Active' ELSE 'Inactive' END AS [Status]
FROM Units
WHERE unit_code IN ('CAN', 'DRUM', 'PAIL', 'BUCKET', 'CARTON', 'BOX', 'ROLL', 'REEL', 'SPOOL', 'BAG', 'SACK', 'BUNDLE', 'PACK', 'BOTTLE')
ORDER BY unit_name

PRINT ''
PRINT 'หน่วยบรรจุที่เพิ่มเข้ามาสามารถใช้กับ package_unit_id ใน PO_Items ได้แล้ว'
PRINT ''
