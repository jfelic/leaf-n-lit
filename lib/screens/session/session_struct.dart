class Session {
  int lengthInSeconds;
  DateTime date;
  int pagesRead;
  // String bookTitle; implement later

  Session({
    required this.lengthInSeconds,
    required this.date,
    required this.pagesRead,
    // required this.bookTitle; implement later
  });


  // toMap() converts a Session object to a Map that Firestore can store
  Map<String, dynamic> toMap() {
    return {
      'lengthInSeconds': lengthInSeconds,  // store the int directly
      'date': date.toIso8601String(),      // convert DateTime to String
      'pagesRead': pagesRead,              // store the int directly
    };
  }

  // fromMap() creates a new Session object from Firestore data
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      lengthInSeconds: map['lengthInSeconds'] ?? 0, // if null, use 0
      date: DateTime.parse(map['date']), // convert String back to DateTime
      pagesRead: map['pagesRead'] ?? 0, // if null, use 0
    );
  }
}