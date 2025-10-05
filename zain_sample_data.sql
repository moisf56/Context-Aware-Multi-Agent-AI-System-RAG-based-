-- Zain Kuwait Telecom Sample Data
-- 20 customers, 10 areas, realistic Kuwaiti context

-- =========================================
-- VALIDATION POOLS
-- =========================================

-- Valid Kuwait Civil ID numbers (12-digit format with realistic structure)
INSERT INTO valid_civil_ids (civil_id_number, is_used) VALUES
('280012345678', FALSE), ('281234567890', FALSE), ('282345678901', FALSE), ('283456789012', FALSE),
('284567890123', FALSE), ('285678901234', FALSE), ('286789012345', FALSE), ('287890123456', FALSE),
('288901234567', FALSE), ('289012345678', FALSE), ('290123456789', FALSE), ('291234567890', FALSE),
('292345678901', FALSE), ('293456789012', FALSE), ('294567890123', FALSE), ('295678901234', FALSE),
('296789012345', FALSE), ('297890123456', FALSE), ('298901234567', FALSE), ('299012345678', FALSE),
-- Extra unused numbers for new prospects
('270123456789', FALSE), ('271234567890', FALSE), ('272345678901', FALSE), ('273456789012', FALSE),
('274567890123', FALSE), ('275678901234', FALSE), ('276789012345', FALSE), ('277890123456', FALSE);

-- 10 Kuwait areas (mix of different governorates)
INSERT INTO service_areas (area_name, governorate, district, fiber_available, coverage_quality) VALUES
('مدينة الكويت', 'العاصمة', 'دسمان', TRUE, 'excellent'),
('السالمية', 'حولي', 'السالمية', TRUE, 'excellent'),
('الجابرية', 'حولي', 'الجابرية', TRUE, 'excellent'),
('الفروانية', 'الفروانية', 'الفروانية', FALSE, 'good'),
('الأحمدي', 'الأحمدي', 'الأحمدي', TRUE, 'good'),
('الجهراء', 'الجهراء', 'الجهراء', FALSE, 'basic'),
('مبارك الكبير', 'مبارك الكبير', 'صباح السالم', TRUE, 'excellent'),
('الفنطاس', 'الأحمدي', 'الفنطاس', FALSE, 'good'),
('الرقة', 'حولي', 'الرقة', TRUE, 'good'),
('كيفان', 'العاصمة', 'كيفان', FALSE, 'basic');

-- Branch locations for payments
INSERT INTO branch_locations (branch_name, governorate, district, address, phone, working_hours) VALUES
('زين - الشرق', 'العاصمة', 'الشرق', 'شارع فهد السالم، مجمع الشرق التجاري', '+965 2224 0001', '08:00-20:00 الأحد-الخميس'),
('زين - السالمية', 'حولي', 'السالمية', 'شارع سالم المبارك، مجمع مارينا مول', '+965 2224 0002', '08:00-20:00 الأحد-الخميس'),
('زين - الجابرية', 'حولي', 'الجابرية', 'شارع بيروت، مجمع الجابرية', '+965 2224 0003', '08:00-20:00 الأحد-الخميس'),
('زين - الفروانية', 'الفروانية', 'الفروانية', 'شارع الرابع، مجمع الفروانية', '+965 2224 0004', '08:00-20:00 الأحد-الخميس'),
('زين - الأحمدي', 'الأحمدي', 'الأحمدي', 'طريق الملك فهد، مجمع الأحمدي', '+965 2224 0005', '08:00-20:00 الأحد-الخميس');

-- =========================================
-- SERVICES AND PRICING
-- =========================================

-- Available services (Zain Kuwait packages)
INSERT INTO services (service_name, service_type, speed_mbps, data_limit_gb, voice_minutes, monthly_price_kwd, installation_fee_kwd, requires_technician, fiber_required, service_description, contract_duration_months) VALUES
-- Fiber Internet
('زين فايبر 25 ميجا', 'fiber', 25, NULL, NULL, 25.500, 30.000, TRUE, TRUE, 'إنترنت فايبر 25 ميجا، استخدام غير محدود', 12),
('زين فايبر 50 ميجا', 'fiber', 50, NULL, NULL, 35.000, 30.000, TRUE, TRUE, 'إنترنت فايبر 50 ميجا، استخدام غير محدود', 12),
('زين فايبر 100 ميجا', 'fiber', 100, NULL, NULL, 45.000, 30.000, TRUE, TRUE, 'إنترنت فايبر 100 ميجا، استخدام غير محدود', 12),
('زين فايبر 500 ميجا', 'fiber', 500, NULL, NULL, 75.000, 50.000, TRUE, TRUE, 'إنترنت فايبر 500 ميجا، استخدام غير محدود', 24),

