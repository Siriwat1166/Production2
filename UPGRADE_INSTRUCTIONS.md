# 📚 คู่มือการแก้ไขระบบรองรับหน่วยบรรจุ (Package Units)

## 📌 ภาพรวม
เอกสารนี้อธิบายขั้นตอนการแก้ไขระบบเพื่อรองรับข้อมูลหน่วยบรรจุ เช่น:
- **สั่งหมึก 5 กระป๋อง กระป๋องละ 2 กิโล รวม 10 กิโล**

---

## 🔧 ขั้นตอนการแก้ไขทั้งหมด

### ขั้นตอนที่ 1: รัน SQL Script 🗄️

**ไฟล์:** `database_migration_package_units.sql`

**วิธีการ:**
1. เปิด SQL Server Management Studio (SSMS)
2. เชื่อมต่อกับ Database ของโปรเจค Production2
3. เปิดไฟล์ `database_migration_package_units.sql`
4. กด Execute (F5)
5. ตรวจสอบผลลัพธ์ว่าทุก STEP เสร็จสมบูรณ์

**ผลลัพธ์ที่ได้:**
- ✅ เพิ่มหน่วยบรรจุ 14 หน่วย (CAN, DRUM, PAIL, ฯลฯ) ในตาราง `Units`
- ✅ เพิ่ม 3 คอลัมน์ใหม่ในตาราง `PO_Items`:
  - `package_qty` (DECIMAL 18,3)
  - `package_unit_id` (INT)
  - `qty_per_package` (DECIMAL 18,3)
- ✅ เพิ่ม Foreign Key: `FK_PO_Items_PackageUnit`

---

### ขั้นตอนที่ 2: แก้ไขไฟล์ create.php 📝

**ไฟล์:** `/home/user/Production2/create.php`

---

#### 🔸 การแก้ไขที่ 1: เพิ่มการรับค่าฟิลด์ใหม่จาก POST

**ตำแหน่ง:** บรรทัด 288-294 (ใน loop for ที่บันทึก Material Items)

**จาก:**
```php
$product_id = intval($_POST['product_id'][$i]);
$quantity = floatval($_POST['quantity'][$i]);
$purchase_unit_id = intval($_POST['purchase_unit_id'][$i]);
$unit_price = floatval($_POST['unit_price'][$i]);
$total_price = $quantity * $unit_price;
$notes_item = sanitizeInput($_POST['notes_item'][$i] ?? '');
```

**เป็น:**
```php
$product_id = intval($_POST['product_id'][$i]);
$quantity = floatval($_POST['quantity'][$i]);
$purchase_unit_id = intval($_POST['purchase_unit_id'][$i]);
$unit_price = floatval($_POST['unit_price'][$i]);
$total_price = $quantity * $unit_price;
$notes_item = sanitizeInput($_POST['notes_item'][$i] ?? '');

// 🆕 รับค่าฟิลด์หน่วยบรรจุ
$package_qty = !empty($_POST['package_qty'][$i]) ? floatval($_POST['package_qty'][$i]) : null;
$package_unit_id = !empty($_POST['package_unit_id'][$i]) ? intval($_POST['package_unit_id'][$i]) : null;
$qty_per_package = !empty($_POST['qty_per_package'][$i]) ? floatval($_POST['qty_per_package'][$i]) : null;

// 🆕 Validate: ถ้ากรอกฟิลด์ package ต้องกรอกครบทั้ง 3 ฟิลด์
if (($package_qty !== null || $package_unit_id !== null || $qty_per_package !== null) &&
    ($package_qty === null || $package_unit_id === null || $qty_per_package === null)) {
    throw new Exception("กรุณากรอกข้อมูลหน่วยบรรจุให้ครบถ้วน (จำนวน, หน่วย, ปริมาณต่อหน่วย)");
}

// 🆕 Validate: package_qty × qty_per_package ต้องเท่ากับ quantity
if ($package_qty !== null && $qty_per_package !== null) {
    $calculated_qty = $package_qty * $qty_per_package;
    if (abs($calculated_qty - $quantity) > 0.01) { // ยอมให้ผิดเพี้ยน 0.01
        throw new Exception("น้ำหนักรวมไม่ตรงกับการคำนวณ (จำนวนกระป๋อง × น้ำหนักต่อกระป๋อง)");
    }
}
```

