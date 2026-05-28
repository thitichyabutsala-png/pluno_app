import '../models/trip.dart';

List<Trip> initialTrips() {
  return <Trip>[
    Trip(
      id: 1,
      destination: 'Maldives Paradise',
      location: 'Maldives',
      image:
          'https://images.unsplash.com/photo-1603477849227-705c424d1d80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
      budget: '\$2,500',
      duration: '7 days',
      days: 7,
      saved: false,
      saves: 1243,
      remixes: 87,
      tags: <String>['Beach', 'Luxury', 'Romance'],
      description:
          'An unforgettable week in the crystal-clear waters of the Maldives, featuring overwater bungalows, world-class snorkeling, and breathtaking sunsets.',
      creator: Creator('Sofia Chen', '@sofiatravel', '🌺'),
      itinerary: <DayPlan>[
        DayPlan(1, 'Arrival & Sunset Bliss', <Activity>[
          Activity('2:00 PM', 'Check-in at Overwater Bungalow',
              'Conrad Maldives Rangali', 'hotel'),
          Activity('5:00 PM', 'Welcome cocktail & lagoon swim', 'Beach Bar',
              'coffee'),
          Activity('7:30 PM', 'Dinner at undersea restaurant',
              'Ithaa Undersea', 'food', 'Book 3 months in advance!'),
        ]),
        DayPlan(2, 'Snorkeling & Island Life', <Activity>[
          Activity('7:00 AM', 'Sunrise yoga on the deck', 'Bungalow Terrace',
              'activity'),
          Activity('10:00 AM', 'Guided reef snorkeling tour', 'House Reef',
              'activity', 'See manta rays and sea turtles'),
          Activity('4:00 PM', 'Dolphin watching sunset cruise', 'Open Ocean',
              'activity'),
        ]),
      ],
      places: <Place>[
        Place('Ithaa Undersea Restaurant', 'Fine Dining', 4.9,
            'The world\'s first all-glass undersea restaurant. Reserve months ahead.'),
        Place('House Reef Snorkel Spot', 'Water Activity', 4.8,
            'Best visibility at 7-9 AM. Wear reef-safe sunscreen.'),
        Place('Maafushi Island', 'Local Culture', 4.5,
            'Bring cash for market vendors. Respect local dress codes.'),
      ],
      tips: <String>[
        'Book seaplane transfers in advance.',
        'Pack reef-safe sunscreen.',
        'The best snorkeling is early morning.',
      ],
    ),
    Trip(
      id: 2,
      destination: 'Alpine Adventure',
      location: 'Swiss Alps, Switzerland',
      image:
          'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
      budget: '\$3,200',
      duration: '10 days',
      days: 10,
      saved: false,
      saves: 892,
      remixes: 124,
      tags: <String>['Mountain', 'Adventure', 'Nature'],
      description:
          'A thrilling alpine escape through the Swiss Alps with legendary trails, cable cars to snow-capped peaks, and cozy mountain chalets.',
      creator: Creator('Marco Valle', '@marcohikes', '🏔️'),
      itinerary: <DayPlan>[
        DayPlan(1, 'Zurich Arrival & Old Town', <Activity>[
          Activity('11:00 AM', 'Arrive Zurich Airport',
              'Zurich International Airport', 'transport'),
          Activity('4:00 PM', 'Stroll along Limmat River',
              'Niederdorf Quarter', 'activity'),
          Activity('7:00 PM', 'Traditional Swiss fondue dinner',
              'Hiltl Restaurant', 'food'),
        ]),
        DayPlan(2, 'Interlaken & Jungfrau', <Activity>[
          Activity('8:00 AM', 'Train to Interlaken',
              'Zurich HB to Interlaken', 'transport'),
          Activity('10:30 AM', 'Cable car to Jungfraujoch',
              'Top of Europe', 'activity', 'Wear warm layers.'),
          Activity('4:00 PM', 'Paragliding over the valley',
              'Beatenberg Launch Site', 'activity'),
        ]),
      ],
      places: <Place>[
        Place('Jungfraujoch', 'Mountain Peak', 4.9,
            'Go early to avoid crowds. Buy tickets in advance.'),
        Place('Bachalpsee Lake', 'Natural Wonder', 4.8,
            'A 2hr hike from Grindelwald First. Worth every step.'),
        Place('Interlaken Old Town', 'Town Center', 4.6,
            'Best shopping for Swiss watches and chocolates.'),
      ],
      tips: <String>[
        'Get the Swiss Travel Pass.',
        'Weather changes fast. Always pack a rain jacket.',
        'Download the SBB app for trains.',
      ],
    ),
    Trip(
      id: 3,
      destination: 'Brussels City Break',
      location: 'Brussels, Belgium',
      image:
          'https://images.unsplash.com/photo-1668428202528-bf3d5ed88560?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
      budget: '\$1,800',
      duration: '5 days',
      days: 5,
      saved: true,
      saves: 567,
      remixes: 43,
      tags: <String>['City', 'Culture', 'Food'],
      description:
          'A charming European city break through Brussels, packed with chocolates, craft beers, grand architecture, and Art Nouveau gems.',
      creator: Creator('Lea Moreau', '@leaexplores', '🍫'),
      itinerary: <DayPlan>[
        DayPlan(1, 'Grand-Place & Chocolate Trail', <Activity>[
          Activity('9:00 AM', 'Morning walk to Grand-Place',
              'Grand-Place, Brussels', 'activity'),
          Activity('11:00 AM', 'Chocolate tasting tour',
              'Neuhaus & Pierre Marcolini', 'food'),
          Activity('6:00 PM', 'Craft beer tasting', 'Delirium Cafe', 'coffee',
              'Over 3,000 beers on the menu'),
        ]),
        DayPlan(2, 'Museums & Art Nouveau', <Activity>[
          Activity('10:00 AM', 'Magritte Museum',
              'Royal Museums of Fine Arts', 'activity'),
          Activity('3:00 PM', 'Victor Horta Museum', 'Ixelles', 'activity',
              'Stunning Art Nouveau architecture'),
        ]),
      ],
      places: <Place>[
        Place('Grand-Place', 'UNESCO World Heritage', 4.9,
            'Visit at night when the buildings are lit up beautifully.'),
        Place('Delirium Cafe', 'Bar & Pub', 4.7,
            'Try a Trappist beer and go early for a table.'),
        Place('Bruges Old Town', 'Day Trip', 4.8,
            'Arrive before 11 AM to beat tourist crowds.'),
      ],
      tips: <String>[
        'Buy chocolates at Neuhaus, not tourist shops.',
        'Most museums are closed on Mondays.',
        'Use rail passes for Bruges and Ghent.',
      ],
    ),
    Trip(
      id: 4,
      destination: 'Thailand Beach Escape',
      location: 'Ko Samui, Thailand',
      image:
          'https://images.unsplash.com/photo-1535262412227-85541e910204?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
      budget: '\$1,400',
      duration: '6 days',
      days: 6,
      saved: false,
      saves: 2108,
      remixes: 215,
      tags: <String>['Beach', 'Budget', 'Food'],
      description:
          'Six sun-soaked days exploring Ko Samui: pristine beaches, incredible street food, elephant sanctuaries, and island nightlife.',
      creator: Creator('Alex Rivera', '@budgettravels', '🌴'),
      itinerary: <DayPlan>[
        DayPlan(1, 'Arrival & Beach Day', <Activity>[
          Activity('1:00 PM', 'Check-in at beachfront resort',
              'Chaweng Beach', 'hotel'),
          Activity('6:00 PM', 'Sunset cocktails', 'Beach Club Bar', 'coffee'),
          Activity('8:00 PM', 'Thai street food feast',
              'Chaweng Night Market', 'food', 'Pad Thai and mango sticky rice.'),
        ]),
        DayPlan(2, 'Elephant Sanctuary & Waterfalls', <Activity>[
          Activity('8:00 AM', 'Ethical Elephant Sanctuary visit',
              'Samui Elephant Home', 'activity'),
          Activity('12:00 PM', 'Jungle waterfall hike', 'Na Muang Waterfall',
              'activity'),
        ]),
      ],
      places: <Place>[
        Place('Chaweng Beach', 'Beach', 4.6,
            'Best swimming on the north end.'),
        Place('Na Muang Waterfall', 'Natural Attraction', 4.5,
            'Go in the morning to avoid crowds.'),
        Place('Ang Thong Marine Park', 'National Park', 4.9,
            'Book the full-day speedboat tour.'),
      ],
      tips: <String>[
        'Negotiate tuk-tuk prices before getting in.',
        'Download Grab for transparent pricing.',
        'Respect temple dress codes.',
      ],
    ),
  ];
}