-- ADSL Internet
('زين ADSL 8 ميجا', 'adsl', 8, NULL, NULL, 18.000, 15.000, TRUE, FALSE, 'إنترنت ADSL 8 ميجا، خط هاتف مطلوب', 12),
('زين ADSL 16 ميجا', 'adsl', 16, NULL, NULL, 22.000, 15.000, TRUE, FALSE, 'إنترنت ADSL 16 ميجا، خط هاتف مطلوب', 12),

-- Mobile Internet
('زين موبايل إنترنت 50 جيجا', 'mobile_internet', 4, 50, NULL, 35.000, 0.000, FALSE, FALSE, '50 جيجا إنترنت موبايل 4G', 12),
('زين موبايل إنترنت 100 جيجا', 'mobile_internet', 4, 100, NULL, 45.000, 0.000, FALSE, FALSE, '100 جيجا إنترنت موبايل 4G', 12),

-- Mobile Voice Plans
('زين صوت 1000 دقيقة', 'mobile_voice', NULL, 20, 1000, 28.000, 0.000, FALSE, FALSE, '1000 دقيقة + 20 جيجا إنترنت + رسائل', 12),
('زين صوت 2000 دقيقة', 'mobile_voice', NULL, 40, 2000, 38.000, 0.000, FALSE, FALSE, '2000 دقيقة + 40 جيجا إنترنت + رسائل', 12),

-- Bundle Packages
('باقة البيت الذكي', 'bundle', 50, 25, 1000, 55.000, 30.000, TRUE, TRUE, 'فايبر 50 ميجا + خط موبايل + تلفزيون', 24),
('باقة البيت الممتاز', 'bundle', 100, 50, 2000, 75.000, 50.000, TRUE, TRUE, 'فايبر 100 ميجا + خط موبايل + تلفزيون + نتفليكس', 24);

-- Dynamic pricing for different areas (some areas more expensive)
INSERT INTO service_pricing (service_id, area_id, base_price_kwd, area_modifier, promotion_discount)
SELECT
    s.service_id,
    sa.area_id,
    s.monthly_price_kwd as base_price_kwd,
    CASE
        WHEN sa.coverage_quality = 'excellent' THEN 1.1  -- 10% premium for excellent areas
        WHEN sa.coverage_quality = 'good' THEN 1.0       -- Standard pricing
        WHEN sa.coverage_quality = 'basic' THEN 0.9      -- 10% discount for basic areas
    END as area_modifier,
    CASE
        WHEN s.service_type = 'fiber' AND sa.fiber_available = TRUE THEN 5.000  -- 5 KWD discount for fiber in fiber areas
        WHEN s.service_type = 'bundle' THEN 8.000  -- 8 KWD discount for bundles
        ELSE 0.000
    END as promotion_discount
FROM services s
CROSS JOIN service_areas sa
WHERE s.is_active = TRUE;

-- =========================================
-- 20 REALISTIC KUWAITI CUSTOMERS
-- =========================================

-- First, get area IDs for easier referencing
DO $
DECLARE
    kuwait_city_id UUID;
    salmiya_id UUID;
    jabriya_id UUID;
    farwaniya_id UUID;
    ahmadi_id UUID;
    jahra_id UUID;
    mubarak_id UUID;
    fintas_id UUID;
    ruqai_id UUID;
    kaifan_id UUID;