---

#### 🔸 การแก้ไขที่ 2: แก้ไข SQL INSERT Statement

**ตำแหน่ง:** บรรทัด 297-302

**จาก:**
```php
$stmt = $conn->prepare("
    INSERT INTO PO_Items
    (po_id, line_number, product_id, quantity, purchase_unit_id, stock_unit_id,
     conversion_factor, stock_quantity, unit_price, total_price, item_type_id, status, notes)
    VALUES (?, ?, ?, ?, ?, ?, 1.0, ?, ?, ?, ?, 'Open', ?)
");
```

**เป็น:**
```php
$stmt = $conn->prepare("
    INSERT INTO PO_Items
    (po_id, line_number, product_id, quantity, purchase_unit_id, stock_unit_id,
     conversion_factor, stock_quantity, unit_price, total_price, item_type_id, status, notes,
     package_qty, package_unit_id, qty_per_package)
    VALUES (?, ?, ?, ?, ?, ?, 1.0, ?, ?, ?, ?, 'Open', ?, ?, ?, ?)
");
```

---

#### 🔸 การแก้ไขที่ 3: แก้ไข Execute Parameters

**ตำแหน่ง:** บรรทัด 304-307

**จาก:**
```php
$stmt->execute([
    $po_id, $line_number, $product_id, $quantity, $purchase_unit_id, $purchase_unit_id,
    $quantity, $unit_price, $total_price, $item_type_id_material, $notes_item
]);
```

**เป็น:**
```php
$stmt->execute([
    $po_id, $line_number, $product_id, $quantity, $purchase_unit_id, $purchase_unit_id,
    $quantity, $unit_price, $total_price, $item_type_id_material, $notes_item,
    $package_qty, $package_unit_id, $qty_per_package
]);
```

---

#### 🔸 การแก้ไขที่ 4: เพิ่มตารางฟิลด์ใหม่ใน HTML Form

**ตำแหน่ง:** บรรทัด 966-1030 (ตารางแสดงรายการสินค้า)

**หา:** บรรทัดที่มี `<thead>` ของตาราง Material Items

**จาก:**
```html
<thead>
    <tr>
        <th style="width: 30%;">สินค้า</th>
        <th style="width: 10%;">จำนวน</th>
        <th style="width: 10%;">หน่วย</th>
        <th style="width: 12%;">ราคาต่อหน่วย</th>
        <th style="width: 12%;">ยอดรวม</th>
        <th style="width: 20%;">หมายเหตุ</th>
        <th style="width: 6%;"></th>
    </tr>
</thead>
```

**เป็น:**
```html
<thead>
    <tr>
        <th style="width: 22%;">สินค้า</th>
        <th style="width: 8%;">น้ำหนักรวม</th>
        <th style="width: 8%;">หน่วย</th>
        <th style="width: 7%;" class="text-center">จำนวนบรรจุ 🆕</th>
        <th style="width: 8%;" class="text-center">หน่วยบรรจุ 🆕</th>
        <th style="width: 7%;" class="text-center">ต่อหน่วย 🆕</th>
        <th style="width: 10%;">ราคาต่อหน่วย</th>
        <th style="width: 10%;">ยอดรวม</th>
        <th style="width: 14%;">หมายเหตุ</th>
        <th style="width: 6%;"></th>
    </tr>
</thead>
```

**และแก้ไข `<tbody>` บรรทัดแรก:**

