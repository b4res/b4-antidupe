Config = {}

-- Genel Ayarlar
Config.ResetInterval = 60 -- Limitlerin sıfırlanma süresi (saniye cinsinden, 1 dakika = 60)
Config.WebhookURL = "YourWebhookLink" -- Discord webhook URL'si

-- Limit Ayarları
Config.Limits = {
    Weapon = 10,    -- 1 dakikada maksimum silah basma limiti
    Money = 10000,  -- 1 dakikada maksimum para basma limiti
    Item = 10,      -- 1 dakikada maksimum item basma limiti
    Vehicle = 2     -- 1 dakikada maksimum araç basma limiti
}

-- Log Başlıkları ve Renkleri
Config.Logs = {
    Weapon = { Title = "Silah Dupe Tespiti", Color = 16711680 }, -- Kırmızı
    Money = { Title = "Para Dupe Tespiti", Color = 65280 },      -- Yeşil
    Item = { Title = "Item Dupe Tespiti", Color = 255 },         -- Mavi
    Vehicle = { Title = "Araç Dupe Tespiti", Color = 16776960 }  -- Sarı
}

-- Admin Muafiyeti (qb-admin'deki admin paneline sahip olanlar)
Config.AdminExemption = true -- true: Adminler muaf, false: Adminler de etkilenir