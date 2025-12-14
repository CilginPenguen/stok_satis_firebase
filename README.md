
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
Masaüstü Giriş Sayfası 
<img width="1333" height="759" alt="image" src="https://github.com/user-attachments/assets/7926de6f-91c3-4cff-ac51-5969541c8647" />
Masaüstü Kayıt Sayfası
NOT=> Masaüstü uygulamasında Dükkan Sahibi Kayıt veya Giriş yapmadığı sürece personelin giriş ve kayıt işlemleri yapılamamaktadır.
<img width="1839" height="1128" alt="image" src="https://github.com/user-attachments/assets/7fc4658f-aaa1-4cb3-a8fd-03a6bde4aa7d" />
Dükkan Sahibinin Kayıt Oluşumu
<img width="1844" height="1132" alt="image" src="https://github.com/user-attachments/assets/a2b46759-9601-48b4-801f-f06d5d243ec3" />
Dükkan Sahibi olarak kayıt yapıldığında kişinin uygulama ile paylaşmış olduğu Mail adresine doğrulama linki yollanmaktadır. Bu arayüzde Dükkan Sahibi ihtiyaç duyduğu işlemleri yapabilmektedir.Dükkan Sahibi mailine gelmiş olan mail linkine tıkladıktan sonra Mail adresini doğrulamış olduktan sonra uygulamanın arayüzünden kontrol işlemi sonrası Kullanıcı Arayüzüne ulaşabilir.
<img width="1838" height="1126" alt="image" src="https://github.com/user-attachments/assets/f8de4b35-428a-4292-89c8-827b750d96c7" />
Personel telefondan veya bilgisayardan kayıt olduğunda Dükkan Sahibi tarafından onaylanmasını beklemektedir.
NOT:Her personel tek cihaza tanımlıdır. Personel giriş yaptığı cihaz haricinde giriş yapamamaktadır.
<img width="1838" height="1137" alt="image" src="https://github.com/user-attachments/assets/41a01f27-6249-4192-8967-b972cee10611" />
Dükkan Sahibi telefonundaki uygulama üzerinden personelinin uygulamaya erişimini kontrol edebilir.

<img width="1838" height="1134" alt="image" src="https://github.com/user-attachments/assets/97cebc1c-f020-49b9-8128-6d9eb1d74520" />
Giriş Yapılmış Kullanıcı Ana Sayfası
=> Bu Sayfada Kullanıcı, fiziksel barkod okuyucusuyla kaydırmalı butonları aktifleştirmediği taktirde hiçbir işlem yapılmayıp kaydırmalı butonlardan herhangi bir butonu aktifleştirdiği seçeneğe bağlı olarak işlem yapmaktadır.Sol tarafta bulunan seçeneklerden kullanıcı yapmak istediği işlem hakkındaki sayfaya yönlendirmeler bulunmaktadır.Personel olarak giriş yapıldığı durumda yandaki bulunan yönlendirmeler, personelin yetkisi bulunduğu sürece sayfayı açmaktadır. Yetkisi bulunmadığı sayfaya gitmek istediği taktirde karşısına dinamik alanda "Yetkiniz Bulunmamaktadır" bilgilendirmesi aktarılmaktadır.
<img width="1895" height="1120" alt="image" src="https://github.com/user-attachments/assets/d2c2c9d8-5aec-4d1d-b529-d4fc1b8da390" />
Ürünler Sayfasında kullanıcı kaydetmiş olduğu ürünleri kategorilere ayırılmış şekilde görüntüleyebilir kategori başlığı olduğu alanda kategori bazlı filtreleme uygulayarak ulaşmak istediği ürün hakkında işlem yapabilir.
=> Sağdan Sola kaydır işlemi=> Silme 
=> Yıldız=> Favorilere Ekleme
=> Üstüne tıklama=> Düzenleme
=> Ekle=> Sepete Ekleme işlemini yapmaktadır.
!! =>Sepete Eklenmiş Ürün sonrasında butonun bulunduğu alanda adeti düzenleyebileceği alan gelmektedir.
<img width="1896" height="1121" alt="image" src="https://github.com/user-attachments/assets/6fe3d1e2-9d48-4429-b805-fb4fe1e70116" />
Ürün Ekleme sayfasından kullanıcı ürünü hakkındaki bilgileri ekleyerek kaydetme işlemini yapabilir. "Kayıtlı Mı?" kaydırmalı butonunda eğer aynı kategori veya marka bulunmaktaysa butonu kaydırarak kayıtlı olan veriler ile eşleştirebilir.Barkod alanı manuel yazılabilmekte olup daha kısa yoldan yapılmak istenilirse platforma göre eklenme şekli değişiklik göstermektedir.
=> Mobil=> Ürün Barkodu alanının sağındaki Barkod butonundan kamera ile hızlıca ekleme yapabilir.
=> Bilgisayar=> Fiziksel Barkod okuyucu şartıyla alana tıklanıldıktan sonra fiziksel cihazdan okutulma yapılarak hızlıca ekleme yapılabilinmektedir.

<img width="1894" height="1119" alt="image" src="https://github.com/user-attachments/assets/085c0e72-7b98-41d1-b560-f47cc8e35934" />
  Geçmiş Sayfasından kullanıcı giriş yapmış kullanıcıya bağlı olarak değişiklik göstermektedir. Dükkan Sahibi tarafından giriş yapıldığı durumda Dükkan Sahibi tüm zamanlardaki yapılan satış işlemlerini ve kimin tarafından yapıldığını öğrenebilmektedir.
  Personel tarafından giriş yapıldığında ise sadece personelin yapmış olduğu satışlar görüntülenmektedir.

<img width="1896" height="1121" alt="image" src="https://github.com/user-attachments/assets/606234a0-f9f1-42fd-b5d2-902b7bdf5e21" />
Favoriler Sayfasında kullanıcı hızlıca erişmek istediği ürünlere bu sayfadan işlem yapabilmektedir.<img <img width="1892" height="1123" alt="image" src="https://github.com/user-attachments/assets/78f89c7d-ffda-4f67-8bc8-27e609635ee5" />

Ayarlar Sayfasından kullanıcı arayüz temasını değiştirebilir ve profiline erişebilir. Dükkan Sahibi giriş yapmış ise personelleri hakkındaki işlemlere erişebilir ve mobil versiyonunda personellere kendi ağlarına bağlanabilmek için kullanacakları Qr Kodu paylaşabilir.





<img width="1842" height="1130" alt="image" src="https://github.com/user-attachments/assets/d0f841f2-6235-4516-b3f7-146b24f1f914" />
<img width="1841" height="1127" alt="image" src="https://github.com/user-attachments/assets/fa594084-a006-42db-b501-cce4088889d9" />


<img width="1897" height="1124" alt="image" src="https://github.com/user-attachments/assets/7dddef73-32f6-4de9-918d-d73b29b4cf8b" />
Dükkan Sahibi, personelleri hakkında ihtiyaç duyduğu işlemleri Ayarlar>Profil sayfasından ulaşabilmekte ve personellerini kontrol edebilmektedir.







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