**จาก:**
```html
<tbody>
    <tr>
        <td>
            <select name="product_id[]" class="form-select select2" required>
                <!-- options... -->
            </select>
        </td>
        <td><input type="number" name="quantity[]" step="0.01" required placeholder="0.00" class="form-control"></td>
        <td>
            <select name="purchase_unit_id[]" class="form-select" required>
                <!-- options... -->
            </select>
        </td>
        <td><input type="number" name="unit_price[]" step="0.01" required placeholder="0.00" class="form-control"></td>
        <td><input type="text" name="total_price[]" readonly class="form-control calculated-field total-price"></td>
        <td><input type="text" name="notes_item[]" placeholder="หมายเหตุ" class="form-control"></td>
        <td><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">❌</button></td>
    </tr>
</tbody>
```

**เป็น:**
```html
<tbody>
    <tr>
        <td>
            <select name="product_id[]" class="form-select select2" required>
                <!-- options... -->
            </select>
        </td>
        <td><input type="number" name="quantity[]" step="0.01" required placeholder="0.00" class="form-control quantity-field"></td>
        <td>
            <select name="purchase_unit_id[]" class="form-select" required>
                <!-- options... -->
            </select>
        </td>

        <!-- 🆕 ฟิลด์ใหม่: จำนวนบรรจุ -->
        <td><input type="number" name="package_qty[]" step="0.01" placeholder="0" class="form-control text-end package-qty-field"></td>

        <!-- 🆕 ฟิลด์ใหม่: หน่วยบรรจุ -->
        <td>
            <select name="package_unit_id[]" class="form-select package-unit-field">
                <option value="">-- เลือก --</option>
                <?php
                // กรองเฉพาะหน่วยบรรจุ
                $package_units = array_filter($units, function($u) {
                    return in_array($u['unit_code'], ['CAN', 'DRUM', 'PAIL', 'BUCKET', 'CARTON', 'BOX', 'ROLL', 'REEL', 'SPOOL', 'BAG', 'SACK', 'BUNDLE', 'PACK', 'BOTTLE']);
                });
                foreach ($package_units as $unit):
                ?>
                <option value="<?= htmlspecialchars($unit['unit_id']) ?>"
                        data-symbol="<?= htmlspecialchars($unit['unit_symbol']) ?>">
                    <?= htmlspecialchars($unit['unit_name_th'] ?? $unit['unit_name']) ?>
                </option>
                <?php endforeach; ?>
            </select>
        </td>

        <!-- 🆕 ฟิลด์ใหม่: ปริมาณต่อหน่วยบรรจุ -->
        <td><input type="number" name="qty_per_package[]" step="0.01" placeholder="0" class="form-control text-end qty-per-package-field"></td>

        <td><input type="number" name="unit_price[]" step="0.01" required placeholder="0.00" class="form-control"></td>
        <td><input type="text" name="total_price[]" readonly class="form-control calculated-field total-price"></td>
        <td><input type="text" name="notes_item[]" placeholder="หมายเหตุ" class="form-control"></td>
        <td><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">❌</button></td>
    </tr>
</tbody>
```

---

#### 🔸 การแก้ไขที่ 5: เพิ่ม JavaScript Auto-calculate

**ตำแหน่ง:** บรรทัด 1537-1549 (ฟังก์ชัน addMaterialRowListeners)

**เพิ่มโค้ดนี้หลังบรรทัด 1549:**