BEGIN
    SELECT area_id INTO kuwait_city_id FROM service_areas WHERE area_name = 'مدينة الكويت';
    SELECT area_id INTO salmiya_id FROM service_areas WHERE area_name = 'السالمية';
    SELECT area_id INTO jabriya_id FROM service_areas WHERE area_name = 'الجابرية';
    SELECT area_id INTO farwaniya_id FROM service_areas WHERE area_name = 'الفروانية';
    SELECT area_id INTO ahmadi_id FROM service_areas WHERE area_name = 'الأحمدي';
    SELECT area_id INTO jahra_id FROM service_areas WHERE area_name = 'الجهراء';
    SELECT area_id INTO mubarak_id FROM service_areas WHERE area_name = 'مبارك الكبير';
    SELECT area_id INTO fintas_id FROM service_areas WHERE area_name = 'الفنطاس';
    SELECT area_id INTO ruqai_id FROM service_areas WHERE area_name = 'الرقة';
    SELECT area_id INTO kaifan_id FROM service_areas WHERE area_name = 'كيفان';

    -- Insert 20 Kuwaiti customers with realistic Arabic names and info
    INSERT INTO customers (civil_id_number, first_name, last_name, birth_date, phone, email, address, area_id, account_status, registration_date, total_spending, payment_method) VALUES
    ('280012345678', 'أحمد', 'الصباح', '1985-03-15', '+965 9000 1001', 'ahmed.sabah@gmail.com', 'شارع الخليج العربي، بناية 12، شقة 5', kuwait_city_id, 'active', '2023-01-15', 350.250, 'knet'),
    ('281234567890', 'فاطمة', 'العتيبي', '1990-07-22', '+965 9000 1002', 'fatima.otaibi@hotmail.com', 'شارع سالم المبارك، بناية 45، الدور 3', salmiya_id, 'active', '2023-02-20', 425.150, 'credit_card'),
    ('282345678901', 'محمد', 'الرشيد', '1988-11-10', '+965 9000 1003', 'mohammed.rashid@yahoo.com', 'شارع بيروت، فيلا 78', jabriya_id, 'active', '2022-12-05', 280.750, 'bank_transfer'),
    ('283456789012', 'نورا', 'الحربي', '1982-05-18', '+965 9000 1004', 'nora.harbi@gmail.com', 'شارع الرابع، بناية 23، شقة 8', farwaniya_id, 'active', '2023-03-10', 195.500, 'knet'),
    ('284567890123', 'عبدالله', 'المطيري', '1995-09-03', '+965 9000 1005', 'abdullah.mutairi@outlook.com', 'طريق الملك فهد، بناية 67، شقة 12', ahmadi_id, 'active', '2023-04-12', 315.400, 'direct_debit'),

    ('285678901234', 'مريم', 'العجمي', '1987-12-25', '+965 9000 1006', 'maryam.ajmi@gmail.com', 'شارع الصناعة، فيلا 89', jahra_id, 'active', '2022-11-30', 240.600, 'knet'),
    ('286789012345', 'سعد', 'الدوسري', '1991-04-07', '+965 9000 1007', 'saad.dosari@hotmail.com', 'شارع صباح السالم، بناية 34، الدور 2', mubarak_id, 'active', '2023-01-25', 380.800, 'cash'),
    ('287890123456', 'هند', 'القطان', '1993-08-14', '+965 9000 1008', 'hind.qattan@gmail.com', 'طريق الفنطاس، فيلا 156', fintas_id, 'active', '2023-05-18', 295.900, 'bank_transfer'),
    ('288901234567', 'خالد', 'العنزي', '1986-01-30', '+965 9000 1009', 'khalid.anzi@yahoo.com', 'شارع التجار، بناية 87، شقة 15', ruqai_id, 'active', '2022-10-22', 445.250, 'credit_card'),
    ('289012345678', 'ريم', 'البدر', '1989-06-12', '+965 9000 1010', 'reem.badr@outlook.com', 'شارع كيفان، فيلا 23', kaifan_id, 'active', '2023-02-14', 165.350, 'knet'),

    ('290123456789', 'يوسف', 'الشايع', '1984-10-05', '+965 9000 1011', 'youssef.shayea@gmail.com', 'شارع فهد السالم، بناية 234، شقة 7', kuwait_city_id, 'active', '2023-06-01', 385.450, 'direct_debit'),
    ('291234567890', 'سارة', 'الخالد', '1992-02-28', '+965 9000 1012', 'sarah.khalid@hotmail.com', 'شارع الملك عبدالعزيز، بناية 67، الدور 5', salmiya_id, 'active', '2022-09-15', 320.700, 'bank_transfer'),
    ('292345678901', 'عمر', 'الفهد', '1981-07-19', '+965 9000 1013', 'omar.fahad@gmail.com', 'شارع الجابرية، فيلا 123', jabriya_id, 'active', '2023-03-22', 405.150, 'knet'),
    ('293456789012', 'علياء', 'النصف', '1994-11-16', '+965 9000 1014', 'alia.nasif@yahoo.com', 'شارع الفروانية، بناية 45، شقة 9', farwaniya_id, 'active', '2023-07-08', 175.850, 'cash'),
    ('294567890123', 'ماجد', 'العازمي', '1983-05-23', '+965 9000 1015', 'majid.azmi@outlook.com', 'طريق الأحمدي، فيلا 78', ahmadi_id, 'active', '2022-12-18', 355.300, 'credit_card'),

    ('295678901234', 'لطيفة', 'الكندري', '1990-09-11', '+965 9000 1016', 'latifa.kandari@gmail.com', 'شارع الجهراء، بناية 123، شقة 4', jahra_id, 'active', '2023-04-05', 215.550, 'knet'),
    ('296789012345', 'بدر', 'الزعبي', '1988-01-08', '+965 9000 1017', 'badr.zoabi@hotmail.com', 'شارع مبارك الكبير، فيلا 234', mubarak_id, 'active', '2023-08-12', 375.400, 'direct_debit'),
    ('297890123456', 'شيماء', 'الهاجري', '1985-12-03', '+965 9000 1018', 'shimaa.hajri@gmail.com', 'طريق الفنطاس، بناية 89، شقة 6', fintas_id, 'active', '2022-11-07', 185.600, 'bank_transfer'),
    ('298901234567', 'طلال', 'المنصور', '1987-04-26', '+965 9000 1019', 'talal.mansour@yahoo.com', 'شارع الرقة، فيلا 345', ruqai_id, 'active', '2023-05-30', 425.800, 'knet'),
    ('299012345678', 'دانة', 'الغانم', '1991-08-17', '+965 9000 1020', 'dana.ghanem@outlook.com', 'شارع كيفان، بناية 67، شقة 14', kaifan_id, 'active', '2023-01-09', 255.250, 'credit_card');

    -- Mark Civil ID numbers as used
    UPDATE valid_civil_ids SET is_used = TRUE WHERE civil_id_number IN (
        '280012345678', '281234567890', '282345678901', '283456789012', '284567890123',
        '285678901234', '286789012345', '287890123456', '288901234567', '289012345678',
        '290123456789', '291234567890', '292345678901', '293456789012', '294567890123',
        '295678901234', '296789012345', '297890123456', '298901234567', '299012345678'
    );
