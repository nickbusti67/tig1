import 'dart:math' as math;
import '../models/models.dart';

class RitualService {
  static final RitualService _instance = RitualService._internal();
  factory RitualService() => _instance;
  RitualService._internal();

  final math.Random _random = math.Random();

  // Mock questions database
  final List<RitualQuestion> _questions = const [
    RitualQuestion(
      id: 'q1',
      text: 'Se potessi rivivere un momento insieme, quale sceglieresti?',
      category: QuestionCategory.heart,
    ),
    RitualQuestion(
      id: 'q2',
      text: 'Qual è la cosa che ti fa sentire più amato/a da me?',
      category: QuestionCategory.heart,
    ),
    RitualQuestion(
      id: 'q3',
      text: 'Dove vedi il nostro amore tra dieci anni?',
      category: QuestionCategory.destiny,
    ),
    RitualQuestion(
      id: 'q4',
      text: 'Qual è il ricordo più prezioso del nostro primo incontro?',
      category: QuestionCategory.heart,
    ),
    RitualQuestion(
      id: 'q5',
      text: 'Se potessimo teletrasportarci ora, dove andresti con me?',
      category: QuestionCategory.destiny,
    ),
    RitualQuestion(
      id: 'q6',
      text: 'Cosa ti ha fatto innamorare di me all\'inizio?',
      category: QuestionCategory.heart,
    ),
    RitualQuestion(
      id: 'q7',
      text: 'Qual è il nostro super potere come coppia?',
      category: QuestionCategory.destiny,
    ),
    RitualQuestion(
      id: 'q8',
      text: 'Cosa vorresti che facessimo insieme che non abbiamo mai fatto?',
      category: QuestionCategory.mind,
    ),
  ];

  // Mock pact choices
  final List<PactChoice> _pactChoices = const [
    PactChoice(id: 'p1', optionA: 'Alba insieme', optionB: 'Tramonto insieme'),
    PactChoice(id: 'p2', optionA: 'Viaggiare', optionB: 'Restare a casa'),
    PactChoice(id: 'p3', optionA: 'Film romantico', optionB: 'Avventura'),
    PactChoice(id: 'p4', optionA: 'Mare', optionB: 'Montagna'),
    PactChoice(id: 'p5', optionA: 'Cena a lume di candela', optionB: 'Picnic sotto le stelle'),
    PactChoice(id: 'p6', optionA: 'Ballo lento', optionB: 'Passeggiata notturna'),
    PactChoice(id: 'p7', optionA: 'Cucinare insieme', optionB: 'Ordinare e coccolarsi'),
    PactChoice(id: 'p8', optionA: 'Lettera d\'amore', optionB: 'Messaggio vocale'),
    PactChoice(id: 'p9', optionA: 'Abbraccio lungo', optionB: 'Bacio dolce'),
    PactChoice(id: 'p10', optionA: 'Silenzio condiviso', optionB: 'Conversazione profonda'),
  ];

  // Mock challenges
  final List<RitualChallenge> _challenges = const [
    RitualChallenge(
      id: 'c1',
      text: 'Scrivi tre parole che descrivono cosa provi in questo momento per il tuo partner.',
      type: 'emotional',
      intensity: 1,
    ),
    RitualChallenge(
      id: 'c2',
      text: 'Registra un audio di 30 secondi dicendo cosa ami del vostro rapporto.',
      type: 'creative',
      intensity: 1,
    ),
    RitualChallenge(
      id: 'c3',
      text: 'Disegna un simbolo che rappresenta il vostro amore.',
      type: 'creative',
      intensity: 1,
    ),
    RitualChallenge(
      id: 'c4',
      text: 'Scrivi un haiku dedicato al tuo partner.',
      type: 'creative',
      intensity: 2,
    ),
    RitualChallenge(
      id: 'c5',
      text: 'Condividi una foto di qualcosa che ti ricorda il tuo partner oggi.',
      type: 'emotional',
      intensity: 1,
    ),
  ];