```javascript
// 🆕 Package calculation listeners
const packageQtyField = row.querySelector('.package-qty-field');
const qtyPerPackageField = row.querySelector('.qty-per-package-field');

if (packageQtyField && qtyPerPackageField) {
    // Auto-calculate total quantity when package fields change
    const autoCalcQuantity = () => {
        const packageQty = parseFloat(packageQtyField.value) || 0;
        const qtyPerPkg = parseFloat(qtyPerPackageField.value) || 0;

        if (packageQty > 0 && qtyPerPkg > 0) {
            const totalQty = packageQty * qtyPerPkg;
            quantityField.value = totalQty.toFixed(3);
            updateRowTotal(row);

            // เปลี่ยนสีพื้นหลังเป็นเขียวอ่อน แสดงว่าคำนวณอัตโนมัติ
            quantityField.style.backgroundColor = '#d4edda';
        } else {
            quantityField.style.backgroundColor = '';
        }
    };

    packageQtyField.addEventListener('input', autoCalcQuantity);
    qtyPerPackageField.addEventListener('input', autoCalcQuantity);

    // Validate: ถ้ากรอก quantity เอง ให้เช็คว่าตรงกับการคำนวณหรือไม่
    quantityField.addEventListener('blur', () => {
        const packageQty = parseFloat(packageQtyField.value) || 0;
        const qtyPerPkg = parseFloat(qtyPerPackageField.value) || 0;
        const manualQty = parseFloat(quantityField.value) || 0;

        if (packageQty > 0 && qtyPerPkg > 0) {
            const calculatedQty = packageQty * qtyPerPkg;
            if (Math.abs(calculatedQty - manualQty) > 0.01) {
                alert(`⚠️ คำเตือน: น้ำหนักรวมไม่ตรงกับการคำนวณ\n` +
                      `${packageQty} × ${qtyPerPkg} = ${calculatedQty.toFixed(3)}\n` +
                      `แต่คุณกรอก: ${manualQty}`);
                quantityField.style.backgroundColor = '#f8d7da';
            } else {
                quantityField.style.backgroundColor = '#d4edda';
            }
        }
    });
}
```

---

#### 🔸 การแก้ไขที่ 6: เพิ่มคำแนะนำในฟอร์ม

**ตำแหน่ง:** บรรทัด 960-965 (ก่อนตาราง Material Items)

**เพิ่มก่อน `<table>`:**

```html
<div class="alert alert-info mb-3">
    <h6 class="mb-2"><i class="fas fa-info-circle"></i> วิธีกรอกข้อมูลหน่วยบรรจุ</h6>
    <small>
        <strong>ตัวอย่าง:</strong> สั่งหมึก 5 กระป๋อง กระป๋องละ 2 กิโล รวม 10 กิโล<br>
        • <strong>จำนวนบรรจุ:</strong> 5<br>
        • <strong>หน่วยบรรจุ:</strong> กระป๋อง<br>
        • <strong>ต่อหน่วย:</strong> 2<br>
        • <strong>น้ำหนักรวม:</strong> 10 (คำนวณอัตโนมัติ = 5 × 2)<br>
        <span class="text-muted">หมายเหตุ: ถ้าไม่มีหน่วยบรรจุ สามารถข้ามช่องนี้ได้</span>
    </small>
</div>
```

---

### ขั้นตอนที่ 3: แก้ไขไฟล์ receiving_po.php 📦

**ไฟล์:** `/home/user/Production2/receiving_po.php`

---

#### 🔸 การแก้ไขที่ 1: แก้ไข SQL SELECT เพื่อดึงข้อมูล package

**ตำแหน่ง:** บรรทัด 455-467 (SQL SELECT PO_Items)

**หา:**
```php
$stmt = $pdo->prepare("
    SELECT
        pi.*,
        mp.SSP_Code, mp.Name as product_name, mp.Name2,
        u_purchase.unit_name as purchase_unit_name, u_purchase.unit_symbol as purchase_unit_symbol,
        u_stock.unit_name as stock_unit_name, u_stock.unit_symbol as stock_unit_symbol,
        sp.W_mm, sp.L_mm, sp.gsm
    FROM PO_Items pi
    LEFT JOIN Master_Products_ID mp ON pi.product_id = mp.id
    LEFT JOIN Units u_purchase ON pi.purchase_unit_id = u_purchase.unit_id
    LEFT JOIN Units u_stock ON pi.stock_unit_id = u_stock.unit_id
    LEFT JOIN Specific_Paperboard sp ON pi.product_id = sp.product_id
    WHERE pi.po_id = ?
    ORDER BY pi.line_number
");
```