END $;

-- =========================================
-- CUSTOMER SUBSCRIPTIONS
-- =========================================

-- Create active subscriptions for customers (realistic mix)
INSERT INTO customer_subscriptions (customer_id, service_id, start_date, monthly_price_kwd, status, installation_required, installation_completed, contract_start, contract_end, auto_renewal)
SELECT
    c.customer_id,
    s.service_id,
    c.registration_date,
    ROUND(sp.base_price_kwd * sp.area_modifier - sp.promotion_discount, 3) as monthly_price_kwd,
    CASE
        WHEN s.requires_technician = TRUE AND RANDOM() < 0.1 THEN 'pending_installation'
        ELSE 'active'
    END as status,
    s.requires_technician,
    CASE WHEN s.requires_technician = TRUE THEN TRUE ELSE FALSE END,
    c.registration_date,
    c.registration_date + INTERVAL '1 year' * s.contract_duration_months / 12,
    TRUE
FROM customers c
JOIN service_areas sa ON c.area_id = sa.area_id
JOIN service_pricing sp ON sa.area_id = sp.area_id
JOIN services s ON sp.service_id = s.service_id
WHERE
    -- Assign services based on area capabilities and realistic distribution
    (
        (s.service_type = 'fiber' AND sa.fiber_available = TRUE AND RANDOM() < 0.6) OR
        (s.service_type = 'adsl' AND sa.fiber_available = FALSE AND RANDOM() < 0.8) OR
        (s.service_type = 'mobile_voice' AND RANDOM() < 0.7) OR
        (s.service_type = 'bundle' AND sa.fiber_available = TRUE AND RANDOM() < 0.3)
    )
    AND s.is_active = TRUE
ORDER BY c.customer_id, RANDOM()
LIMIT 35; -- Ensure we don't create too many subscriptions

-- =========================================
-- SUPPORT TICKETS AND VISITS
-- =========================================