  // Poetic codex templates
  final List<String> _codexTemplates = const [
    'Nel giardino segreto delle anime, {tigre} e {quokka} hanno danzato sotto stelle di cristallo. Le loro parole, "{tigreWord}" e "{quokkaWord}", si sono intrecciate come rami di un albero antico, formando un simbolo di {symbol}.',
    'Due cuori battono all\'unisono nel tempio del silenzio. {tigre}, custode della fiamma, e {quokka}, guardiano della luce, hanno sigillato questo giorno con le parole sacre: "{tigreWord}" e "{quokkaWord}". Il loro legame brilla con intensità {percentage}%.',
    'Sotto il velo della notte, le anime di {tigre} e {quokka} si sono cercate e trovate. Con "{tigreWord}" e "{quokkaWord}" hanno scritto un nuovo capitolo nel Codex dell\'Amore Eterno. Simbolo rivelato: {symbol}.',
    'Le stelle hanno osservato mentre {tigre} e {quokka} compivano il loro rituale quotidiano. Le parole "{tigreWord}" e "{quokkaWord}" echeggeranno per sempre nelle sale del loro Codex personale. Compatibilità: {percentage}%.',
  ];

  RitualQuestion getTodaysQuestion() {
    return _questions[_random.nextInt(_questions.length)];
  }

  List<PactChoice> getPactChoices({bool extended = false}) {
    if (extended) {
      return _pactChoices;
    }
    return _pactChoices.take(5).toList();
  }

  RitualChallenge getTodaysChallenge() {
    return _challenges[_random.nextInt(_challenges.length)];
  }

  int calculateCompatibility(PattoPhase patto) {
    if (patto.choices.isEmpty) return 0;
    int aligned = patto.choices.where((c) => c.isAligned).length;
    return ((aligned / patto.choices.length) * 100).round();
  }

  CompatibilitySymbol getSymbol(int percentage) {
    if (percentage >= 80) return CompatibilitySymbol.star;
    if (percentage >= 60) return CompatibilitySymbol.circle;
    if (percentage >= 40) return CompatibilitySymbol.triangle;
    return CompatibilitySymbol.raven;
  }

  String generateCodexEntry({
    required String tigreName,
    required String quokkaName,
    required String tigreWord,
    required String quokkaWord,
    required int percentage,
    required CompatibilitySymbol symbol,
  }) {
    final template = _codexTemplates[_random.nextInt(_codexTemplates.length)];
    return template
        .replaceAll('{tigre}', tigreName)
        .replaceAll('{quokka}', quokkaName)
        .replaceAll('{tigreWord}', tigreWord)
        .replaceAll('{quokkaWord}', quokkaWord)
        .replaceAll('{percentage}', percentage.toString())
        .replaceAll('{symbol}', symbol.name);
  }

  // Mock current user
  User getCurrentUser() {
    return User(
      id: 'user1',
      email: 'tigre@example.com',
      displayName: 'Nick',
      role: UserRole.tigre,
      roomId: 'room1',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // Mock partner
  User getPartner() {
    return User(
      id: 'user2',
      email: 'quokka@example.com',
      displayName: 'Mary',
      role: UserRole.quokka,
      roomId: 'room1',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // Mock room
  Room getCurrentRoom() {
    return Room(
      id: 'room1',
      inviteCode: 'AMORE-2024',
      tigreUserId: 'user1',
      quokkaUserId: 'user2',
      isLocked: true,
      intimacyMode: false,
      figEndMode: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // Get current ritual
  DailyRitual? getCurrentRitual() {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    
    return DailyRitual(
      id: 'ritual_${now.day}_${now.month}',
      roomId: 'room1',
      date: now,
      currentPhase: RitualPhase.ilVelo,
      isWeekendExtended: isWeekend,
      veloPhase: VeloPhase(
        questionId: 'q1',
        question: getTodaysQuestion().text,
        category: QuestionCategory.heart,
      ),
    );
  }

  // Get past codex pages
  List<CodexPage> getCodexPages() {
    final pages = <CodexPage>[];
    final now = DateTime.now();
    
    for (int i = 1; i <= 7; i++) {
      final date = now.subtract(Duration(days: i));
      final percentage = 60 + _random.nextInt(40);
      final symbol = getSymbol(percentage);
      
      pages.add(CodexPage(
        id: 'page_$i',
        date: date,
        content: generateCodexEntry(
          tigreName: 'Nick',
          quokkaName: 'Mary',
          tigreWord: ['eternità', 'passione', 'luce', 'stelle'][_random.nextInt(4)],
          quokkaWord: ['amore', 'insieme', 'sempre', 'cuore'][_random.nextInt(4)],
          percentage: percentage,
          symbol: symbol,
        ),
        compatibilityPercentage: percentage,
        symbol: symbol,
      ));
    }
    
    return pages;
  }

  // Get ritual statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalRituals': 30,
      'streak': 7,
      'averageCompatibility': 78,
      'totalCodexPages': 30,
      'favoriteSymbol': CompatibilitySymbol.star,
    };
  }
}
