# -*- coding: utf-8 -*-
"""
Zain Kuwait Agent with Clean Supervisor Routing
Adapted from Turkish Telecom for Kuwait market
"""

import os
import sys

# Fix encoding for Windows console
if sys.platform.startswith('win'):
    os.system('chcp 65001 > NUL 2>&1')  # Set console to UTF-8
import json
import uuid
from datetime import datetime
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
import boto3

from langchain.tools import StructuredTool

load_dotenv()

# AWS credentials setup
os.environ['AWS_ACCESS_KEY_ID'] = 'your_access_id :) '
os.environ['AWS_SECRET_ACCESS_KEY'] = 'your secret key :) '
os.environ['AWS_REGION'] = 'us-east-1'

# =========================================
# DATABASE CONNECTION - ZAIN KUWAIT
# =========================================

class ZainDB:
    def __init__(self):
        self.connection = None
        self.connect()

    def connect(self):
        try:
            # Default connection to EC2 PostgreSQL
            host = os.getenv('DB_HOST', '18.184.17.148')  # Your EC2 IP
            database = os.getenv('DB_NAME', 'zain_db')
            user = os.getenv('DB_USER', 'postgres')
            password = os.getenv('DB_PASSWORD', 'postgres')  # Update with your password
            port = os.getenv('DB_PORT', '5432')

            self.connection = psycopg2.connect(
                host=host,
                database=database,
                user=user,
                password=password,
                port=port,
                cursor_factory=RealDictCursor
            )
            print("[SUCCESS] Zain Kuwait Database connected successfully")
            print(f"[INFO] Connected to {host}:{port}/{database}")
        except Exception as e:
            print(f"[ERROR] Database connection failed: {e}")
            self.connection = None

    def get_customer_by_civil_id(self, civil_id_number: str):
        """Look up customer by Kuwait Civil ID"""
        if not self.connection:
            return {}
        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM customers WHERE civil_id_number = %s", (civil_id_number,))
                result = cursor.fetchone()
                return dict(result) if result else {}
        except Exception as e:
            print(f"Database error: {e}")
            return {}

    def get_pending_bills(self, customer_id: str):
        """Get customer pending bills in KWD"""
        if not self.connection:
            return []
        try:
            with self.connection.cursor() as cursor:
                cursor.execute("""
                    SELECT * FROM bills
                    WHERE customer_id = %s AND payment_status IN ('pending', 'overdue')
                    ORDER BY due_date ASC
                """, (customer_id,))
                return [dict(row) for row in cursor.fetchall()]
        except Exception as e:
            print(f"Database error: {e}")
            return []

    def get_service_areas(self):
        """Get Kuwait service areas"""
        if not self.connection:
            return []
        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM service_areas ORDER BY governorate, area_name")
                return [dict(row) for row in cursor.fetchall()]
        except Exception as e:
            print(f"Database error: {e}")
            return []

db = ZainDB()

# =========================================
# AWS BEDROCK SETUP
# =========================================

# Initialize Bedrock client
bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')

# Bedrock model configuration
BEDROCK_MODEL_ID = "us.meta.llama4-scout-17b-instruct-v1:0"
BEDROCK_CONFIG = {
    "maxTokens": 150,
    "temperature": 0.1,
    "topP": 0.9
}

def call_bedrock(system_prompt: str, user_message: str, conversation_history: list = None) -> str:
    """Call AWS Bedrock Converse API with Arabic/English support"""
    try:
        # Build messages list from conversation history
        messages = []
        if conversation_history:
            for exchange in conversation_history[-5:]:  # Keep last 5 exchanges
                if 'user_message' in exchange and 'response' in exchange:
                    messages.append({
                        "role": "user",
                        "content": [{"text": exchange['user_message']}]
                    })
                    messages.append({
                        "role": "assistant",
                        "content": [{"text": exchange['response']}]
                    })

        # Add current user message
        messages.append({
            "role": "user",
            "content": [{"text": user_message}]
        })

        response = bedrock_runtime.converse(
            modelId=BEDROCK_MODEL_ID,
            system=[{"text": system_prompt}],
            messages=messages,
            inferenceConfig=BEDROCK_CONFIG
        )

        return response['output']['message']['content'][0]['text']

    except Exception as e:
        print(f"[ERROR] Bedrock error: {e}")
        return f"آسف، حدث خطأ: {str(e)}"

