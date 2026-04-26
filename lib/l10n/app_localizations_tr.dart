// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'MONK MODE';

  @override
  String get appSubtitle => 'DOPAMİN DETOKSU';

  @override
  String get taglineSessionsZero => 'Detoksun şimdi başlıyor.';

  @override
  String get taglineStreakZero => 'Serini bugün yeniden kur.';

  @override
  String get taglineStreakLt3 => 'İvmeyi koru.';

  @override
  String get taglineStreakLt7 => 'Odağın keskinleşiyor.';

  @override
  String get taglineStreakGe7 => 'Kontrol sende.';

  @override
  String get dopamineScoreTitle => 'DOPAMİN SKORU';

  @override
  String get dopamineLabel0 => 'İlk oturumunu başlat.';

  @override
  String get dopamineLabel20 => 'Detoks yolculuğun başladı.';

  @override
  String get dopamineLabel45 => 'Zihinsel direnç oluşuyor.';

  @override
  String get dopamineLabel70 => 'Berraklığın artıyor.';

  @override
  String get dopamineLabel90 => 'Güçlü odak ve disiplin.';

  @override
  String get dopamineLabel100 => 'Zihinsel berraklık zirvede.';

  @override
  String get dayStreakSuffix => 'gün seri';

  @override
  String bestStreak(int days) {
    return 'En iyi: $days gün';
  }

  @override
  String get todayLabel => 'BUGÜN';

  @override
  String get focusTimeStatLabel => 'Odak süresi';

  @override
  String get sessionsDoneStatLabel => 'Tamamlanan oturum';

  @override
  String get heroTitle => 'Monk Mode\'a gir.';

  @override
  String get startMonkMode => 'MONK MODE BAŞLAT';

  @override
  String get focusTogether => 'BİRLİKTE ODAK';

  @override
  String get circleJourneySection => 'ÇEMBER YOLCULUĞU';

  @override
  String get settingsTooltip => 'Ayarlar';

  @override
  String get statsTooltip => 'İstatistikler';

  @override
  String get joinRoomNotFoundCloud =>
      'Bu kod için açık lobi yok veya ev sahibi başlattı/ayrıldı.';

  @override
  String get joinRoomNotFoundLocal =>
      'Burada lobi yok. Bu telefonda oda oluşturup kodla katılın.';

  @override
  String get joinRoomNetworkError =>
      'Sunucuya ulaşılamadı. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get resetDataMessage =>
      'Seri, skor, istatistikler, oturum geçmişi, süre çipleri ve bu cihazdaki Birlikte Odak adınız silinir. Bulut odaları kullanıyorsanız yeni anonim hesap alırsınız. Geri alınamaz.';

  @override
  String get settingsTitle => 'AYARLAR';

  @override
  String get settingsFocus => 'ODAK';

  @override
  String get settingsLegal => 'YASAL';

  @override
  String get settingsData => 'VERİ';

  @override
  String get settingsResetCleared => 'Tüm yerel veriler silindi.';

  @override
  String get settingsLanguage => 'DİL';

  @override
  String get languageEnglishName => 'İngilizce';

  @override
  String get languageTurkishName => 'Türkçe';

  @override
  String get languagePickerSubtitle => 'İsteğe bağlı — varsayılan İngilizce.';

  @override
  String get updateScreenAppBar => 'GÜNCELLEME';

  @override
  String get updateAvailableTitle => 'Güncelleme mevcut';

  @override
  String get updateRequiredTitle => 'Güncelleme gerekli';

  @override
  String get updateAvailableBody =>
      'Monk Mode’un mağazada daha yeni bir sürümü var. En son düzeltme ve iyileştirmeler için güncelleyin.';

  @override
  String get updateRequiredBody =>
      'Bu sürüm artık desteklenmiyor. Devam etmek için mağazadan en son Monk Mode’u yükleyin.';

  @override
  String updateInstalledVersion(String version) {
    return 'Yüklü: $version';
  }

  @override
  String updateStoreVersion(String version) {
    return 'Mağaza: $version';
  }

  @override
  String get updateOpenStore => 'MAĞAZADA GÜNCELLE';

  @override
  String get updateNotNow => 'ŞİMDİ DEĞİL';

  @override
  String get updateStoreOpenFailed =>
      'Mağaza açılamadı. Tekrar deneyin veya uygulama sayfasını elle açın.';

  @override
  String get updateVersionStatusTitle => 'SÜRÜMLER';

  @override
  String get updateYouAreOn => 'Bu cihazda';

  @override
  String get updateLatestIs => 'Mağazadaki sürüm';

  @override
  String get updateBadgeRequired => 'ZORUNLU';

  @override
  String get updateBadgeRecommended => 'ÖNERİLEN';

  @override
  String get updateReleaseNotesTitle => 'DETAY';

  @override
  String get updateOpenStoreHint =>
      'Güncellemeyi yüklemek için Google Play veya App Store açılır.';

  @override
  String get updateTapToOpenStore =>
      'Güncellemeyi yüklemek için ekrana dokunun; mağaza açılır.';

  @override
  String get settingsCheckForUpdates => 'Güncellemeyi kontrol et';

  @override
  String get settingsCheckForUpdatesSubtitle =>
      'Mağazada daha yeni sürüm var mı bakar';

  @override
  String get settingsAppUpToDate => 'Uygulama güncel.';

  @override
  String get settingsSessionChipsTitle => 'Oturum süresi çipleri';

  @override
  String get settingsPrivacyTitle => 'Gizlilik politikası';

  @override
  String get settingsPrivacySubtitle => 'Verilerinizi nasıl işlediğimiz';

  @override
  String get settingsResetTitle => 'Tüm verileri sıfırla';

  @override
  String get settingsResetSubtitle =>
      'Bu cihazdaki istatistik ve geçmişi temizle';

  @override
  String get settingsLinkOpenFailed => 'Bağlantı açılamadı.';

  @override
  String get resetDialogTitle => 'Tüm veriler silinsin mi?';

  @override
  String get resetDialogCancel => 'İPTAL';

  @override
  String get resetDialogConfirm => 'SIFIRLA';

  @override
  String get durationPresetsTitle => 'ODAK SÜRELERİ';

  @override
  String get durationPresetsIntro =>
      'Zamanlayıcı ekranı için üç süre seçin. Hepsi farklı olmalı.';

  @override
  String get durationPresetsFirst => 'BİRİNCİ ÇİP';

  @override
  String get durationPresetsSecond => 'İKİNCİ ÇİP';

  @override
  String get durationPresetsThird => 'ÜÇÜNCÜ ÇİP';

  @override
  String get durationPresetsSave => 'KAYDET';

  @override
  String get durationPresetsDistinctError => 'Üç farklı süre seçin.';

  @override
  String durationMinutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String durationHoursShort(int hours) {
    return '$hours sa';
  }

  @override
  String durationHoursMinutesShort(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String get durationZeroCompact => '0 dk';

  @override
  String get statsTitle => 'İSTATİSTİK';

  @override
  String get statsYourStats => 'İSTATİSTİKLERİN';

  @override
  String get statsStreakJourney => 'SERİ YOLCULUĞU';

  @override
  String get statsOutOf100 => '/ 100';

  @override
  String get statsCurrentStreak => 'Güncel seri';

  @override
  String get statsCompleted => 'Tamamlanan';

  @override
  String get statsTotalFocus => 'Toplam odak';

  @override
  String get statsBestStreak => 'En iyi seri';

  @override
  String get statsUnitDay => 'gün';

  @override
  String get statsUnitDays => 'gün';

  @override
  String get statsUnitSession => 'oturum';

  @override
  String get statsUnitSessions => 'oturum';

  @override
  String statsLastSession(String date) {
    return 'Son oturum: $date';
  }

  @override
  String get statsSessionHistoryTitle => 'Oturum geçmişi';

  @override
  String get statsSessionHistorySubtitle => 'Tamamlanan her odak oturumunu gör';

  @override
  String get statsEmptyTitle => 'Henüz oturum yok';

  @override
  String get statsEmptyBody =>
      'İstatistiklerini görmek için\nilk Monk Mode oturumunu tamamla.';

  @override
  String get statsMilestoneBeyond => '30 günü aştın — efsane!';

  @override
  String statsMilestoneOneDayTo(int next) {
    return '$next günlük hedefe 1 gün kaldı';
  }

  @override
  String statsMilestoneDaysTo(int days, int next) {
    return '$next günlük hedefe $days gün kaldı';
  }

  @override
  String get historyTitle => 'OTURUM GEÇMİŞİ';

  @override
  String get historyEmptyTitle => 'Henüz oturum yok';

  @override
  String get historyEmptyBody =>
      'Geçmişini oluşturmak için bir Monk Mode oturumu tamamla.';

  @override
  String historyRowDetail(String duration, String time) {
    return '$duration odak · $time';
  }

  @override
  String get monkLeaveTitle => 'Oturumdan çıkılsın mı?';

  @override
  String get monkLeaveBody =>
      'Zamanlayıcı hâlâ çalışıyor. Şimdi çıkarsan ilerleme kaybolur.';

  @override
  String get monkKeepGoing => 'DEVAM ET';

  @override
  String get monkLeaveAction => 'ÇIK';

  @override
  String get monkAppBarTitle => 'MONK MODE';

  @override
  String get monkBackHome => 'ANASAYFAYA DÖN';

  @override
  String get monkReady => 'HAZIR';

  @override
  String get monkFocus => 'ODAK';

  @override
  String get monkPaused => 'DURAKLATILDI';

  @override
  String get monkDone => 'BİTTİ';

  @override
  String get monkSelectDuration => 'SÜRE SEÇ';

  @override
  String get monkTestMode => 'TEST MODU';

  @override
  String get monkStartSession => 'OTURUMU BAŞLAT';

  @override
  String get monkReset => 'SIFIRLA';

  @override
  String get monkPause => 'DURAKLAT';

  @override
  String get monkResume => 'DEVAM';

  @override
  String get monkBgPauseSnackbar =>
      'Uygulamadan çıkınca odak durur. Devam etmek için DEVAM’a dokun.';

  @override
  String get monkStayAwakeHint =>
      'Odak sırasında ekran açık kalır; otomatik kilit süreyi durdurmaz. Başka uygulamaya geçmek hâlâ duraklatır.';

  @override
  String get monkCompleteTitle => 'Oturum tamamlandı';

  @override
  String get monkCompleteSubtitle => 'Harika odak. Böyle devam.';

  @override
  String get monkShareResult => 'SONUCU PAYLAŞ';

  @override
  String get monkShareSubject => 'Monk Mode oturumum';

  @override
  String get monkShareStatDuration => 'SÜRE';

  @override
  String get monkShareStatStreak => 'SERİ';

  @override
  String get monkShareStatScore => 'SKOR';

  @override
  String get monkShareTagline => '\"Keşiş gibi odaklan\"';

  @override
  String get monkShareStreakNew => 'Yeni başlangıç';

  @override
  String get monkShareStreakOne => '1 gün';

  @override
  String monkShareStreakMany(int days) {
    return '$days gün';
  }

  @override
  String get ftHubTitle => 'BİRLİKTE ODAK';

  @override
  String get ftHubHeadline => 'Birlikte odaklan';

  @override
  String get ftHubBodyOnline =>
      'Tek paylaşılan zamanlayıcı. Kodu paylaş; arkadaşlar ev sahibi başlatmadan katılsın.';

  @override
  String get ftHubBodyOffline =>
      'Bu cihazda oda başına bir zamanlayıcı. Diğer telefonlarla eşitlemek için Firebase ekleyin.';

  @override
  String get ftYourNameHeader => 'ODALARDAKİ ADIN';

  @override
  String get ftNameFieldHint => 'örn. Ali';

  @override
  String get ftNameHelp =>
      'Herkes listede bunu görür. Her telefona kısa bir etiket (#AB12) eklenir; benzer adlar ayırt edilir.';

  @override
  String get ftSaveName => 'ADI KAYDET';

  @override
  String get ftStartHere => 'BURADAN BAŞLA';

  @override
  String get ftCreateRoomTitle => 'Oda oluştur';

  @override
  String get ftCreateRoomSubtitle =>
      'Ev sahibi sensin — süreyi ayarla ve kodu paylaş';

  @override
  String get ftJoinRoomTitle => 'Kodla katıl';

  @override
  String get ftJoinRoomSubtitleOnline => 'Ev sahibinden gelen kodu gir';

  @override
  String get ftJoinRoomSubtitleOffline => 'Firebase açılana kadar aynı telefon';

  @override
  String get ftErrorNameEmpty => 'Arkadaşlarının tanıyacağı bir ad gir.';

  @override
  String get ftNameSavedSnackbar => 'Kaydedildi. Odada bu adın görünecek.';

  @override
  String get ftJoinAppBar => 'ODAYA KATIL';

  @override
  String get ftJoinEnterCode => 'Kodu gir';

  @override
  String get ftJoinCodeHelp =>
      'Genelde 8 karakter; büyük/küçük harf önemli değil.';

  @override
  String get ftJoinCodeSection => 'ODA KODU';

  @override
  String get ftJoinMinChars => 'En az 4 karakter gir.';

  @override
  String get ftJoinLobby => 'LOBİYE KATIL';

  @override
  String get ftJoinTypingHint =>
      'Yazmaya devam et — kodlar genelde 8 karakterdir.';

  @override
  String get ftCreateAppBar => 'YENİ ODA';

  @override
  String get ftCreateDurationQuestion => 'Blok ne kadar sürsün?';

  @override
  String get ftCreateDurationHelp =>
      'Başlatınca herkes aynı süreyi görür. Lobiden istediğin zaman çıkabilirsin.';

  @override
  String get ftNameOptionalSection => 'AD (İSTEĞE BAĞLI)';

  @override
  String get ftRoomNameHint => 'örn. Derin çalışma · Pazar';

  @override
  String get ftCreateOpenLobby => 'OLUŞTUR VE LOBİYE GİT';

  @override
  String get ftLobbyTitle => 'LOBİ';

  @override
  String get ftLobbyEmptyTitle => 'Aktif lobi yok';

  @override
  String get ftLobbyEmptyBody =>
      'Oda kapandı veya sıfırlandı. Tekrar oluşturmak veya katılmak için merkeze dön.';

  @override
  String get ftBackToHub => 'MERKEZE DÖN';

  @override
  String get ftDefaultRoomTitle => 'Odak odan';

  @override
  String get ftLobbyShareOnline =>
      'Aşağıdaki kodu paylaş; diğerleri telefonundan katılabilsin.';

  @override
  String get ftLobbyShareOffline => 'Bu kod yalnızca bu telefonda geçerli.';

  @override
  String get ftLobbyGuestWait =>
      'Ev sahibinin başlamasını bekle. Hazırsan hazır işaretle.';

  @override
  String get ftInThisRoom => 'BU ODADA';

  @override
  String get ftStartFocusTimer => 'ODAK ZAMANLAYICIYI BAŞLAT';

  @override
  String get ftImReady => 'HAZIRIM';

  @override
  String get ftSetToWaiting => 'BEKLEMEDE';

  @override
  String get ftLeaveLobby => 'LOBİDEN ÇIK';

  @override
  String get ftPhaseLobby => 'Beklemede';

  @override
  String get ftPhaseRunning => 'Canlı';

  @override
  String get ftPhaseEnded => 'Bitti';

  @override
  String get ftSessionBlockSuffix => 'blok';

  @override
  String ftLobbyHereCount(int count) {
    return '$count kişi';
  }

  @override
  String get ftLobbyMetaMiddle => ' · ';

  @override
  String get ftInSessionTitle => 'OTURUMDA';

  @override
  String get ftEndSessionAction => 'BİTİR';

  @override
  String get ftSharedFocusDefaultName => 'Paylaşılan odak';

  @override
  String ftInRoomCount(int count) {
    return 'Bu odada $count kişi';
  }

  @override
  String get ftTimerFocusLabel => 'ODAK';

  @override
  String get ftTogetherSection => 'BİRLİKTE';

  @override
  String get ftSessionSyncOnline =>
      'Herkes için aynı bitiş; güncellemeler odadan gelir.';

  @override
  String get ftSessionSyncOffline => 'Zamanlayıcı yalnızca bu cihazda.';

  @override
  String get ftSessionUpdating => 'Güncelleniyor…';

  @override
  String get ftBgSessionPausedSnackbar =>
      'Uygulama arka plandayken zamanlayıcı durdu. Kalan süre odayla eşitlendi.';

  @override
  String get ftStayAwakeHint =>
      'Oturum boyunca ekran uyanık kalır; otomatik kilit süreyi durdurmaz. Uygulamadan çıkmak yerelde yine duraklatır.';

  @override
  String get ftRoomCodeLabel => 'ODA KODU';

  @override
  String get ftCodeCopied => 'Kod kopyalandı';

  @override
  String get frCrossHubTitleOn => 'Eşlenen odalar';

  @override
  String get frCrossHubTitleOff => 'Yalnızca bu cihaz';

  @override
  String get frCrossJoinTitleOn => 'Başka telefondan katıl';

  @override
  String get frCrossJoinTitleOff => 'Çevrimdışı mod';

  @override
  String get frCrossLobbyTitleOn => 'Bu kodu paylaş';

  @override
  String get frCrossLobbyTitleOff => 'Bu kod';

  @override
  String get frCrossHubBodyOn =>
      'Oda oluştur, 8 karakterli kodu paylaş; arkadaşlar lobiyi açıkken Birlikte Odak → Katıl’ı açsın.';

  @override
  String get frCrossHubBodyOff =>
      'Bulut kapalı; odalar yalnızca bu telefonda. Cihazlar arası için Firebase yapılandırın.';

  @override
  String get frCrossJoinBodyOn =>
      'Kod eşleşmeli (harf/rakam; büyük/küçük harf fark etmez). Ev sahibi başlattıysa veya ayrıldıysa çalışmaz.';

  @override
  String get frCrossJoinBodyOff =>
      'Burada yalnızca bu telefonda oluşturulan oda açılır.';

  @override
  String get frCrossLobbyBodyOn =>
      'Herkes girdikten sonra Odağı başlat’a dokun. Katılım olmazsa kodu ve lobide olduğunu kontrol et.';

  @override
  String get frCrossLobbyBodyOff =>
      'Firebase yapılandırılana kadar bu kod yalnızca bu telefonda geçerli.';

  @override
  String get ftLeaveSessionTitle => 'Bu oturumdan çıkılsın mı?';

  @override
  String get ftLeaveSessionBody =>
      'Zamanlayıcı senin için durur ve oda bu cihazda kapanır. Canlı uygulamada başkaları devam edebilir — burada herkes için biter (mock).';

  @override
  String get ftKeepFocusing => 'ODAKTA KAL';

  @override
  String get ftEndSessionSheet => 'OTURUMU BİTİR';

  @override
  String get ftCircleHeadlineAllBadges => 'Tüm çember rozetleri açıldı';

  @override
  String get ftCircleHeadlineKeepFinishing => 'Birlikte tamamlamaya devam et';

  @override
  String get ftCircleHeadlineNextReady => 'Sonraki rozet hazır';

  @override
  String ftCircleOneSessionToBadge(String badge) {
    return '$badge için 1 oturum kaldı';
  }

  @override
  String ftCircleSessionsToBadge(int count, String badge) {
    return '$badge için $count oturum kaldı';
  }

  @override
  String get ftCircleSublineAllDone =>
      'İstediğin zaman grubunla dön — ritüel senin.';

  @override
  String get ftCircleSublineStart =>
      'Çember yolculuğuna başlamak için başkalarıyla tam oturum bitir.';

  @override
  String get ftBadgeAt1 => 'İlk ışık';

  @override
  String get ftBadgeAt3 => 'İvme';

  @override
  String get ftBadgeAt5 => 'Takım ritmi';

  @override
  String get ftBadgeAt10 => 'Çember gücü';

  @override
  String get ftBadgeAt15 => 'Derin kadro';

  @override
  String get ftBadgeAt25 => 'Odak çapası';

  @override
  String get ftBadgeAt50 => 'Çember efsanesi';

  @override
  String get ftChaseAt1 => 'İlk çember rozetine bir doğal tamamlanma kaldı.';

  @override
  String get ftChaseAt3 =>
      'Üç tamamlanma genelde grup alışkanlığının tutunduğu noktadır.';

  @override
  String get ftChaseAt5 => 'Beş oturumda paylaşılan odak normalleşmeye başlar.';

  @override
  String get ftChaseAt10 => 'İki haneli sayılar korunmaya değer — oda oda.';

  @override
  String get ftChaseAt15 => 'Yenilik dönemini geçtin — ritüeli canlı tut.';

  @override
  String get ftChaseAt25 => 'Çapa rozeti pes etmeyen gruplar içindir.';

  @override
  String get ftChaseAt50 => 'Bundan sonra kazanç alışkanlığın kendisi.';

  @override
  String get ftFooterFinishesOne => '1 doğal tamamlanma kaydı';

  @override
  String ftFooterFinishesMany(int count) {
    return '$count doğal tamamlanma kaydı';
  }

  @override
  String ftFooterAllDone(int count) {
    return '$count doğal tamamlanma — çemberinle ritüeli sürdür.';
  }

  @override
  String get summaryAppBarEarly => 'ÖZET';

  @override
  String get summaryAppBarDone => 'TAMAM';

  @override
  String get summaryHeadlineEarly => 'Ayrıldın';

  @override
  String get summaryHeadlineDone => 'Oturum tamamlandı';

  @override
  String get summarySubEarly => 'Erken bitirdiğinde oda kapandı.';

  @override
  String get summarySubNatural => 'Birlikte akışta kaldığın için harika.';

  @override
  String summaryEndedAt(String time) {
    return 'Bitiş: $time';
  }

  @override
  String get summaryDefaultRoom => 'Odak odası';

  @override
  String get summaryCompleted => 'TAMAMLANANLAR';

  @override
  String get summaryDidNotFinish => 'BİTİREMEYENLER';

  @override
  String get summaryCompletedEmptyTitle => 'Bu koşuda tamamlayan listelenmedi.';

  @override
  String get summaryCompletedEmptySubtitle =>
      'Oturum erken bittiğinde olabilir.';

  @override
  String get summaryBackMonk => 'MONK MODE’A DÖN';

  @override
  String get summaryFocusAgain => 'YENİDEN BİRLİKTE ODAK';

  @override
  String get summaryRewardsNatural => 'Monk Mode ödülleri';

  @override
  String get summaryRewardsEarly => 'Küçük toparlanma bonusu';

  @override
  String get summaryStreakLineOne =>
      '1 günlük seri · tek başına oturum gibi sayılır';

  @override
  String summaryStreakLineMany(int days) {
    return '$days günlük seri · tek başına oturum gibi sayılır';
  }

  @override
  String summaryClarityLine(int delta, String focus) {
    return 'Berraklık +$delta toplam ($focus odak)';
  }

  @override
  String summarySquadBonus(int bonus) {
    return 'Birlikte bitirdiğin için +$bonus takım bonusu.';
  }

  @override
  String summaryClarityNow(int score) {
    return 'Berraklık şimdi $score';
  }

  @override
  String summaryEarlyClarityLine(int delta) {
    return 'Berraklık +$delta (seri değişmedi)';
  }

  @override
  String get summaryEarlyHint =>
      'Seriyi ve büyük berraklık kazanımlarını almak için grupla tam oturum bitir.';

  @override
  String get summaryNextReturn => 'SONRAKİ DÖNÜŞ NEDENİ';

  @override
  String get ftMil1Title => 'İlk ışık';

  @override
  String get ftMil1Sub =>
      'Başkalarıyla tam bir oturum bitirdin. En zor adım buydu.';

  @override
  String get ftMil3Title => 'İvme';

  @override
  String get ftMil3Sub =>
      'Üç paylaşılan tamamlanma — grubun odağı alışkanlığa çeviriyor.';

  @override
  String get ftMil5Title => 'Takım ritmi';

  @override
  String get ftMil5Sub =>
      'Beş kez sonuna kadar kaldınız. Yoğunluktan önce tutarlılık.';

  @override
  String get ftMil10Title => 'Çember gücü';

  @override
  String get ftMil10Sub =>
      'On paylaşılan zafer. Çoğu insan bunu biriktiremez — gerçek bir şey inşa ediyorsun.';

  @override
  String get ftMil15Title => 'Derin kadro';

  @override
  String get ftMil15Sub =>
      'On beş doğal tamamlanma. Çemberin gerektiğinde hazır.';

  @override
  String get ftMil25Title => 'Odak çapası';

  @override
  String get ftMil25Sub =>
      'Yirmi beş paylaşılan oturum. Çoğunun yapamayacağı disiplin.';

  @override
  String get ftMil50Title => 'Çember efsanesi';

  @override
  String get ftMil50Sub =>
      'Elli doğal tamamlanma birlikte. Bu ekranı sakla — hak ettin.';

  @override
  String get settingsBackup => 'GOOGLE';

  @override
  String get backupSignInTitle => 'Google ile giriş yap';

  @override
  String get backupSignInSubtitle =>
      'Google hesabınla giriş yap; seri ve skor bulutta yedeklensin, uygulamayı silsen de geri gelir';

  @override
  String get backupSignedInTitle => 'Google yedekleme aktif';

  @override
  String backupSignedInSubtitle(String email) {
    return '$email olarak senkronize edildi';
  }

  @override
  String get backupSyncNow => 'ŞİMDİ YEDEKLE';

  @override
  String get backupSignOut => 'Yedekten çık';

  @override
  String get backupSignOutSubtitle => 'İstatistikler bu cihazda kalır';

  @override
  String get backupSignInFailed =>
      'Google ile giriş yapılamadı. Lütfen tekrar deneyin.';

  @override
  String get backupSignInDialogOk => 'TAMAM';

  @override
  String get backupSignInDialogDeveloperTitle => 'Google girişi (Android)';

  @override
  String get backupSignInDialogDeveloperBody =>
      'Google, bu sürümün imza sertifikasını Firebase projenizde tanımadığı için girişi kesti.\n\nUygulamayı Play’den yüklediysen: Play Console → uygulama → Yayın veya test → Uygulama bütünlüğü → Uygulama imzalama. Uygulama imzalama anahtarı sertifikası bölümündeki SHA-1’i kopyala (yükleme sertifikası değil). Firebase’de Proje ayarları → Android uygulama → Parmak izi ekle. Sonra google-services.json’u indirip android/app/ içine koy ve yeni sürüm yayınla.\n\nUSB’de kendi AAB/APK’ni kuruyorsan, android’de gradlew signingReport ile çıkan ilgili variant’ın SHA-1’ini ekle.';

  @override
  String get backupSignInDialogTokenTitle => 'Google girişi (jeton)';

  @override
  String get backupSignInDialogTokenBody =>
      'Uygulama Google’dan ID jetonu alamadı. SHA-1’ler ekliyken google-services.json’u yenileyin; lib/config/backup_sign_in_config.dart içinde Web client ID (json’da tür 3) olduğunu doğrulayın. Ardından yeni release derleyin.';

  @override
  String get backupSynced => 'İstatistikler Google\'a yedeklendi.';

  @override
  String get backupSyncFailed => 'Yedekleme başarısız. Bağlantını kontrol et.';

  @override
  String get backupRestoreTitle => 'Buluttan geri yükle?';

  @override
  String backupRestoreBody(int sessions, int streak) {
    return 'Google yedeğinde $sessions oturum ve $streak günlük seri var. Bu cihaza geri yüklensin mi? Mevcut yerel veriler silinecek.';
  }

  @override
  String get backupRestoreConfirm => 'GERİ YÜKLE';

  @override
  String get backupRestoreCancel => 'YERELDE KAL';

  @override
  String get backupRestored => 'İstatistikler Google yedeğinden geri yüklendi.';

  @override
  String get backupSignOutConfirmTitle => 'Yedekten çıkılsın mı?';

  @override
  String get backupSignOutConfirmBody =>
      'İstatistikler bu cihazda kalır ama artık Google ile senkronize edilmez.';

  @override
  String get backupSignOutConfirm => 'ÇIKIŞ YAP';

  @override
  String get backupSignOutCancel => 'İPTAL';
}