-- Generate some realistic support tickets in Arabic
INSERT INTO support_tickets (customer_id, ticket_type, title, description, status, priority, assigned_agent, ai_generated)
SELECT
    c.customer_id,
    (ARRAY['technical_issue', 'billing_inquiry', 'service_change'])[floor(random() * 3 + 1)],
    CASE
        WHEN random() < 0.4 THEN 'مشكلة في الاتصال بالإنترنت'
        WHEN random() < 0.7 THEN 'استفسار عن الفاتورة'
        ELSE 'طلب زيادة السرعة'
    END,
    CASE
        WHEN random() < 0.4 THEN 'الإنترنت بطيء جداً ومنقطع باستمرار. أضواء المودم تومض.'
        WHEN random() < 0.7 THEN 'هناك رسوم في فاتورة هذا الشهر لا أفهمها. أريد توضيح.'
        ELSE 'أريد زيادة سرعة الإنترنت الحالية. ما هي الخيارات المتاحة؟'
    END,
    (ARRAY['open', 'in_progress', 'resolved'])[floor(random() * 3 + 1)],
    (ARRAY['low', 'medium', 'high'])[floor(random() * 3 + 1)],
    'ai_agent_' || floor(random() * 5 + 1)::text,
    TRUE
FROM customers c
WHERE random() < 0.4  -- 40% of customers have tickets
ORDER BY random()
LIMIT 8;

-- Generate technician visits for installations and repairs
INSERT INTO technician_visits (customer_id, subscription_id, visit_type, scheduled_date, scheduled_time_slot, status, technician_name, work_description)
SELECT
    cs.customer_id,
    cs.subscription_id,
    CASE
        WHEN cs.status = 'pending_installation' THEN 'installation'
        ELSE 'repair'
    END,
    CURRENT_DATE + INTERVAL '1 day' * floor(random() * 30 + 1), -- Next 30 days
    (ARRAY['08:00-10:00', '10:00-12:00', '14:00-16:00', '16:00-18:00'])[floor(random() * 4 + 1)],
    (ARRAY['scheduled', 'confirmed', 'completed'])[floor(random() * 3 + 1)],
    (ARRAY['محمد الفني', 'أحمد الفني', 'فاطمة الفنية', 'علي الفني'])[floor(random() * 4 + 1)],
    CASE
        WHEN random() < 0.5 THEN 'تمديد كابل الفايبر وتركيب المودم'
        ELSE 'فحص الاتصال الحالي والإصلاح'
    END
FROM customer_subscriptions cs
WHERE cs.installation_required = TRUE OR random() < 0.2
ORDER BY random()
LIMIT 10;

-- =========================================
-- BILLING DATA
-- =========================================

-- Generate bills for the last 3 months
INSERT INTO billing (customer_id, bill_date, due_date, billing_period_start, billing_period_end, subtotal_kwd, tax_kwd, total_amount_kwd, payment_status, payment_date, payment_method, bill_items, payment_link)
SELECT
    c.customer_id,
    date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * generate_series(0, 2), -- Last 3 months
    date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * generate_series(0, 2) + INTERVAL '20 days',
    date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * (generate_series(0, 2) + 1),
    date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * generate_series(0, 2) - INTERVAL '1 day',
    monthly_total, -- No tax breakdown for Kuwait currently
    0.000, -- No VAT in Kuwait for telecom
    monthly_total,
    CASE
        WHEN generate_series(0, 2) = 0 THEN 'pending' -- Current month pending
        WHEN random() < 0.9 THEN 'paid' -- 90% paid
        ELSE 'overdue'
    END,
    CASE
        WHEN generate_series(0, 2) > 0 AND random() < 0.9 THEN
            date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * generate_series(0, 2) + INTERVAL '15 days'
        ELSE NULL
    END,
    c.payment_method,
    json_build_array(
        json_build_object(
            'service_name', 'اشتراك الإنترنت',
            'amount', monthly_total * 0.7,
            'period', to_char(date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * generate_series(0, 2), 'YYYY-MM')
        ),
        json_build_object(
            'service_name', 'الخط المحمول',
            'amount', monthly_total * 0.3,
            'period', to_char(date_trunc('month', CURRENT_DATE) - INTERVAL '1 month' * generate_series(0, 2), 'YYYY-MM')
        )
    ),
    'https://payment.zain.com.kw/pay/' || substr(md5(c.customer_id::text), 1, 12)