# =========================================
# TOOLS - ZAIN KUWAIT
# =========================================

def customer_lookup_tool(civil_id_number: str) -> str:
    """Look up customer by Kuwait Civil ID number"""
    # Database lookup

    if not civil_id_number or len(civil_id_number) != 12 or not civil_id_number.isdigit():
        return "[ERROR] رقم الهوية المدنية غير صحيح. يجب أن يكون 12 رقم."

    customer_data = db.get_customer_by_civil_id(civil_id_number)
    if customer_data:
        result = f"""[SUCCESS] تم العثور على العميل:
👤 الاسم: {customer_data['first_name']} {customer_data['last_name']}
📞 الهاتف: {customer_data.get('phone', 'غير مسجل')}
💰 إجمالي الإنفاق: {customer_data.get('total_spending', 0)} د.ك
📍 الحالة: {customer_data.get('account_status', 'غير معروف')}"""
        # Customer found
        return result
    else:
        # Customer not found
        return "[ERROR] لم يتم العثور على عميل بهذا الرقم المدني."

def get_customer_bills_tool(customer_id: str) -> str:
    """Get customer pending bills in KWD"""
    # Getting customer bills

    if not customer_id:
        return "[ERROR] معرف العميل مطلوب."

    bills = db.get_pending_bills(customer_id)
    if not bills:
        # No pending bills
        return "[SUCCESS] لا توجد فواتير معلقة."

    total_amount = sum(float(bill['amount_kwd']) for bill in bills)
    bill_details = []
    for bill in bills:
        bill_details.append(f"• {bill['bill_date']} - {bill['amount_kwd']} د.ك (تاريخ الاستحقاق: {bill['due_date']})")

    result = f"""[BILLING] فواتيرك المعلقة:
{chr(10).join(bill_details)}

💰 إجمالي المبلغ المستحق: {total_amount} د.ك

🔥 خيارات الدفع:
• K-Net (الأسرع)
• تحويل بنكي
• فروع زين
• تطبيق زين"""

    # Bills retrieved
    return result

def get_service_areas_tool() -> str:
    """Get Kuwait service coverage areas"""
    # Getting service areas

    areas = db.get_service_areas()
    if not areas:
        return "[ERROR] خطأ في الحصول على مناطق التغطية."

    area_list = []
    current_gov = ""
    for area in areas:
        if area['governorate'] != current_gov:
            current_gov = area['governorate']
            area_list.append(f"\n📍 {current_gov}:")

        fiber_status = "[SUCCESS] فايبر متوفر" if area['fiber_available'] else "[ERROR] فايبر غير متوفر"
        quality = area['coverage_quality']
        quality_ar = {'excellent': 'ممتاز', 'good': 'جيد', 'basic': 'أساسي'}.get(quality, quality)

        area_list.append(f"  • {area['area_name']} - {fiber_status} - جودة التغطية: {quality_ar}")

    result = f"""[MAP] مناطق تغطية زين في الكويت:
{''.join(area_list)}

📞 للاستفسار عن منطقتك، اتصل على: 107"""

    # Service areas retrieved
    return result

# =========================================
# AGENT CLASSES - ZAIN KUWAIT
# =========================================

