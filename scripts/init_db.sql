-- Enable Write-Ahead Logging (WAL) Mode for microsecond concurrent reads on low-RAM devices
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;

-- 1. NIPUN Bharat Foundational Literacy & Numeracy (FLN) Lakshyas
CREATE TABLE IF NOT EXISTS fln_targets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    grade_level TEXT NOT NULL,           -- e.g., 'Balvatika', 'Grade 1', 'Grade 2', 'Grade 3'
    subject TEXT NOT NULL,               -- 'Literacy' or 'Numeracy'
    target_code TEXT UNIQUE NOT NULL,    -- e.g., 'L1_G1_01'
    description_hindi TEXT NOT NULL,     -- Original Hindi curriculum requirement
    difficulty_rank INTEGER DEFAULT 1
);

-- 2. Localized Vernacular Dictionary (Hindi <-> Native Dialects)
CREATE TABLE IF NOT EXISTS dictionary (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hindi_term TEXT NOT NULL,
    santhali_term TEXT,
    santhali_script_ol_chiki TEXT,       -- Native Ol Chiki script rendering
    mundari_term TEXT,
    ho_term TEXT,
    ho_script_warang_chiti TEXT,        -- Native Warang Chiti script rendering
    phonetic_ipa TEXT,
    category TEXT                       -- 'numbers', 'fauna', 'flora', 'basic_verbs'
);

-- 3. Local Metaphor Swapper (Textbook Context -> Tribal Context Adaptation)
CREATE TABLE IF NOT EXISTS metaphor_swaps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    standard_textbook_metaphor TEXT NOT NULL,  -- e.g., 'Traffic lights'
    tribal_cultural_metaphor TEXT NOT NULL,    -- e.g., 'Mahua flowers' or 'Sal leaves'
    region_belt TEXT DEFAULT 'Jharkhand_Tribal_Belt'
);

-- ============================================================================
-- SEED DATA SETUP FOR PROTOTYPE DEMO
-- ============================================================================

-- Seed NIPUN Bharat Targets (Grade 1 Numeracy & Literacy)
INSERT INTO fln_targets (grade_level, subject, target_code, description_hindi, difficulty_rank) 
VALUES 
('Grade 1', 'Numeracy', 'NUM_G1_01', '20 तक की वस्तुओं को गिनना', 1),
('Grade 1', 'Literacy', 'LIT_G1_01', 'आयु-उपयुक्त अज्ञात पाठ से कम से कम 4-5 सरल शब्द पढ़ना', 1);

-- Seed Vernacular Terms (Hindi to Santhali & Script Mappings)
INSERT INTO dictionary (hindi_term, santhali_term, santhali_script_ol_chiki, mundari_term, ho_term, category) 
VALUES 
('पानी', 'दाः', 'ᱫᱟᱜ', 'दाअ', 'दाः', 'basics'),
('पेड़', 'दारᱮ', 'ᱫᱟᱨᱮ', 'दारु', 'दारु', 'nature'),
('फूल', 'बाहा', 'ᱵᱟᱦᱟ', 'बाहा', 'बाहा', 'nature'),
('गिनती', 'लेखा', 'ᱞᱮᱠᱷᱟ', 'लेखा', 'लेखा', 'math');

-- Seed Metaphor Swaps for Rural Jharkhand Classrooms
INSERT INTO metaphor_swaps (standard_textbook_metaphor, tribal_cultural_metaphor, region_belt) 
VALUES 
('ट्रैफिक लाइट की बत्तियां गिनना', 'महुआ के गिरे हुए फूल गिनना', 'Santhal Pargana'),
('बस की सीटें', 'बैलगाड़ी के पहिये', 'Chota Nagpur');
