-- ============================================================
-- Database Migration: เพิ่มฟิลด์รองรับหน่วยบรรจุ (Package Units)
-- วันที่: 2025-12-10
-- คำอธิบาย: เพิ่มความสามารถในการบันทึกข้อมูลหน่วยบรรจุในใบสั่งซื้อ
--           เช่น 5 กระป๋อง กระป๋องละ 2 กิโล รวม 10 กิโล
-- ============================================================

-- ============================================================
-- STEP 1: เพิ่มหน่วยบรรจุใหม่ในตาราง Units
-- ============================================================

PRINT 'STEP 1: เพิ่มหน่วยบรรจุใหม่ในตาราง Units...'

-- ตรวจสอบว่ามีหน่วยอยู่แล้วหรือไม่ (ถ้ามีแล้วจะไม่ INSERT ซ้ำ)
IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'CAN')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('CAN', 'Can', 'กระป๋อง', 'can', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย CAN (กระป๋อง)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'DRUM')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('DRUM', 'Drum', 'ถัง', 'drum', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย DRUM (ถัง)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'PAIL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('PAIL', 'Pail', 'ถังเล็ก', 'pail', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย PAIL (ถังเล็ก)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BUCKET')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BUCKET', 'Bucket', 'ถังพลาสติก', 'bucket', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย BUCKET (ถังพลาสติก)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'CARTON')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('CARTON', 'Carton', 'กล่องกระดาษ', 'carton', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย CARTON (กล่องกระดาษ)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BOX')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BOX', 'Box', 'กล่อง', 'box', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย BOX (กล่อง)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'ROLL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('ROLL', 'Roll', 'ม้วน', 'roll', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย ROLL (ม้วน)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'REEL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('REEL', 'Reel', 'รีล', 'reel', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย REEL (รีล)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'SPOOL')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('SPOOL', 'Spool', 'ม้วนลวด', 'spool', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย SPOOL (ม้วนลวด)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BAG')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BAG', 'Bag', 'ถุง', 'bag', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย BAG (ถุง)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'SACK')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('SACK', 'Sack', 'กระสอบ', 'sack', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย SACK (กระสอบ)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BUNDLE')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BUNDLE', 'Bundle', 'มัด', 'bundle', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย BUNDLE (มัด)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'PACK')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('PACK', 'Pack', 'แพ็ค', 'pack', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย PACK (แพ็ค)'
END

IF NOT EXISTS (SELECT 1 FROM Units WHERE unit_code = 'BOTTLE')
BEGIN
    INSERT INTO Units (unit_code, unit_name, unit_name_th, unit_symbol, is_active, created_at)
    VALUES ('BOTTLE', 'Bottle', 'ขวด', 'bottle', 1, GETDATE())
    PRINT '  ✓ เพิ่มหน่วย BOTTLE (ขวด)'
END

PRINT 'STEP 1: เสร็จสิ้น - เพิ่มหน่วยบรรจุใหม่แล้ว'
PRINT ''

-- ============================================================
-- STEP 2: เพิ่มคอลัมน์ใหม่ในตาราง PO_Items
-- ============================================================

PRINT 'STEP 2: เพิ่มคอลัมน์ใหม่ในตาราง PO_Items...'

-- ตรวจสอบว่าคอลัมน์มีอยู่แล้วหรือไม่
IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('PO_Items')
               AND name = 'package_qty')
BEGIN
    ALTER TABLE PO_Items ADD package_qty DECIMAL(18,3) NULL
    PRINT '  ✓ เพิ่มคอลัมน์ package_qty (จำนวนหน่วยบรรจุ)'
END
ELSE
BEGIN
    PRINT '  - คอลัมน์ package_qty มีอยู่แล้ว'
END

IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('PO_Items')
               AND name = 'package_unit_id')
BEGIN
    ALTER TABLE PO_Items ADD package_unit_id INT NULL
    PRINT '  ✓ เพิ่มคอลัมน์ package_unit_id (FK -> Units)'