class SupervisorAgent:
    """Main routing supervisor for Zain Kuwait"""

    def __init__(self):
        self.system_prompt = """أنت مشرف كويتي ذكي لنظام خدمة عملاء شركة زين الخليجية.

مهمتك:
1. تحليل رسائل العملاء وتوجيهها للوكيل المناسب
2. التأكد من تقديم خدمة عملاء ممتازة باللغة العربية الكويتية
3. مساعدة العملاء الكويتيين في جميع استفساراتهم
4. ردود مناسبة وسريعة

الوكلاء المتاحين:
- direct_response: للردود المباشرة والتحيات
- nl2sql: للبحث في قاعدة البيانات (الهوية المدنية، الفواتير، الخدمات)
- payment: للدفع الإلكتروني والمدفوعات
- onboarding: لتسجيل العملاء الجدد والاشتراكات
- websearch: للبحث عن معلومات حديثة
- rag: للمساعدة التقنية المتقدمة

قواعد الكويت:
- استخدم الهوية المدنية (12 رقم) 
- العملة: دينار كويتي (د.ك)
- المناطق: محافظات الكويت
- أسلوب مهذب ومحترم

اختر الوكيل الأنسب وقدم سبب الاختيار."""

    def route_message(self, user_message: str, conversation_history: list = None) -> dict:
        try:
            # Check if session should persist FIRST (before Bedrock routing)
            if conversation_history and len(conversation_history) > 0:
                last_agent = conversation_history[-1].get('agent', '')
                if last_agent in ['onboarding', 'payment']:
                    return {
                        "agent": last_agent,
                        "reasoning": "Session persistence",
                        "priority": "عالي"
                    }

            routing_prompt = f"""حلل هذه الرسالة واختر الوكيل المناسب:

رسالة العميل: "{user_message}"

أجب بصيغة JSON فقط:
{{
    "agent": "اسم_الوكيل",
    "reasoning": "سبب الاختيار",
    "priority": "منخفض/متوسط/عالي"
}}"""

            response = call_bedrock(self.system_prompt, routing_prompt, conversation_history)

            # Try to parse JSON response
            try:
                # Extract JSON from response
                json_start = response.find('{')
                json_end = response.rfind('}') + 1
                if json_start != -1 and json_end > json_start:
                    json_str = response[json_start:json_end]
                    routing_decision = json.loads(json_str)
                else:
                    raise ValueError("No JSON found")
            except:
                # Check if onboarding or payment session is active
                if conversation_history and len(conversation_history) > 0:
                    last_agent = conversation_history[-1].get('agent', '')
                    if last_agent == 'onboarding':
                        agent = 'onboarding'
                    elif last_agent == 'payment':
                        agent = 'payment'
                    else:
                        # Fallback routing logic
                        user_lower = user_message.lower()
                        if any(keyword in user_lower for keyword in ['دفع', 'فاتورة', 'سداد', 'دين']):
                            agent = 'payment'
                        elif any(keyword in user_lower for keyword in ['اشتراك', 'عميل جديد', 'تسجيل', 'انضمام']):
                            agent = 'onboarding'
                        elif any(keyword in user_lower for keyword in ['هوية', 'مدني', 'حساب', 'معلومات']):
                            agent = 'nl2sql'
                        elif any(keyword in user_lower for keyword in ['مرحبا', 'السلام', 'شكرا']):
                            agent = 'direct_response'
                        else:
                            agent = 'direct_response'
                else:
                    # Fallback routing logic
                    user_lower = user_message.lower()
                    if any(keyword in user_lower for keyword in ['دفع', 'فاتورة', 'سداد', 'دين']):
                        agent = 'payment'
                    elif any(keyword in user_lower for keyword in ['اشتراك', 'عميل جديد', 'تسجيل', 'انضمام']):
                        agent = 'onboarding'
                    elif any(keyword in user_lower for keyword in ['هوية', 'مدني', 'حساب', 'معلومات']):
                        agent = 'nl2sql'
                    elif any(keyword in user_lower for keyword in ['مرحبا', 'السلام', 'شكرا']):
                        agent = 'direct_response'
                    else:
                        agent = 'direct_response'

                routing_decision = {
                    "agent": agent,
                    "reasoning": "Fallback routing",
                    "priority": "متوسط"
                }

            # Debug: Routing completed

            return routing_decision

        except Exception as e:
            print("[ERROR] Routing error occurred")
            return {
                "agent": "direct_response",
                "reasoning": "Error fallback",
                "priority": "متوسط"
            }