FROM customers c
JOIN (
    SELECT
        customer_id,
        SUM(monthly_price_kwd) as monthly_total
    FROM customer_subscriptions
    WHERE status = 'active'
    GROUP BY customer_id
) cs ON c.customer_id = cs.customer_id;

-- =========================================
-- AI CONVERSATION EXAMPLES
-- =========================================

-- Sample conversation sessions in Arabic
INSERT INTO agent_conversations (customer_id, session_status, conversation_state, conversation_summary, context_variables, collected_entities, channel, language) VALUES
-- Active customer checking bill
((SELECT customer_id FROM customers WHERE civil_id_number = '280012345678'), 'completed', 'completed',
 'العميل استفسر عن الفاتورة وحصل على معلومات موعد الدفع.',
 '{"intent": "bill_inquiry", "resolved": true, "total_messages": 4}',
 '{"customer_name": "أحمد الصباح", "query_type": "billing", "satisfaction": "high"}',
 'voice', 'ar'),

-- New prospect interested in fiber
(NULL, 'active', 'collecting_info',
 'عميل جديد يريد معلومات عن الفايبر، يتم جمع المعلومات الشخصية.',
 '{"intent": "new_subscription", "service_interest": "fiber", "step": "personal_info", "total_messages": 6}',
 '{"prospect_name": "سعد المطيري", "civil_id_interest": true, "address_provided": false, "service_type": "fiber"}',
 'voice', 'ar'),

-- Technical support conversation
((SELECT customer_id FROM customers WHERE civil_id_number = '281234567890'), 'completed', 'completed',
 'دعم فني - مشكلة اتصال الإنترنت، تم حجز موعد فني.',
 '{"intent": "technical_support", "issue_resolved": true, "visit_scheduled": true, "total_messages": 8}',
 '{"issue_type": "connection_problem", "urgency": "medium", "solution": "technician_visit"}',
 'voice', 'ar');

-- Sample conversation messages in Arabic
INSERT INTO conversation_messages (conversation_id, sequence_number, routed_agent, routing_reason, user_message, ai_response, response_time_ms, confidence_score, extracted_entities)
SELECT
    ac.conversation_id,
    1,
    'supervisor',
    'Initial routing decision',
    'السلام عليكم، أريد معرفة فاتورتي',
    'وعليكم السلام! يسعدني مساعدتك في معرفة تفاصيل فاتورتك. هل يمكنك إعطائي رقم الهوية المدنية؟',
    1200,
    0.95,
    '{"intent": "billing_inquiry", "language": "arabic"}'
FROM agent_conversations ac WHERE ac.conversation_state = 'completed' LIMIT 1;

INSERT INTO conversation_messages (conversation_id, sequence_number, routed_agent, routing_reason, user_message, ai_response, response_time_ms, confidence_score, sql_queries_executed, database_changes)
SELECT
    ac.conversation_id,
    2,
    'nl2sql',
    'Customer data query needed',
    'رقم هويتي 280012345678',
    'وجدت معلوماتك! أخ أحمد الصباح، فاتورتك الحالية 65.500 دينار كويتي وآخر موعد للدفع 25 ديسمبر. هل تريد الدفع؟',
    2100,
    0.88,
    '["SELECT * FROM customer_360_view WHERE civil_id_number = ''280012345678''"]',
    '{}'
FROM agent_conversations ac WHERE ac.conversation_state = 'completed' LIMIT 1;

-- =========================================
-- COMMENTS AND FINAL SETUP
-- =========================================

-- Update customer spending based on their bills
UPDATE customers SET total_spending = (
    SELECT COALESCE(SUM(total_amount_kwd), 0)
    FROM billing b
    WHERE b.customer_id = customers.customer_id
    AND b.payment_status = 'paid'
);

-- Final data verification
SELECT
    'Customers' as table_name, COUNT(*) as record_count FROM customers
UNION ALL
SELECT 'Services', COUNT(*) FROM services
UNION ALL
SELECT 'Service Areas', COUNT(*) FROM service_areas
UNION ALL
SELECT 'Active Subscriptions', COUNT(*) FROM customer_subscriptions WHERE status = 'active'
UNION ALL
SELECT 'Support Tickets', COUNT(*) FROM support_tickets
UNION ALL
SELECT 'Technician Visits', COUNT(*) FROM technician_visits
UNION ALL
SELECT 'Bills Generated', COUNT(*) FROM billing
UNION ALL
SELECT 'AI Conversations', COUNT(*) FROM agent_conversations;