**เป็น:**
```php
$stmt = $pdo->prepare("
    SELECT
        pi.*,
        mp.SSP_Code, mp.Name as product_name, mp.Name2,
        u_purchase.unit_name as purchase_unit_name, u_purchase.unit_symbol as purchase_unit_symbol,
        u_stock.unit_name as stock_unit_name, u_stock.unit_symbol as stock_unit_symbol,
        u_package.unit_name as package_unit_name, u_package.unit_name_th as package_unit_name_th,
        sp.W_mm, sp.L_mm, sp.gsm
    FROM PO_Items pi
    LEFT JOIN Master_Products_ID mp ON pi.product_id = mp.id
    LEFT JOIN Units u_purchase ON pi.purchase_unit_id = u_purchase.unit_id
    LEFT JOIN Units u_stock ON pi.stock_unit_id = u_stock.unit_id
    LEFT JOIN Units u_package ON pi.package_unit_id = u_package.unit_id
    LEFT JOIN Specific_Paperboard sp ON pi.product_id = sp.product_id
    WHERE pi.po_id = ?
    ORDER BY pi.line_number
");
```

---

#### 🔸 การแก้ไขที่ 2: แสดงข้อมูล Package ใน UI

**ตำแหน่ง:** หาบรรทัดที่แสดงรายละเอียดสินค้าในการ์ดรับของ (ประมาณบรรทัด 650-750)

**เพิ่มโค้ดนี้ในส่วนที่แสดงข้อมูล PO Item:**

```php
<?php if (!empty($item['package_qty']) && !empty($item['package_unit_name'])): ?>
<div class="row mb-2">
    <div class="col-4"><strong>📦 หน่วยบรรจุ:</strong></div>
    <div class="col-8">
        <?= number_format($item['package_qty'], 2) ?>
        <?= htmlspecialchars($item['package_unit_name_th'] ?? $item['package_unit_name']) ?>
        <?php if (!empty($item['qty_per_package'])): ?>
            (<?= htmlspecialchars($item['package_unit_name_th'] ?? $item['package_unit_name']) ?>ละ
            <?= number_format($item['qty_per_package'], 2) ?>
            <?= htmlspecialchars($item['purchase_unit_name']) ?>)
        <?php endif; ?>
    </div>
</div>
<?php endif; ?>
```

---

### ขั้นตอนที่ 4: แก้ไขไฟล์ goods_receipt_list.php (ถ้าต้องการ) 📋

**ไฟล์:** `/home/user/Production2/goods_receipt_list.php`

เพิ่มการแสดงข้อมูล package ในหน้ารายการรับของ (ทำคล้ายกับ receiving_po.php)

---

### ขั้นตอนที่ 5: ทดสอบระบบ ✅

#### 1. ทดสอบสร้าง PO ใหม่
- เข้าหน้า `create.php`
- สร้าง PO แบบ Material
- กรอกข้อมูล:
  - สินค้า: หมึกสีน้ำเงิน
  - **จำนวนบรรจุ:** 5
  - **หน่วยบรรจุ:** กระป๋อง
  - **ต่อหน่วย:** 2
  - **น้ำหนักรวม:** ควรคำนวณอัตโนมัติเป็น 10
  - ราคาต่อหน่วย: 100
- บันทึก PO
- ตรวจสอบในฐานข้อมูล:
  ```sql
  SELECT po_id, line_number, product_id, quantity,
         package_qty, package_unit_id, qty_per_package
  FROM PO_Items
  WHERE po_id = (SELECT MAX(po_id) FROM PO_Header)
  ```

#### 2. ทดสอบรับของ
- เข้าหน้า `receiving_po.php`
- เลือก PO ที่สร้างไว้
- ตรวจสอบว่าข้อมูล package แสดงถูกต้อง
- รับของเข้าคลัง จำนวน 5 กระป๋อง
- ตรวจสอบ `Goods_Receipt_Items.quantity_pallet` ควรเป็น 5