class DirectAgent:
    """Direct response agent for simple queries"""

    def __init__(self):
        self.system_prompt = """أنت وكيل كويتي ذكي لخدمة عملاء زين في الكويت للردود المباشرة.

أسلوبك:
- مهذب ومحترم
- استخدام اللغة العربية الكويتية
- الردود مختصرة وواضحة
- مساعدة العملاء الكويتيين
- ذكر خدمات زين الكويت عند الحاجة

معلومات زين الكويت:
- رقم خدمة العملاء: 107
- التطبيق: تطبيق زين
- الموقع: zain.com.kw
- خدمات: فايبر، موبايل، إنترنت، باقات"""

    def process(self, user_message: str, conversation_history: list = None) -> str:
        try:
            response = call_bedrock(self.system_prompt, user_message, conversation_history)
            return response
        except Exception as e:
            print(f"[ERROR] Direct agent error: {e}")
            return "أعتذر، حدث خطأ. يرجى المحاولة مرة أخرى أو الاتصال على 107."

class PaymentAgent:
    """Payment processing agent for Zain Kuwait"""

    def __init__(self):
        self.system_prompt = """أنت وكيل المدفوعات لشركة زين الكويت.

مهمتك:
- مساعدة العملاء في دفع فواتيرهم
- توجيههم لروابط الدفع الآمنة
- تأكيد المبالغ قبل الدفع
- ردود سريعة ومفيدة

خيارات الدفع المتاحة:
- K-Net (الأسرع والأكثر أماناً)
- بطاقات الائتمان (فيزا، ماستركارد)
- تطبيق زين
- فروع زين

اجعل العملية بسيطة وواضحة."""

    def process(self, user_message: str, session_memory: dict) -> str:
        """Process payment requests"""
        try:
            current_customer = session_memory.get('current_customer')

            # Check if user provided Civil ID
            if not current_customer:
                import re
                civil_id_match = re.search(r'\b\d{12}\b', user_message)
                if civil_id_match:
                    civil_id = civil_id_match.group()
                    # Lookup customer and store in session
                    customer_data = db.get_customer_by_civil_id(civil_id)
                    if customer_data:
                        session_memory['current_customer'] = customer_data
                        current_customer = customer_data
                    else:
                        return f"[ERROR] لم يتم العثور على عميل بالهوية المدنية {civil_id}"
                else:
                    return "يرجى ذكر رقم الهوية المدنية أولاً للمتابعة مع الدفع."

            # Get pending bills
            bills = db.get_pending_bills(current_customer['customer_id'])
            if not bills:
                return "[SUCCESS] ليس لديك فواتير معلقة للدفع."

            total_amount = sum(float(bill['amount_kwd']) for bill in bills)

            # Generate payment link (simulated)
            payment_link = f"https://pay.zain.com.kw/customer/{current_customer['customer_id']}"

            return f"""[BILLING] دفع الفواتير:
👤 {current_customer['first_name']} {current_customer['last_name']}
💰 المبلغ الإجمالي: {total_amount} د.ك

🔗 رابط الدفع الآمن:
{payment_link}

📱 أو ادفع عبر:
• تطبيق زين
• K-Net
• فروع زين

⚠️ الرابط صالح لمدة 30 دقيقة"""

        except Exception as e:
            print(f"[ERROR] Payment agent error: {e}")
            return "أعتذر، حدث خطأ في معالجة الدفع. جرب لاحقاً أو اتصل على 107."

