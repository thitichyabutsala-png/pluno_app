const List<String> categoryKeys = <String>[
  'All',
  'Beach',
  'Mountain',
  'City',
  'Culture',
  'Adventure',
  'Budget'
];

class T {
  T(this.lang);
  final String lang;

  bool get th => lang == 'th';
  String greeting(String tab) {
    if (!th) {
      return <String, String>{
        'home': 'Good morning ✨',
        'discover': 'Explore',
        'saved': 'Your Collection',
        'profile': 'Profile',
      }[tab];
    }
    return <String, String>{
      'home': 'สวัสดีตอนเช้า ✨',
      'discover': 'สำรวจ',
      'saved': 'คอลเลกชันของคุณ',
      'profile': 'โปรไฟล์',
    }[tab];
  }

  String title(String tab) {
    if (!th) {
      return <String, String>{
        'home': 'Discover Trips',
        'discover': 'Trending Now',
        'saved': 'Saved Trips',
        'profile': 'My Profile',
      }[tab];
    }
    return <String, String>{
      'home': 'ค้นพบทริป',
      'discover': 'กำลังฮิต',
      'saved': 'ทริปที่บันทึก',
      'profile': 'โปรไฟล์ของฉัน',
    }[tab];
  }

  List<String> get categories => th
      ? <String>['ทั้งหมด', 'ชายหาด', 'ภูเขา', 'เมือง', 'วัฒนธรรม', 'ผจญภัย', 'ประหยัด']
      : categoryKeys;

  String nav(String tab) {
    if (!th) {
      return <String, String>{
        'home': 'Home',
        'discover': 'Discover',
        'saved': 'Saved',
        'profile': 'Profile',
      }[tab];
    }
    return <String, String>{
      'home': 'หน้าหลัก',
      'discover': 'ค้นหา',
      'saved': 'บันทึก',
      'profile': 'โปรไฟล์',
    }[tab];
  }

  String get noTrips => th ? 'ไม่พบทริป' : 'No trips found';
  String get startSaving => th ? 'เริ่มบันทึกทริปที่คุณชอบ' : 'Start saving trips you love';
  String get tryCategory => th ? 'ลองหมวดหมู่อื่น' : 'Try a different category';
  String get remixes => th ? 'รีมิกซ์' : 'remixes';
  String get duration => th ? 'ระยะเวลา' : 'Duration';
  String get budget => th ? 'งบประมาณ' : 'Budget';
  String get travelers => th ? 'นักเดินทาง' : 'Travelers';
  String get people => th ? 'คน' : 'people';
  String get itinerary => th ? 'ตารางเดินทาง' : 'Itinerary';
  String get places => th ? 'สถานที่' : 'Places';
  String get day => th ? 'วัน' : 'Day';
  String get saveTrip => th ? 'บันทึกทริป' : 'Save Trip';
  String get saved => th ? 'บันทึกแล้ว' : 'Saved';
  String get remixTrip => th ? 'รีมิกซ์ทริป' : 'Remix Trip';
}
