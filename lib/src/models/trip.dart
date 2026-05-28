class Activity {
  const Activity(this.time, this.title, this.location, this.type, [this.notes]);
  final String time;
  final String title;
  final String location;
  final String type;
  final String notes;
}

class DayPlan {
  const DayPlan(this.day, this.title, this.activities);
  final int day;
  final String title;
  final List<Activity> activities;
}

class Place {
  const Place(this.name, this.type, this.rating, this.tip);
  final String name;
  final String type;
  final double rating;
  final String tip;
}

class Creator {
  const Creator(this.name, this.handle, this.avatar);
  final String name;
  final String handle;
  final String avatar;
}

class Trip {
  Trip({
    this.id,
    this.destination,
    this.location,
    this.image,
    this.budget,
    this.duration,
    this.days,
    this.saved,
    this.saves,
    this.remixes,
    this.tags,
    this.description,
    this.creator,
    this.itinerary,
    this.places,
    this.tips,
  });

  final int id;
  final String destination;
  final String location;
  final String image;
  final String budget;
  final String duration;
  final int days;
  bool saved;
  final int saves;
  final int remixes;
  final List<String> tags;
  final String description;
  final Creator creator;
  final List<DayPlan> itinerary;
  final List<Place> places;
  final List<String> tips;
}
