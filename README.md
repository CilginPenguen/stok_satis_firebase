
# 📦 Stok Satış Firebase

Flutter & Firebase tabanlı stok ve satış takip uygulaması.  
Kullanıcılar ürün ekleyebilir, satış yapabilir, stok durumunu görüntüleyebilir ve geçmiş siparişleri inceleyebilir.  

---

## 🚀 Özellikler
- 🔑 **Kullanıcı Girişi & Kayıt** (Firebase Authentication, QR login desteği)  
- 📦 **Ürün Yönetimi** (Ekle, düzenle, sil, barkod ile tarama)  
- 🛒 **Sepet & Satış** (Ürünleri sepete ekleme, satış işlemi, geçmiş siparişler)  
- 📊 **Dashboard** (Günlük satış grafikleri, özet kartlar, analog saat widget)  
- 👥 **Personel Yönetimi** (Çalışan ekleme, onaylama, yetkilendirme)  
- 🎨 **Karanlık/Açık Tema** (ThemeService)  
- ⏱ **Ekran Koruyucu Modu**  
- ⚙️ **Ayarlar Sayfası** (Profil ayarları, tema, saat ayarları)  

---

## 🛠 Kullanılan Teknolojiler
- **Flutter** (3.x)  
- **Firebase**  
  - Authentication  
  - Firestore Database  
- **GetX** (State management, routing, dependency injection)  
- **Dart null-safety**  
- **Material Design UI**  

---

## 📂 Proje Yapısı
```
lib/
 ├── core/              # BaseController, app bindings
 ├── models/            # Veri modelleri (ürün, sipariş, kullanıcı vb.)
 ├── modules/           # Özellik bazlı sayfa ve controller yapısı
 │   ├── auth/          
 │   ├── basket/
 │   ├── dashboard/
 │   ├── history/
 │   ├── home/
 │   ├── login/
 │   ├── products/
 │   ├── profile/
 │   ├── screensaver/
 │   ├── settings/
 │   └── signup_temp/
 ├── routes/            # Uygulama rotaları
 ├── services/          # Firebase servisleri, tema & storage servisleri
 ├── splash/            # Splash ekranı
 ├── themes/            # Renkler ve tema ayarları
 └── utils/             # Yardımcı fonksiyonlar
```

---

## 📸 Ekran Görüntüleri
<img width="1330" height="755" alt="image" src="https://github.com/user-attachments/assets/d46d4e3e-0445-4d10-a34b-95e415ad971e" />


---

## ⚡ Kurulum
1. Repoyu klonla:
   ```bash
   git clone https://github.com/CilginPenguen/stok_satis_firebase.git
   cd stok_satis_firebase
   ```
2. Bağımlılıkları yükle:
   ```bash
   flutter pub get
   ```
3. Firebase’i yapılandır:  
   - Android için `google-services.json`  
   - iOS için `GoogleService-Info.plist` ekle  
   - `firebase_options.dart` dosyası otomatik oluşturulmalı (`flutterfire configure`)  
4. Çalıştır:
   ```bash
   flutter run
   ```

---

## 👨‍💻 Katkıda Bulunma
1. Fork yap  
2. Yeni branch aç (`git checkout -b feature/ozellik`)  
3. Değişiklikleri commit et  
4. Pull request gönder  

---