class OnboardingAgent:
    """New customer onboarding agent"""
    
    def __init__(self):
        self.system_prompt = """أنت وكيل تسجيل العملاء الجدد في زين الكويت.

مهمتك:
- الترحيب بالعملاء الجدد
- جمع المعلومات الشخصية (الاسم، الهوية المدنية، الهاتف، الإيميل)
- عرض الخدمات المتاحة
- مساعدتهم في اختيار الباقة المناسبة
- تسجيلهم في النظام

كن ودوداً ومفيداً واجمع المعلومات تدريجياً."""

    def get_services_catalog(self):
        """Get available services for new customers"""
        try:
            with db.connection.cursor() as cursor:
                cursor.execute("""
                    SELECT type_name, monthly_price_kwd, description
                    FROM subscription_types
                    ORDER BY monthly_price_kwd
                """)
                return [dict(row) for row in cursor.fetchall()]
        except Exception as e:
            print(f"Database error: {e}")
            return []

    def process(self, user_message: str, session_memory: dict) -> str:
        """Process onboarding requests"""
        try:
            user_lower = user_message.lower()

            # Check onboarding stage
            onboarding_stage = session_memory.get('context', {}).get('onboarding_stage', 'welcome')

            if onboarding_stage == 'welcome':
                session_memory['context']['onboarding_stage'] = 'collecting_info'
                return """[KW] أهلاً وسهلاً بك في زين الكويت!

سعداء بانضمامك لعائلة زين. لتقديم أفضل خدمة لك، سأحتاج بعض المعلومات:

[REASON] يرجى ذكر اسمك الكامل أولاً."""

            elif onboarding_stage == 'collecting_info':
                # Store collected information
                if 'prospect_info' not in session_memory['context']:
                    session_memory['context']['prospect_info'] = {}

                prospect_info = session_memory['context']['prospect_info']

                if 'name' not in prospect_info:
                    prospect_info['name'] = user_message
                    return "شكراً لك. الآن يرجى ذكر رقم الهوية المدنية (12 رقم):"

                elif 'civil_id' not in prospect_info:
                    import re
                    civil_id_match = re.search(r'\b\d{12}\b', user_message)
                    if civil_id_match:
                        prospect_info['civil_id'] = civil_id_match.group()
                        return "ممتاز! الآن يرجى ذكر رقم الهاتف:"
                    else:
                        return "يرجى إدخال رقم هوية مدنية صحيح (12 رقم):"

                elif 'phone' not in prospect_info:
                    prospect_info['phone'] = user_message
                    return "الآن يرجى ذكر الإيميل الإلكتروني:"

                elif 'email' not in prospect_info:
                    prospect_info['email'] = user_message
                    session_memory['context']['onboarding_stage'] = 'show_services'

                    # Show services catalog
                    services = self.get_services_catalog()
                    services_text = "\n".join([
                        f"• {service['type_name']}: {service['monthly_price_kwd']} د.ك - {service['description']}"
                        for service in services[:4]  # Show top 4 services
                    ])

                    return f"""[SUCCESS] شكراً لك! معلوماتك:
👤 {prospect_info['name']}
🆔 {prospect_info['civil_id']}
📞 {prospect_info['phone']}
📧 {prospect_info['email']}

📋 خدماتنا المتاحة:
{services_text}

أي خدمة تهمك أكثر؟"""

            else:
                return "شكراً لاهتمامك بزين الكويت! سيتصل بك أحد ممثلينا خلال 24 ساعة لإكمال التسجيل."

        except Exception as e:
            print(f"[ERROR] Onboarding agent error: {e}")
            return "أعتذر، حدث خطأ. سيتصل بك أحد ممثلينا قريباً."

class SQLAgent:
    """Database query agent for Zain Kuwait"""

    def __init__(self):
        self.system_prompt = """أنت وكيل قاعدة البيانات لزين الكويت.

وظائفك:
1. البحث عن العملاء بالهوية المدنية الكويتية (12 رقم)
2. عرض فواتير العملاء بالدينار الكويتي
3. معلومات مناطق التغطية في الكويت

الأدوات المتاحة:
- customer_lookup_tool(civil_id): البحث بالهوية المدنية
- get_customer_bills_tool(customer_id): عرض الفواتير
- get_service_areas_tool(): مناطق التغطية

استخدم الأدوات عند الحاجة وقدم نتائج واضحة باللغة العربية."""

        # Create LangChain tools
        self.tools = [
            StructuredTool.from_function(
                func=customer_lookup_tool,
                name="customer_lookup",
                description="Look up customer by Kuwait Civil ID number"
            ),
            StructuredTool.from_function(
                func=get_customer_bills_tool,
                name="get_bills",
                description="Get customer pending bills"
            ),
            StructuredTool.from_function(
                func=get_service_areas_tool,
                name="get_areas",
                description="Get Kuwait service areas"
            )
        ]

    def process(self, user_message: str, conversation_history: list = None) -> str:
        try:
            # Simple tool detection based on keywords
            user_lower = user_message.lower()

            if any(keyword in user_lower for keyword in ['هوية', 'مدني', 'رقم']):
                # Extract Civil ID if present
                import re
                civil_id_match = re.search(r'\b\d{12}\b', user_message)
                if civil_id_match:
                    civil_id = civil_id_match.group()
                    return customer_lookup_tool(civil_id)
                else:
                    return "يرجى تقديم رقم الهوية المدنية الكويتية (12 رقم)."

            elif any(keyword in user_lower for keyword in ['فاتورة', 'دفع', 'مستحق']):
                return "يرجى تقديم رقم الهوية المدنية أولاً للبحث عن فواتيرك."

            elif any(keyword in user_lower for keyword in ['منطقة', 'تغطية', 'فايبر']):
                return get_service_areas_tool()

            else:
                # Use Bedrock for complex SQL queries
                sql_prompt = f"""حلل هذا الطلب وحدد الإجراء المطلوب:

الطلب: "{user_message}"

إذا كان يحتاج:
- بحث عن عميل: اطلب الهوية المدنية
- عرض فواتير: ابحث عن العميل أولاً
- معلومات التغطية: استخدم أداة المناطق

أجب باللغة العربية."""

                response = call_bedrock(self.system_prompt, sql_prompt, conversation_history)
                # SQL analysis completed
                return response

        except Exception as e:
            print(f"[ERROR] SQL agent error: {e}")
            return "أعتذر، حدث خطأ في البحث. يرجى المحاولة مرة أخرى."