END
ELSE
BEGIN
    PRINT '  - คอลัมน์ package_unit_id มีอยู่แล้ว'
END

IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('PO_Items')
               AND name = 'qty_per_package')
BEGIN
    ALTER TABLE PO_Items ADD qty_per_package DECIMAL(18,3) NULL
    PRINT '  ✓ เพิ่มคอลัมน์ qty_per_package (ปริมาณต่อหน่วยบรรจุ)'
END
ELSE
BEGIN
    PRINT '  - คอลัมน์ qty_per_package มีอยู่แล้ว'
END

PRINT 'STEP 2: เสร็จสิ้น - เพิ่มคอลัมน์ใหม่แล้ว'
PRINT ''

-- ============================================================
-- STEP 3: เพิ่ม Foreign Key Constraint (Optional)
-- ============================================================

PRINT 'STEP 3: เพิ่ม Foreign Key Constraint...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
               WHERE name = 'FK_PO_Items_PackageUnit')
BEGIN
    ALTER TABLE PO_Items
    ADD CONSTRAINT FK_PO_Items_PackageUnit
    FOREIGN KEY (package_unit_id) REFERENCES Units(unit_id)
    PRINT '  ✓ เพิ่ม Foreign Key: FK_PO_Items_PackageUnit'
END
ELSE
BEGIN
    PRINT '  - Foreign Key FK_PO_Items_PackageUnit มีอยู่แล้ว'
END

PRINT 'STEP 3: เสร็จสิ้น'
PRINT ''

-- ============================================================
-- STEP 4: เพิ่ม Extended Properties (คำอธิบายคอลัมน์)
-- ============================================================

PRINT 'STEP 4: เพิ่มคำอธิบายคอลัมน์...'

-- package_qty
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE major_id = OBJECT_ID('PO_Items')
               AND name = 'MS_Description'
               AND minor_id = (SELECT column_id FROM sys.columns
                              WHERE object_id = OBJECT_ID('PO_Items')
                              AND name = 'package_qty'))
BEGIN
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'จำนวนหน่วยบรรจุ (เช่น 5 กระป๋อง, 10 ถัง, 20 ม้วน)',
        @level0type = N'SCHEMA', @level0name = N'dbo',
        @level1type = N'TABLE',  @level1name = N'PO_Items',
        @level2type = N'COLUMN', @level2name = N'package_qty'
    PRINT '  ✓ เพิ่มคำอธิบาย package_qty'
END

-- package_unit_id
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE major_id = OBJECT_ID('PO_Items')
               AND name = 'MS_Description'
               AND minor_id = (SELECT column_id FROM sys.columns
                              WHERE object_id = OBJECT_ID('PO_Items')
                              AND name = 'package_unit_id'))
BEGIN
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'หน่วยบรรจุ (FK -> Units: CAN, DRUM, PAIL, CARTON, BOX, ROLL, etc.)',
        @level0type = N'SCHEMA', @level0name = N'dbo',
        @level1type = N'TABLE',  @level1name = N'PO_Items',
        @level2type = N'COLUMN', @level2name = N'package_unit_id'
    PRINT '  ✓ เพิ่มคำอธิบาย package_unit_id'
END

-- qty_per_package
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties
               WHERE major_id = OBJECT_ID('PO_Items')
               AND name = 'MS_Description'
               AND minor_id = (SELECT column_id FROM sys.columns
                              WHERE object_id = OBJECT_ID('PO_Items')
                              AND name = 'qty_per_package'))
BEGIN
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'ปริมาณต่อหน่วยบรรจุ (เช่น 2 กิโล/กระป๋อง, 200 ลิตร/ถัง)',
        @level0type = N'SCHEMA', @level0name = N'dbo',
        @level1type = N'TABLE',  @level1name = N'PO_Items',
        @level2type = N'COLUMN', @level2name = N'qty_per_package'
    PRINT '  ✓ เพิ่มคำอธิบาย qty_per_package'
END