#### 3. ทดสอบ PO เก่า (ย้อนหลัง)
- เปิด PO เก่าที่สร้างก่อนทำการ migrate
- ตรวจสอบว่าไม่เกิด error
- ระบบควรทำงานได้ปกติแม้ไม่มีข้อมูล package

---

## ⚠️ ข้อควรระวัง

1. **สำรองฐานข้อมูลก่อน** รัน SQL Script
2. **ทดสอบบน Development Environment ก่อน** นำขึ้น Production
3. **ฟิลด์ใหม่เป็น Optional** - PO เก่าไม่ต้องมีข้อมูล package ก็ได้
4. **Validate ข้อมูล** - ต้องเช็คว่า package_qty × qty_per_package = quantity
5. **อบรมพนักงาน** - ให้เข้าใจวิธีกรอกข้อมูลใหม่

---

## 📞 การแก้ปัญหา

### ปัญหาที่อาจพบ

**1. SQL Error: Column already exists**
- แก้: ไฟล์ SQL มีการเช็ค `IF NOT EXISTS` อยู่แล้ว ไม่ต้องกังวล

**2. Foreign Key Error**
- สาเหตุ: อาจมี FK อยู่แล้ว
- แก้: ไฟล์ SQL มีการเช็คอยู่แล้ว

**3. ไม่มีหน่วยบรรจุให้เลือก**
- ตรวจสอบ: `SELECT * FROM Units WHERE unit_code IN ('CAN', 'DRUM', 'PAIL')`
- แก้: รัน STEP 1 ของ SQL Script ใหม่

**4. Auto-calculate ไม่ทำงาน**
- ตรวจสอบ: Console ของ Browser (F12)
- แก้: เช็ค JavaScript ว่ามี event listener ถูกต้องหรือไม่

**5. ข้อมูล package ไม่แสดงในหน้ารับของ**
- ตรวจสอบ: SQL SELECT มี JOIN กับ `Units u_package` หรือไม่
- แก้: เพิ่ม LEFT JOIN ตามขั้นตอนที่ 3

---

## 📊 ตัวอย่างข้อมูลหลัง Migration

### ตาราง PO_Items
```
po_id | product_id | quantity | purchase_unit_id | package_qty | package_unit_id | qty_per_package
------|------------|----------|------------------|-------------|-----------------|----------------
1001  | 123        | 10.000   | 2 (KG)           | 5.000       | 15 (CAN)        | 2.000
1001  | 456        | 200.000  | 3 (L)            | 1.000       | 16 (DRUM)       | 200.000
1002  | 789        | 50.000   | 2 (KG)           | NULL        | NULL            | NULL
```

### ความหมาย:
- **แถวที่ 1:** สั่งหมึก 5 กระป๋อง กระป๋องละ 2 กิโล รวม 10 กิโล
- **แถวที่ 2:** สั่งน้ำมัน 1 ถัง ถังละ 200 ลิตร รวม 200 ลิตร
- **แถวที่ 3:** สั่งผงสี 50 กิโล (ไม่มีข้อมูลหน่วยบรรจุ - ข้อมูลเก่า)

---

## ✅ เสร็จสิ้น!

หลังจากทำตามขั้นตอนทั้งหมดแล้ว ระบบจะรองรับการบันทึกข้อมูลหน่วยบรรจุได้อย่างสมบูรณ์!

**ไฟล์ที่แก้ไข:**
- ✅ database_migration_package_units.sql (สร้างใหม่)
- ✅ create.php (แก้ไข 6 จุด)
- ✅ receiving_po.php (แก้ไข 2 จุด)

**ผลลัพธ์:**
- ✅ บันทึกข้อมูลหน่วยบรรจุได้
- ✅ คำนวณอัตโนมัติ
- ✅ แสดงผลครบถ้วน
- ✅ ย้อนหลังได้ (PO เก่าใช้งานได้)
