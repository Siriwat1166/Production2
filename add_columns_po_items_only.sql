-- ============================================================
-- SQL Script: เพิ่มคอลัมน์ใน PO_Items เท่านั้น
-- วันที่: 2025-12-10
-- คำอธิบาย: เพิ่ม 3 คอลัมน์สำหรับเก็บข้อมูลหน่วยบรรจุ
-- ============================================================

PRINT '============================================================'
PRINT 'เริ่มเพิ่มคอลัมน์ใน PO_Items...'
PRINT '============================================================'
PRINT ''

-- ============================================================
-- STEP 1: เพิ่มคอลัมน์ package_qty
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('PO_Items')
               AND name = 'package_qty')
BEGIN
    ALTER TABLE PO_Items ADD package_qty DECIMAL(18,3) NULL
    PRINT '✓ เพิ่มคอลัมน์ package_qty (จำนวนหน่วยบรรจุ) - DECIMAL(18,3) NULL'
END
ELSE
BEGIN
    PRINT '- คอลัมน์ package_qty มีอยู่แล้ว'
END
PRINT ''

-- ============================================================
-- STEP 2: เพิ่มคอลัมน์ package_unit_id
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('PO_Items')
               AND name = 'package_unit_id')
BEGIN
    ALTER TABLE PO_Items ADD package_unit_id INT NULL
    PRINT '✓ เพิ่มคอลัมน์ package_unit_id (FK -> Units.unit_id) - INT NULL'
END
ELSE
BEGIN
    PRINT '- คอลัมน์ package_unit_id มีอยู่แล้ว'
END
PRINT ''

-- ============================================================
-- STEP 3: เพิ่มคอลัมน์ qty_per_package
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE object_id = OBJECT_ID('PO_Items')
               AND name = 'qty_per_package')
BEGIN
    ALTER TABLE PO_Items ADD qty_per_package DECIMAL(18,3) NULL
    PRINT '✓ เพิ่มคอลัมน์ qty_per_package (ปริมาณต่อหน่วยบรรจุ) - DECIMAL(18,3) NULL'
END
ELSE
BEGIN
    PRINT '- คอลัมน์ qty_per_package มีอยู่แล้ว'
END
PRINT ''

-- ============================================================
-- STEP 4: เพิ่ม Foreign Key Constraint (Optional)
-- ============================================================
PRINT 'กำลังเพิ่ม Foreign Key Constraint...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
               WHERE name = 'FK_PO_Items_PackageUnit')
BEGIN
    ALTER TABLE PO_Items
    ADD CONSTRAINT FK_PO_Items_PackageUnit
    FOREIGN KEY (package_unit_id) REFERENCES Units(unit_id)
    PRINT '✓ เพิ่ม Foreign Key: FK_PO_Items_PackageUnit'
END
ELSE
BEGIN
    PRINT '- Foreign Key FK_PO_Items_PackageUnit มีอยู่แล้ว'
END
PRINT ''

-- ============================================================
-- STEP 5: เพิ่ม Extended Properties (คำอธิบายคอลัมน์)
-- ============================================================
PRINT 'กำลังเพิ่มคำอธิบายคอลัมน์...'

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
PRINT ''

-- ============================================================
-- STEP 6: ตรวจสอบผลลัพธ์
-- ============================================================
PRINT '============================================================'
PRINT 'ตรวจสอบผลลัพธ์...'
PRINT '============================================================'
PRINT ''

SELECT
    c.name AS [Column Name],
    t.name AS [Data Type],
    CASE
        WHEN t.name IN ('decimal', 'numeric') THEN CONCAT('(', c.precision, ',', c.scale, ')')
        WHEN t.name IN ('varchar', 'nvarchar', 'char', 'nchar') THEN CONCAT('(', CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR) END, ')')
        ELSE ''
    END AS [Type Detail],
    CASE WHEN c.is_nullable = 1 THEN 'YES' ELSE 'NO' END AS [Nullable],
    ISNULL(ep.value, '-') AS [Description]
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
PRINT 'เสร็จสมบูรณ์!'
PRINT '============================================================'
PRINT ''
PRINT 'คอลัมน์ที่เพิ่มเข้ามา:'
PRINT '1. package_qty (DECIMAL 18,3) - จำนวนหน่วยบรรจุ'
PRINT '2. package_unit_id (INT) - FK -> Units.unit_id'
PRINT '3. qty_per_package (DECIMAL 18,3) - ปริมาณต่อหน่วยบรรจุ'
PRINT ''
PRINT 'หมายเหตุ:'
PRINT '- คอลัมน์ทั้งหมดเป็น NULL ได้ (ไม่บังคับ)'
PRINT '- สามารถใช้งานกับ PO เก่าได้โดยไม่กระทบข้อมูล'
PRINT '- ต้องมีหน่วยบรรจุใน Units table ก่อน (เช่น CAN, DRUM, PAIL)'
PRINT ''
PRINT 'ขั้นตอนถัดไป:'
PRINT '1. ตรวจสอบว่ามีหน่วยบรรจุใน Units table หรือยัง'
PRINT '   SELECT * FROM Units WHERE unit_code IN (''CAN'', ''DRUM'', ''PAIL'')'
PRINT '2. ถ้ายังไม่มี ให้รัน script: database_migration_package_units.sql'
PRINT '3. แก้ไขไฟล์ create.php ตาม code_snippets_create_php.txt'
PRINT '4. แก้ไขไฟล์ receiving_po.php ตาม code_snippets_receiving_po_php.txt'
PRINT ''

-- ============================================================
-- ROLLBACK (ใช้เมื่อต้องการลบคอลัมน์ - ระวัง!)
-- ============================================================
/*
PRINT 'ROLLBACK: ลบคอลัมน์ทั้งหมด...'

-- ลบ Foreign Key ก่อน
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_PO_Items_PackageUnit')
BEGIN
    ALTER TABLE PO_Items DROP CONSTRAINT FK_PO_Items_PackageUnit
    PRINT '✓ ลบ Foreign Key: FK_PO_Items_PackageUnit'
END

-- ลบคอลัมน์
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PO_Items') AND name = 'package_qty')
BEGIN
    ALTER TABLE PO_Items DROP COLUMN package_qty
    PRINT '✓ ลบคอลัมน์ package_qty'
END

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PO_Items') AND name = 'package_unit_id')
BEGIN
    ALTER TABLE PO_Items DROP COLUMN package_unit_id
    PRINT '✓ ลบคอลัมน์ package_unit_id'
END

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PO_Items') AND name = 'qty_per_package')
BEGIN
    ALTER TABLE PO_Items DROP COLUMN qty_per_package
    PRINT '✓ ลบคอลัมน์ qty_per_package'
END

PRINT 'ROLLBACK เสร็จสิ้น'
*/