class ZainMultiAgent:
    """Main Zain Kuwait Multi-Agent System"""

    def __init__(self):
        self.supervisor = SupervisorAgent()
        self.direct_agent = DirectAgent()
        self.sql_agent = SQLAgent()
        self.payment_agent = PaymentAgent()
        self.onboarding_agent = OnboardingAgent()
        self.conversation_history = []
        self.session_memory = {'context': {}}  # Shared session memory

        # System initialized

    def process_message(self, user_message: str) -> str:
        try:
            # Debug: User message received

            # Route the message
            routing = self.supervisor.route_message(user_message, self.conversation_history)
            agent_choice = routing['agent']

            # Process with chosen agent
            if agent_choice == 'nl2sql':
                response = self.sql_agent.process(user_message, self.conversation_history)
            elif agent_choice == 'payment':
                response = self.payment_agent.process(user_message, self.session_memory)
            elif agent_choice == 'onboarding':
                response = self.onboarding_agent.process(user_message, self.session_memory)
            else:  # direct_response, websearch, rag
                response = self.direct_agent.process(user_message, self.conversation_history)

            # Store in conversation history
            self.conversation_history.append({
                'user_message': user_message,
                'response': response,
                'agent': agent_choice,
                'timestamp': datetime.now().isoformat()
            })

            # Keep only last 10 exchanges
            if len(self.conversation_history) > 10:
                self.conversation_history = self.conversation_history[-10:]

            print(f"Zain: {response}")
            return response

        except Exception as e:
            print(f"System error: {e}")
            return "أعتذر، حدث خطأ في النظام. يرجى الاتصال على 107 للمساعدة."

# =========================================
# MAIN EXECUTION
# =========================================

def main():
    """Main function to run the Zain Kuwait Agent"""

    print("Welcome to Zain Kuwait Smart System")
    print("=" * 50)

    # Initialize agent
    agent = ZainMultiAgent()

    print("\nExamples:")
    print("- Customer lookup: رقم هويتي 280012345678")
    print("- Payment: أريد دفع فاتورتي")
    print("- New subscription: أريد اشتراك جديد")
    print("- Greeting: مرحباً")
    print("\nType 'exit' to quit\n")

    while True:
        try:
            user_input = input("You: ").strip()

            if user_input.lower() in ['خروج', 'exit', 'quit', 'q']:
                print("\nThank you for using Zain Kuwait services!")
                break

            if not user_input:
                continue

            response = agent.process_message(user_input)
            print()  # Empty line for readability

        except KeyboardInterrupt:
            print("\n\nSystem terminated. Thank you!")
            break
        except Exception as e:
            print(f"\n[ERROR] Error: {e}")
            print("Please try again.\n")

if __name__ == "__main__":
    main()