PRINT 'STEP 4: เสร็จสิ้น'
PRINT ''

-- ============================================================
-- STEP 5: ตรวจสอบผลลัพธ์
-- ============================================================

PRINT 'STEP 5: ตรวจสอบผลลัพธ์...'
PRINT ''

-- แสดงหน่วยบรรจุที่เพิ่มเข้ามา
PRINT '=== หน่วยบรรจุที่มีในระบบ ==='
SELECT unit_id, unit_code, unit_name, unit_name_th, unit_symbol, is_active
FROM Units
WHERE unit_code IN ('CAN', 'DRUM', 'PAIL', 'BUCKET', 'CARTON', 'BOX', 'ROLL', 'REEL', 'SPOOL', 'BAG', 'SACK', 'BUNDLE', 'PACK', 'BOTTLE')
ORDER BY unit_name
PRINT ''

-- แสดงโครงสร้างตาราง PO_Items (เฉพาะคอลัมน์ใหม่)
PRINT '=== คอลัมน์ใหม่ในตาราง PO_Items ==='
SELECT
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.precision AS Precision,
    c.scale AS Scale,
    c.is_nullable AS IsNullable,
    ISNULL(ep.value, '') AS Description
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.extended_properties ep
    ON ep.major_id = c.object_id
    AND ep.minor_id = c.column_id
    AND ep.name = 'MS_Description'
WHERE c.object_id = OBJECT_ID('PO_Items')
AND c.name IN ('package_qty', 'package_unit_id', 'qty_per_package')
ORDER BY c.column_id
PRINT ''

PRINT '============================================================'
PRINT 'Migration เสร็จสมบูรณ์!'
PRINT '============================================================'
PRINT ''
PRINT 'ขั้นตอนถัดไป:'
PRINT '1. แก้ไขไฟล์ create.php เพื่อรองรับการกรอกข้อมูลหน่วยบรรจุ'
PRINT '2. แก้ไขไฟล์ receiving_po.php เพื่อแสดงข้อมูลหน่วยบรรจุ'
PRINT '3. ทดสอบการสร้าง PO ใหม่พร้อมข้อมูลหน่วยบรรจุ'
PRINT '4. ทดสอบการรับของเข้าคลัง'
PRINT ''

-- ============================================================
-- ROLLBACK (ใช้เมื่อต้องการย้อนกลับ - ระวัง!)
-- ============================================================
/*
PRINT 'ROLLBACK: ลบการเปลี่ยนแปลง...'

-- ลบ Foreign Key
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_PO_Items_PackageUnit')
BEGIN
    ALTER TABLE PO_Items DROP CONSTRAINT FK_PO_Items_PackageUnit
    PRINT '  ✓ ลบ Foreign Key: FK_PO_Items_PackageUnit'
END

-- ลบคอลัมน์
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PO_Items') AND name = 'package_qty')
BEGIN
    ALTER TABLE PO_Items DROP COLUMN package_qty
    PRINT '  ✓ ลบคอลัมน์ package_qty'
END

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PO_Items') AND name = 'package_unit_id')
BEGIN
    ALTER TABLE PO_Items DROP COLUMN package_unit_id
    PRINT '  ✓ ลบคอลัมน์ package_unit_id'
END

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PO_Items') AND name = 'qty_per_package')
BEGIN
    ALTER TABLE PO_Items DROP COLUMN qty_per_package
    PRINT '  ✓ ลบคอลัมน์ qty_per_package'
END

-- ลบหน่วยบรรจุ (ระวัง: อาจมีข้อมูลใช้งานอยู่)
DELETE FROM Units WHERE unit_code IN ('CAN', 'DRUM', 'PAIL', 'BUCKET', 'CARTON', 'BOX', 'ROLL', 'REEL', 'SPOOL', 'BAG', 'SACK', 'BUNDLE', 'PACK', 'BOTTLE')
PRINT '  ✓ ลบหน่วยบรรจุทั้งหมด'

PRINT 'ROLLBACK เสร็จสิ้น'
*/
